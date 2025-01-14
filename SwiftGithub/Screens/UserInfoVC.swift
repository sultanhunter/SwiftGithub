//
//  UserInfoVC.swift
//  SwiftGithub
//
//  Created by Sultan on 03/01/25.
//

import UIKit

class UserInfoVC: UIViewController {
    let follower: Follower
    var userData: User?
    var isLoading: Bool = false

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    init(follower: Follower) {
        self.follower = follower
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavBarItems()
        Task {
            await getUserData()
        }
    }

    private func showLoadingIndicator() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        spinner.startAnimating()
    }

    private func removeLoadingIndicator() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }

    private func setIsLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
        if isLoading {
            showLoadingIndicator()
        } else {
            removeLoadingIndicator()
        }
    }

    private func getUserData() async {
        do {
            setIsLoading(true)
            let userData = try await NetworkManager.shared.getUserData(for: follower.login)
            self.userData = userData
            print("User Data Fetched:\(userData.login)")

            addUIElements(user: userData)

            setIsLoading(false)

        } catch let error as SGError {
            setIsLoading(false)

            presentAlertOnMainThread(title: "Something went wrong", message: error.message.rawValue, buttonTitle: "Ok") { [weak self] in
                guard let self = self, self.navigationController != nil else { return }
                self.dismissVC()
            }
        } catch {
            setIsLoading(false)

            presentAlertOnMainThread(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Ok") { [weak self] in
                guard let self = self, self.navigationController != nil else { return }
                self.dismissVC()
            }
        }
    }

    private func addUIElements(user: User) {
        let headerView = SGUserInfoHeaderView(user: user)

        let containerOne = SGItemInfoView(user: user)
        let containerTwo = SGItemInfoView(user: user)
        containerOne.setData(type: .profile)
        containerTwo.setData(type: .followers)

        let uiScrollView = UIScrollView()

        let uiStackView = UIStackView(arrangedSubviews: [headerView, containerOne, containerTwo])
        uiStackView.axis = .vertical
        uiStackView.spacing = 10

        uiScrollView.addSubview(uiStackView)
        view.addSubview(uiScrollView)

        view.setTAMICFalse(views: headerView, containerOne, containerTwo, uiStackView, uiScrollView)

        NSLayoutConstraint.activate([
            uiStackView.topAnchor.constraint(equalTo: uiScrollView.contentLayoutGuide.topAnchor),
            uiStackView.leadingAnchor.constraint(equalTo: uiScrollView.frameLayoutGuide.leadingAnchor),
            uiStackView.trailingAnchor.constraint(equalTo: uiScrollView.frameLayoutGuide.trailingAnchor),
            uiStackView.bottomAnchor.constraint(equalTo: uiScrollView.contentLayoutGuide.bottomAnchor),

            uiScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            uiScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            uiScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            uiScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func configureNavBarItems() {
        if let appearance = navigationController?.navigationBar.standardAppearance {
            appearance.configureWithDefaultBackground()
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
