//
//  SGEmptyStateView.swift
//  SwiftGithub
//
//  Created by Sultan on 30/12/24.
//

import UIKit

class SGEmptyStateView: UIView {
    let messageLabel = SGTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        configure()
    }

    private func configure() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(messageLabel, logoImageView)

        messageLabel.numberOfLines = 0
        messageLabel.textColor = .secondaryLabel

        logoImageView.image = UIImage(named: "empty-state-logo")

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 200),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 140)
        ])

        print("empty state configured")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
