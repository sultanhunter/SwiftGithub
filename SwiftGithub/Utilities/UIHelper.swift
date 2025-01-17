//
//  UIHelper.swift
//  SwiftGithub
//
//  Created by Sultan on 28/12/24.
//

import UIKit

struct UIHelper {
    static func createThreeColumnFlowLayout(in view: UIView, showFooter: Bool) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)

        let itemWidth = availableWidth / 3

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

        flowLayout.footerReferenceSize = showFooter ? CGSize(width: view.frame.width, height: 100) : CGSize.zero

        return flowLayout
    }
}
