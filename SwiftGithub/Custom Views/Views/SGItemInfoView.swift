//
//  SGItemInfoView.swift
//  SwiftGithub
//
//  Created by Sultan on 15/01/25.
//

import UIKit

enum SGItemInfoViewType {
    case profile, followers
}

class SGItemInfoView: UIView {
    let user: User

    let itemInfoLabelOne = SGItemInfoLabelView()
    let itemInfoLabelTwo = SGItemInfoLabelView()
    let actionButton = SGButton()

    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        configureBackgroundView()
        layoutUI()
    }

    public func setData(type: SGItemInfoViewType) {
        switch type {
        case .profile:
            itemInfoLabelOne.set(itemInfoType: .repos, withCount: user.publicRepos)
            itemInfoLabelTwo.set(itemInfoType: .gists, withCount: user.publicGists)
            actionButton.setTitle("Github Profile", for: .normal)
            actionButton.backgroundColor = .systemIndigo

        case .followers:
            itemInfoLabelOne.set(itemInfoType: .followers, withCount: user.followers)
            itemInfoLabelTwo.set(itemInfoType: .following, withCount: user.following)
            actionButton.setTitle("Get Followers", for: .normal)
            actionButton.backgroundColor = .systemTeal
        }
    }

    private func configureBackgroundView() {
        layer.cornerRadius = 18
        backgroundColor = .secondarySystemBackground
    }

    private func layoutUI() {
        let rowStackView = UIStackView(arrangedSubviews: [itemInfoLabelOne, itemInfoLabelTwo])
        rowStackView.axis = .horizontal

        let columnStackView = UIStackView(arrangedSubviews: [rowStackView, actionButton])
        columnStackView.axis = .vertical
        columnStackView.spacing = 12

        addSubview(columnStackView)

        setTAMICFalse(views: rowStackView, columnStackView, itemInfoLabelOne, itemInfoLabelTwo, actionButton)

        layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        NSLayoutConstraint.activate([
            columnStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            columnStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            columnStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            columnStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
