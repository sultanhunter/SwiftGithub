//
//  SGUserInfoHeaderView.swift
//  SwiftGithub
//
//  Created by Sultan on 04/01/25.
//

import UIKit

class SGUserInfoHeaderView: UIView {
    let user: User

    let avatar = SGAvatarImageView(frame: .zero)
    let usernameLabel = SGTitleLabel(textAlignment: .left, fontSize: 34)
//    let nameLabel = SGSecondaryTitleLabel(fontSize: 18)
//    let locationImageView = UIImageView()
//    let locationLabel = SGSecondaryTitleLabel(fontSize: 18)
//    let bioLabel = SGBodyLabel(textAlignment: .left)

    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        backgroundColor = .systemPink

        configureConstraints()
        Task {
            await avatar.downloadAndSetImage(from: user.avatarUrl)
        }
    }

    private func configureConstraints() {
        addSubviews(avatar, usernameLabel)
        // addSubviews(avatar, usernameLabel, nameLabel, locationImageView, locationLabel, bioLabel)

        avatar.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false

//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        locationImageView.translatesAutoresizingMaskIntoConstraints = false
//        locationLabel.translatesAutoresizingMaskIntoConstraints = false
//        bioLabel.translatesAutoresizingMaskIntoConstraints = false

//        usernameLabel.numberOfLines = 0

        let padding: CGFloat = 20

        layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)

        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: topAnchor),
            avatar.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 90),
            avatar.heightAnchor.constraint(equalToConstant: 90),

            usernameLabel.topAnchor.constraint(equalTo: topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 50)

        ])

        Task {
            await avatar.downloadAndSetImage(from: user.avatarUrl)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
