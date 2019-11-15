//
// Created by Tung CHENG on 11/14/19.
// Copyright (c) 2019 Objective-CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: UIViewController {
    private let profileImageView = UIImageView()
    private let avatarImageView = UIImageView()
    private let nicknameLabel = UILabel()

    private var viewModel: UserViewModel
    private var disposeBag = DisposeBag()

    init(viewModel: UserViewModel) {
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
        view.addSubview(profileImageView)
        view.addSubview(avatarImageView)
        view.addSubview(nicknameLabel)
    }

    private func configureAppearance() {
        view.clipsToBounds = false
        
        profileImageView.backgroundColor = UIColor(named: "tableview.background")
        viewModel.rx.profileImage.bind(to: profileImageView.rx.image).disposed(by: disposeBag)

        viewModel.rx.avatarImage.bind(to: avatarImageView.rx.image).disposed(by: disposeBag)
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 10

        nicknameLabel.text = viewModel.nickname
        nicknameLabel.textColor = .white
        nicknameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        nicknameLabel.shadowColor = .darkGray
        nicknameLabel.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private func addViewConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false

        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true

        view.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: margin).isActive = true
        avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: avatarSize).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: avatarImageOffsetY).isActive = true

        nicknameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: margin).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: avatarLeadingMargin).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: nickLabelBottomMargin).isActive = true
    }
    
    private let margin: CGFloat = 16
    private let avatarSize: CGFloat = 70
    private let avatarImageOffsetY: CGFloat = 20
    private let avatarLeadingMargin: CGFloat = 20
    private let nickLabelBottomMargin: CGFloat = 8
}
