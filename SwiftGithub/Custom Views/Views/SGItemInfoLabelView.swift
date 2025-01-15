//
//  SGItemInfoView.swift
//  SwiftGithub
//
//  Created by Sultan on 15/01/25.
//

import UIKit

enum ItemInfoType {
    case repos, gists, followers, following
}

class SGItemInfoLabelView: UIView {
    let symbolImageView = UIImageView()
    let titleLabel = SGTitleLabel(textAlignment: .left, fontSize: 14)
    let countLable = SGTitleLabel(textAlignment: .center, fontSize: 14)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        let rowStackView = UIStackView(arrangedSubviews: [symbolImageView, titleLabel])
        rowStackView.axis = .horizontal
        rowStackView.spacing = 12

        let columnStackView = UIStackView(arrangedSubviews: [rowStackView, countLable])
        columnStackView.axis = .vertical
        columnStackView.spacing = 4
        columnStackView.alignment = .leading

        addSubview(columnStackView)
        setTAMICFalse(views: rowStackView, columnStackView, self.symbolImageView, self.titleLabel, self.countLable)

        self.symbolImageView.contentMode = .scaleAspectFill
        self.symbolImageView.tintColor = .label

        NSLayoutConstraint.activate([
            self.symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            self.symbolImageView.widthAnchor.constraint(equalToConstant: 20),

            columnStackView.topAnchor.constraint(equalTo: topAnchor),
            columnStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            columnStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            columnStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

        ])
    }

    public func set(itemInfoType: ItemInfoType, withCount count: Int) {
        switch itemInfoType {
        case .repos:
            self.symbolImageView.image = UIImage(systemName: SFSymbols.repos)
            self.titleLabel.text = "Public Repos"
            self.countLable.text = String(count)

        case .gists:
            self.symbolImageView.image = UIImage(systemName: SFSymbols.gist)
            self.titleLabel.text = "Public Gists"
            self.countLable.text = String(count)

        case .followers:
            self.symbolImageView.image = UIImage(systemName: SFSymbols.followers)
            self.titleLabel.text = "Followers"
            self.countLable.text = String(count)

        case .following:
            self.symbolImageView.image = UIImage(systemName: SFSymbols.following)
            self.titleLabel.text = "Following"
            self.countLable.text = String(count)
        }
    }
}
