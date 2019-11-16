//
//  RootViewController.swift
//  Moments
//
//  Created by Tung CHENG on 11/14/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ArielLite

final class RootViewController: UIViewController {
    private let tableView = UITableView()
    
    private lazy var headerView: UIView = {
        let size = UIScreen.main.bounds.width
        let headerFrame = CGRect(x: 0, y: 0, width: size, height: size)
        let headerView = UIView(frame: headerFrame)
        let vc = ProfileViewController(viewModel: userViewModel)
        self.addChild(vc)
        headerView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.edges(equal: headerView)
        vc.didMove(toParent: self)
        return headerView
    }()

    private var tweetListViewModel: TweetListViewModel
    private var userViewModel: UserViewModel
    private var disposeBag = DisposeBag()

    init(tweetListViewModel: TweetListViewModel, userViewModel: UserViewModel) {
        self.tweetListViewModel = tweetListViewModel
        self.userViewModel = userViewModel
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
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
    }

    private func configureAppearance() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.sectionHeaderHeight = 60
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: -55, left: 0, bottom: 0, right: 0)
        tableView.separatorInset = .zero
        tableView.separatorColor = #colorLiteral(red: 0.8765299916, green: 0.8867599964, blue: 0.8777099848, alpha: 1)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(WrapperTableViewCell.self, forCellReuseIdentifier: WrapperTableViewCell.reuseIdentifier)
    }
    
    private func addViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.edges(equal: view)
    }
    
    private func addReactiveBinding() {
        let refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.alpha = 0
        
        refreshControl
            .rx.controlEvent([.valueChanged])
            .subscribe(onNext: { [unowned self] in
                self.tweetListViewModel.resetLoadedContent()
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
}

extension RootViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweetListViewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = tweetListViewModel.tweetViewModel(atIndexPath: indexPath)
        let vc = TweetViewController(viewModel: vm)
        let cell = tableView.dequeueReusableCell(withIdentifier: WrapperTableViewCell.reuseIdentifier) as! WrapperTableViewCell
    
        self.addChild(vc)
        cell.configure(with: vc)
        vc.didMove(toParent: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: tableView.sectionHeaderHeight))
    }
}

extension RootViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isPullingUp = scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height
        tweetListViewModel.shouldLoadMore = isPullingUp || tweetListViewModel.shouldLoadMore
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let isAtBottom = scrollView.contentOffset.y + scrollView.frame.height == scrollView.contentSize.height
        if isAtBottom && tweetListViewModel.didLoadMore() {
            tableView.reloadData()
            tweetListViewModel.shouldLoadMore.toggle()
        }
    }
}
