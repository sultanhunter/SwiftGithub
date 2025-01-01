//
//  UIViewController+Ext.swift
//  SwiftGithub
//
//  Created by Sultan on 25/12/24.
//

import UIKit

extension UIViewController {
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertVC = SGAlertVC(title: title, message: message, buttonTitle: buttonTitle, completion: completion)
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
