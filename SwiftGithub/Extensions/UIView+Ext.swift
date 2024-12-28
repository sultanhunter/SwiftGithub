//
//  UIView+Ext.swift
//  SwiftGithub
//
//  Created by Sultan on 28/12/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
