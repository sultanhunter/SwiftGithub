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
    var searchedFollowers: [Follower] = []

    var isSearchActive: Bool { !searchedFollowers.isEmpty }

    var previousPage = 0
    var nextPage = 1
    var nextPageAvailable = true
    var isLoading = false

    var loadingIndicator = FooterLoadingView()

    let padding: CGFloat = 12

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
        Task {
            configureAndShowLoadingView()
            await getFollowers(for: userName, page: nextPage)
        }
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

    private func configureAndShowLoadingView() {
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 100),
            loadingIndicator.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        loadingIndicator.startAnimating()
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())

        collectionView?.isHidden = true

        collectionView?.delegate = self
        collectionView?.backgroundColor = .systemBackground
        collectionView?.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
        collectionView?.register(FooterLoadingView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterLoadingView.indentifier)

        view.addSubview(collectionView!)
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

    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController

        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func hideLoadingView() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperViewOnMain()
    }

    private func showCollectionView() {
        collectionView?.isHidden = false
    }

    private func updateData(with followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)

        DispatchQueue.main.async { [weak self] in
            self?.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }

    private func getFollowers(for userName: String, page: Int) async {
        do {
            guard nextPageAvailable,!isLoading, nextPage != previousPage else { return }

            setIsLoading(true)

            let data = try await NetworkManager.shared.getFollowers(for: userName, page: page)
            followers.append(contentsOf: data)

            if followers.isEmpty {
                let message = "This users doesn't have any followers. Go follow them 😄"
                hideLoadingView()
                showEmptyView(with: message, in: view)
            } else {
                if isSearchActive {
                    if let searchText = navigationItem.searchController?.searchBar.text, !searchText.isEmpty {
                        applySearch(with: searchText)
                    }
                } else {
                    updateData(with: followers)
                }

                hideLoadingView()
                showCollectionView()
            }

            if data.count == 100 {
                previousPage += 1
                nextPage += 1
            } else {
                nextPageAvailable = false
            }
            setIsLoading(false)
        } catch let error as SGError {
            setIsLoading(false)
            presentAlertOnMainThread(title: "Something went wrong", message: error.message.rawValue, buttonTitle: "Ok") { [weak self] in
                guard let self = self, self.navigationController != nil else { return }
                popToSearchVC(self.navigationController!)
            }
        } catch {
            setIsLoading(false)
            presentAlertOnMainThread(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Ok") { [weak self] in
                guard let self = self, self.navigationController != nil else { return }
                popToSearchVC(self.navigationController!)
            }
        }
    }

    private func popToSearchVC(_ navigationController: UINavigationController) {
        if let vc = navigationController.viewControllers.first(where: { $0 is SearchVC }) {
            navigationController.popToViewController(vc as! SearchVC, animated: true)
        }
    }

    private func setIsLoading(_ isLoading: Bool) {
        self.isLoading = isLoading

        // so that footer size calculation function can be run after we change isLoading
        collectionView?.collectionViewLayout.invalidateLayout()
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

        if contentHeight > 0 && offsetY >= contentHeight - height - 240 {
            print("reached bottom,isSearchActive:\(isSearchActive)")
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
        if nextPageAvailable && isLoading {
            return CGSize(width: collectionView.frame.width, height: 100)
        }

        return .zero
    }
}

extension FollowersListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            resetSearch()
            return
        }

        applySearch(with: searchText)
    }

    private func applySearch(with searchedText: String) {
        searchedFollowers = followers.filter { $0.login.lowercased().contains(searchedText.lowercased()) }
        updateData(with: searchedFollowers)
    }

    private func resetSearch() {
        print("Reseting search")
        searchedFollowers = []
        updateData(with: followers)
    }
}
