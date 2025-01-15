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
        // Header View
        let headerView = SGUserInfoHeaderView(user: user)

        // Two Info Cards
        let containerOne = SGItemInfoView(user: user)
        let containerTwo = SGItemInfoView(user: user)
        containerOne.setData(type: .profile)
        containerTwo.setData(type: .followers)

        // Wrapping Two Cards with Padding
        let paddingViewOne = SGPaddingView(padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20),
                                           child: containerOne)
        let paddingViewTwo = SGPaddingView(padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20),
                                           child: containerTwo)

        // Main Column
        let uiStackView = UIStackView(arrangedSubviews: [headerView, paddingViewOne, paddingViewTwo])
        uiStackView.axis = .vertical
        uiStackView.spacing = 20

        // Wrapping Column with ScrollView
        let uiScrollView = UIScrollView()
        uiScrollView.addSubview(uiStackView)
        view.addSubview(uiScrollView)

        // Setting Tamic of every object we created to false
        view.setTAMICFalse(views: paddingViewOne, paddingViewTwo, containerOne, containerTwo, headerView, uiStackView, uiScrollView)

        // Constraints
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
