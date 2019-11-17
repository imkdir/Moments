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
        addReactiveBinding()
    }
    
    private func setupViewHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(avatarImageView)
        view.addSubview(nicknameLabel)
    }

    private func configureAppearance() {
        view.clipsToBounds = false
        
        profileImageView.backgroundColor = .profileBackground
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true

        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 10
        avatarImageView.backgroundColor = .white
        avatarImageView.contentMode = .scaleAspectFit

        nicknameLabel.textAlignment = .right
        nicknameLabel.textColor = .white
        nicknameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        nicknameLabel.shadowColor = .darkGray
        nicknameLabel.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private func addReactiveBinding() {
        nicknameLabel.text = viewModel.nickname
        
        viewModel
            .rx.profileImage
            .bind(to: profileImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel
            .rx.avatarImage
            .bind(to: avatarImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    private func addViewConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false

        profileImageView.edges(equal: view)
        
        view.align(.trailing, to: avatarImageView, offset: margin).isActive = true
        avatarImageView.aspect(ratio: 1).isActive = true
        avatarImageView.set(.height, to: avatarSize).isActive = true
        avatarImageView.align(.bottom, to: view, offset: avatarImageOffsetY).isActive = true

        nicknameLabel.align(.leading, to: view, offset: margin).isActive = true
        avatarImageView.attach(to: nicknameLabel, padding: avatarLeadingMargin, direction: .horizontal).isActive = true
        view.align(.bottom, to: nicknameLabel, offset: nickLabelBottomMargin).isActive = true
    }
    
    private let margin: CGFloat = 16
    private let avatarSize: CGFloat = 70
    private let avatarImageOffsetY: CGFloat = 20
    private let avatarLeadingMargin: CGFloat = 20
    private let nickLabelBottomMargin: CGFloat = 8
}
