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
    let nameLabel = SGSecondaryTitleLabel(fontSize: 18)
    let locationImageView = UIImageView()
    let locationLabel = SGSecondaryTitleLabel(fontSize: 18)
    let bioLabel = SGBodyLabel(textAlignment: .left)

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
        // Creating Row for location image & name
        let locationRow = UIStackView(arrangedSubviews: [locationImageView, locationLabel])
        locationRow.axis = .horizontal
        locationRow.spacing = 2

        // Creating column for vertical info
        let nameColumn = UIStackView(arrangedSubviews: [usernameLabel, nameLabel, locationRow])
        nameColumn.axis = .vertical
        nameColumn.alignment = .leading
        nameColumn.spacing = 2

        // Creating row to have avatar & vertical info
        let upperRow = UIStackView(arrangedSubviews: [avatar, nameColumn])
        upperRow.axis = .horizontal
        upperRow.alignment = .center
        upperRow.spacing = 12

        // Creating Column for whole view
        let wholeColumn = UIStackView(arrangedSubviews: [upperRow, bioLabel])

        // have to add wholeColumn explicitly to subview as its last uistackview and all above uistackview gets automatically added to subview when passing to arrangedSubviews property of a uistackview
        addSubview(wholeColumn)
        wholeColumn.axis = .vertical
        wholeColumn.alignment = .center
        wholeColumn.spacing = 20

        // Setting TAMIC to false
        avatar.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        locationRow.translatesAutoresizingMaskIntoConstraints = false
        nameColumn.translatesAutoresizingMaskIntoConstraints = false
        upperRow.translatesAutoresizingMaskIntoConstraints = false
        wholeColumn.translatesAutoresizingMaskIntoConstraints = false

        // Setting username
        usernameLabel.numberOfLines = 0
        usernameLabel.text = user.login

        // Setting name
        nameLabel.text = user.name
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail

        // Setting locationImage image
        locationImageView.image = UIImage(named: "location")

        // Setting location name
        locationLabel.text = user.location
        locationLabel.numberOfLines = 1
        locationLabel.lineBreakMode = .byTruncatingTail

        // Setting bio text
        bioLabel.text = user.bio

        // Whole View Constraints
        let padding: CGFloat = 20

        layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)

        NSLayoutConstraint.activate([
            avatar.heightAnchor.constraint(equalToConstant: 90),
            avatar.widthAnchor.constraint(equalToConstant: 90),

            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),

            wholeColumn.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            wholeColumn.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            wholeColumn.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            wholeColumn.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
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
