//
//  UIViewController+Ext.swift
//  SwiftGithub
//
//  Created by Sultan on 25/12/24.
//

import UIKit

extension UIViewController {
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = SGAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }

    func showEmptyView(with message: String, in view: UIView) {
        view.subviews.forEach {
            if $0 is SGEmptyStateView {
                $0.removeFromSuperViewOnMain()
            }
        }
        let emptyView = SGEmptyStateView(message: message)
        emptyView.frame = view.frame
        view.addSubviewOnMain(emptyView)
    }
}
