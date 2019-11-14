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

    private var viewModel: TweetViewModel

    init(viewModel: TweetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        contentStackView.spacing = viewModel.stackViewSpacing
        rightColumnStackView.spacing = viewModel.stackViewSpacing

        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = viewModel.avatarCornerRadius
        avatarImageView.image = viewModel.avatarImage

        nicknameLabel.text = viewModel.nickname
        nicknameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nicknameLabel.textColor = UIColor(named: "tweet.nick.color")

        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 17)
        contentLabel.text = viewModel.content

        imageGridView.imageGrid = viewModel.imageGrid
        commentListView.comments = viewModel.comments
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
