//
//  SGAlertVC.swift
//  SwiftGithub
//
//  Created by Sultan on 25/12/24.
//

import UIKit

class SGAlertVC: UIViewController {
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let containerView = UIView()
    let titleLabel = SGTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = SGBodyLabel(textAlignment: .center)
    let actionButton = SGButton(backgroundColor: .systemPink, title: "Ok")

    let alertTitle: String
    let message: String
    let buttonTitle: String

    let padding: CGFloat = 20

    let completion: (() -> Void)?

    init(title: String, message: String, buttonTitle: String, completion: (() -> Void)?) {
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        configure()
    }

    private func configure() {
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureBodyLabel()
    }

    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor

        containerView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)

        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }

    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = alertTitle

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    private func configureActionButton() {
        containerView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)

        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.layoutMarginsGuide.bottomAnchor),
            actionButton.leadingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.trailingAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func configureBodyLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.text = message
        messageLabel.numberOfLines = 4

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
        completion?()
    }
}
