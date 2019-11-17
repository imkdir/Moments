//
// Created by Tung CHENG on 11/14/19.
// Copyright (c) 2019 Objective-CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TweetViewController: UIViewController {
    private let avatarImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let contentLabel = UILabel()
    private let imageGridView = ImageGridView()
    private let commentListView = CommentListView()

    private lazy var rightColumnStackView: UIStackView = {
        UIStackView(arrangedSubviews: [nicknameLabel, contentLabel, imageGridView, commentListView])
    }()
    private lazy var contentStackView: UIStackView = {
        UIStackView(arrangedSubviews: [avatarImageView, rightColumnStackView])
    }()

    private var viewModel: TweetViewModel
    private var disposeBag = DisposeBag()

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
        addReactiveBinding()
    }
    
    private func setupViewHierarchy() {
        view.addSubview(contentStackView)
    }

    private func configureAppearance() {
        contentStackView.spacing = stackViewSpacing
        rightColumnStackView.spacing = stackViewSpacing

        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarCornerRadius
        
        nicknameLabel.text = viewModel.nickname
        nicknameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        nicknameLabel.textColor = #colorLiteral(red: 0.3114843965, green: 0.4081265032, blue: 0.5782492161, alpha: 1)

        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 17)
    }
    
    private func addReactiveBinding() {
        contentLabel.text = viewModel.content
        contentLabel.isHidden = viewModel.isContentLabelHidden
        
        imageGridView.gridLayout = viewModel.gridLayout
        imageGridView.isHidden = viewModel.isImageGridHidden
        
        commentListView.comments = viewModel.comments
        commentListView.isHidden = viewModel.isCommentListHidden
        
        viewModel
            .rx.avatarImage
            .bind(to: avatarImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel
            .rx.indexedImage
            .bind(to: imageGridView.rx.indexedImage)
            .disposed(by: disposeBag)
    }

    private func addViewConstraints() {

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.set(.width, to: avatarSize).isActive = true
        avatarImageView.aspect(ratio: 1).isActive = true
        
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        imageGridView.translatesAutoresizingMaskIntoConstraints = false
        commentListView.translatesAutoresizingMaskIntoConstraints = false

        rightColumnStackView.translatesAutoresizingMaskIntoConstraints = false
        rightColumnStackView.axis = .vertical
        rightColumnStackView.alignment = .fill

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.edges(equal: view, edgeInsets: edgeInsets)
        contentStackView.axis = .horizontal
        contentStackView.alignment = .top
    }
    
    private let stackViewSpacing: CGFloat = 10
    private let avatarCornerRadius: CGFloat = 4
    private let avatarSize: CGFloat = 40
    private let edgeInsets: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
}
