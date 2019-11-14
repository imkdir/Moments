//
// Created by Tung CHENG on 11/14/19.
// Copyright (c) 2019 Objective-CHENG. All rights reserved.
//

import UIKit

final class TweetViewController: UIViewController {
    private let avatarImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let contentLabel = UILabel()
    private let imageGridView = ImageGridView()
    private let commentListView = CommentListView()

    private var rightColumnStackView: UIStackView!
    private var contentStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewHierarchy()
        configureAppearance()
        addViewConstraints()
    }

    private func setupViewHierarchy() {
        rightColumnStackView = UIStackView(arrangedSubviews: [nicknameLabel, contentLabel, imageGridView, commentListView])
        contentStackView = UIStackView(arrangedSubviews: [avatarImageView, rightColumnStackView])
        view.addSubview(contentStackView)
    }

    private func configureAppearance() {
        contentStackView.spacing = 10
        rightColumnStackView.spacing = 10
        // TODO: remove prototype properties
        
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 4
        avatarImageView.backgroundColor = .lightGray

        nicknameLabel.text = "George Harrison"
        nicknameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nicknameLabel.textColor = UIColor(named: "tweet.nick.color")

        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 17)
        contentLabel.text = "I wrote a new song, called something. Here it is."

        // TODO: remove prototype
        imageGridView.imageGrid = ([
            [UIImage(), UIImage(), UIImage()],
            [UIImage(), UIImage(), UIImage()],
            [UIImage(), UIImage(), UIImage()]], CGSize(width: 80, height: 80))
        commentListView.comments = [
            ("You are as good as us now, @paulmccartney what do you think?", "John Lennon"),
            ("Fantastic! I will play it with ukelele.", "Paul McCartney")]
    }

    private func addViewConstraints() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        imageGridView.translatesAutoresizingMaskIntoConstraints = false
        commentListView.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor, multiplier: 1).isActive = true

        rightColumnStackView.translatesAutoresizingMaskIntoConstraints = false
        rightColumnStackView.axis = .vertical
        rightColumnStackView.alignment = .fill

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .horizontal
        contentStackView.alignment = .top
        
        contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        contentStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
    }
}
