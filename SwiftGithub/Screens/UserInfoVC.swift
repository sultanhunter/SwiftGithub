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

    private func setIsLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }

    private func getUserData() async {
        do {
            setIsLoading(true)
            let userData = try await NetworkManager.shared.getUserData(for: follower.login)
            self.userData = userData
            print("User Data Fetched:\(userData.login)")

            addHeaderViewInUI(user: userData)

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

    private func addHeaderViewInUI(user: User) {
        let headerView = SGUserInfoHeaderView(user: user)

        view.addSubview(headerView)

        headerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
