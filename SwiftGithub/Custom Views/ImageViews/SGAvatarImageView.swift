//
//  SGAvatarImageView.swift
//  SwiftGithub
//
//  Created by Sultan on 28/12/24.
//

import UIKit

class SGAvatarImageView: UIImageView {
    let placeholderImage = UIImage(named: "avatar-placeholder")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
    }

    func downloadAndSetImage(from urlString: String) async {
        do {
            let imageData = try await NetworkManager.shared.getImageData(from: urlString)
            guard let image = UIImage(data: imageData) else { return }

            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }

        } catch {}
    }
}
