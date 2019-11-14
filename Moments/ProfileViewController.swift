//
// Created by Tung CHENG on 11/14/19.
// Copyright (c) 2019 Objective-CHENG. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let profileImageView = UIImageView()
    private let avatarImageView = UIImageView()
    private let nicknameLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewHierarchy()
        configureAppearance()
        addViewConstraints()
    }

    private func addViewConstraints() {
        // prepare for auto layout
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false

        // align four edges with superview
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        // put avatar at bottom left corner, with bottom offset
        // TODO: remove magic numbers
        view.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16).isActive = true
        avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true

        // put nickname at the left side of avatar, with bottom margin to superview
        nicknameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: 20).isActive = true
        view.bottomAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8).isActive = true
    }

    private func configureAppearance() {
        // prototype
        view.clipsToBounds = false

        profileImageView.backgroundColor = .lightGray

        avatarImageView.backgroundColor = .darkGray
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 10

        nicknameLabel.text = "John Doe"
        nicknameLabel.textColor = .white
        nicknameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nicknameLabel.shadowColor = .darkGray
        nicknameLabel.shadowOffset = CGSize(width: 0, height: 1)
    }

    private func setupViewHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(avatarImageView)
        view.addSubview(nicknameLabel)
    }
}
