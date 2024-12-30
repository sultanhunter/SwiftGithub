//
//  SearchVC.swift
//  SwiftGithub
//
//  Created by Sultan on 17/12/24.
//

import UIKit

class SearchVC: UIViewController {
    let logoImageView = UIImageView()
    let usernameTextField = SGTextField()

    let cta = SGButton(backgroundColor: .systemGreen, title: "Get Followers")

    var isUserNameEntered: Bool {
        guard let text = usernameTextField.text else { return false }
        return !text.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCta()
        createDismissKeyboardTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view.self, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }

    func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        logoImageView.image = UIImage(named: "gh-logo")

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    func configureTextField() {
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameTextField)
        usernameTextField.delegate = self
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configureCta() {
        cta.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cta)
        cta.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            cta.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            cta.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            cta.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            cta.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func pushFollowerListVC() {
        guard isUserNameEntered else {
            presentAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 😄.", buttonTitle: "Ok")
            return
        }
        let followersListVC = FollowersListVC(userName: usernameTextField.text ?? "")
        navigationController?.pushViewController(followersListVC, animated: true)
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
