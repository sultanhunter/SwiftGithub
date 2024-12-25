//
//  FollowersListVC.swift
//  SwiftGithub
//
//  Created by Sultan on 18/12/24.
//

import UIKit

class FollowersListVC: UIViewController {
    var userName: String

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    init(userName: String) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
