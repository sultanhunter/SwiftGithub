//
//  SGPaddingView.swift
//  SwiftGithub
//
//  Created by Sultan on 16/01/25.
//

import UIKit

class SGPaddingView: UIView {
    let padding: UIEdgeInsets
    let child: UIView

    init(padding: UIEdgeInsets, child: UIView) {
        self.padding = padding
        self.child = child
        super.init(frame: .zero)
        configure()
    }

    private func configure() {
        addSubview(child)
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            child.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
            child.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right),
            child.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom)

        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
