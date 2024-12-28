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

    let padding: CGFloat = 12

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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())

        view.addSubview(collectionView!)

        collectionView?.delegate = self
        collectionView?.backgroundColor = .systemBackground
        collectionView?.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
        collectionView?.register(FooterLoadingView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterLoadingView.indentifier)
    }

    // We are configuringDataSource manually and not conforming to it as UICollectionViewDiffableDataSource is not conformable
    // we can conform to simple UICollectionViewDataSource
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView!, cellProvider: { [weak self] _, indexPath, follower -> UICollectionViewCell in

            let cell = self?.collectionView?.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
            cell.set(follower: follower)

            return cell
        })

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView in
            guard kind == UICollectionView.elementKindSectionFooter, self?.nextPageAvailable ?? false else {
                return UICollectionReusableView()
            }

            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterLoadingView.indentifier, for: indexPath) as? FooterLoadingView
            else {
                fatalError("Unsupported")
            }
            footer.startAnimating()
            return footer
        }
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

extension FollowersListVC: UICollectionViewDelegateFlowLayout {
    /// CollectionViewPadding
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }

    /// Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = bounds.width - (padding * 2) - (minimumItemSpacing * 2)

        let itemWidth = availableWidth / 3

        return CGSize(width: itemWidth, height: itemWidth + 40)
    }

    /// Footer Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard nextPageAvailable else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}
