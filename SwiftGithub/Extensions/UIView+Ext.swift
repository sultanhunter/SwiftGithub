//
//  UIView+Ext.swift
//  SwiftGithub
//
//  Created by Sultan on 28/12/24.
//

import UIKit

extension UIView {
    func addSubviewOnMain(_ view: UIView) {
        DispatchQueue.main.async { [weak self] in
            self?.addSubview(view)
        }
    }

    func addSubviewsOnMain(_ views: UIView...) {
        DispatchQueue.main.async { [weak self] in
            views.forEach { self?.addSubview($0) }
        }
    }

    func removeFromSuperViewOnMain() {
        DispatchQueue.main.async { [weak self] in
            self?.removeFromSuperview()
        }
    }
}
