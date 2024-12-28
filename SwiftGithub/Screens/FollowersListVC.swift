//
//  FollowersListVC.swift
//  SwiftGithub
//
//  Created by Sultan on 18/12/24.
//

import UIKit

class FollowersListVC: UIViewController {
    enum Section {
        case main
    }

    let userName: String
    var collectionView: UICollectionView?
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>?

    var followers: [Follower] = []

    var nextPage = 1
    var nextPageAvailable = true
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    init(userName: String) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = userName
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))

        view.addSubview(collectionView!)

        collectionView?.delegate = self
        collectionView?.backgroundColor = .systemBackground
        collectionView?.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView!, cellProvider: { [weak self] _, indexPath, follower -> UICollectionViewCell in

            let cell = self?.collectionView?.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
            cell.set(follower: follower)

            return cell
        })
    }

    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)

        DispatchQueue.main.async { [weak self] in
            self?.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }

    private func getFollowers(for userName: String, page: Int) async {
        do {
            guard nextPageAvailable,!isLoading else { return }
            isLoading = true
            let data = try await NetworkManager.shared.getFollowers(for: userName, page: page)
            followers.append(contentsOf: data)

            updateData()

            if data.count == 100 {
                nextPage += 1
            } else {
                nextPageAvailable = false
            }
            isLoading = false
        } catch let error as SGError {
            presentAlertOnMainThread(title: "Something went wrong", message: error.message.rawValue, buttonTitle: "Ok")
            isLoading = false
        } catch {
            isLoading = false
            presentAlertOnMainThread(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Ok")
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FollowersListVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height

        if offsetY >= contentHeight - height - 240 {
            print("reached bottom")
            Task {
                await getFollowers(for: userName, page: nextPage)
            }
        }
    }
}
