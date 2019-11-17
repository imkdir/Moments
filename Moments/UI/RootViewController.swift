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
    }

    private func configureAppearance() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.sectionHeaderHeight = 60
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: -55, left: 0, bottom: 0, right: 0)
        tableView.separatorInset = .zero
        tableView.separatorColor = .tableViewSeparator
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
        
        rx.methodInvoked(#selector(viewWillTransition(to:with:)))
            .map({ _ in UIDevice.current.orientation })
            .filter(UIDeviceOrientation.elementsToFilter)
            .startWith(UIDevice.current.orientation)
            .map({ $0.isLandscape })
            .distinctUntilChanged()
            .map({ [bounds = UIScreen.main.bounds] isLandscape in
                isLandscape
                    ? CGSize(width: bounds.height, height: bounds.width * 0.5)
                    : CGSize(width: bounds.width, height: bounds.width)
            })
            .subscribe(onNext: { [unowned self] in
                self.prepareProfileViewControllerForReuse()
                let headerView = self.embedProfileViewControllerInView(size: $0)
                self.tableView.tableHeaderView = headerView
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func embedProfileViewControllerInView(size: CGSize) -> UIView {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let view = UIView(frame: frame)
        let vc = profileViewController
        self.addChild(vc)
        view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.edges(equal: view)
        vc.didMove(toParent: self)
        return view
    }
    
    private func prepareProfileViewControllerForReuse() {
        guard profileViewController.parent != nil else { return }
        
        profileViewController.willMove(toParent: nil)
        profileViewController.view.removeFromSuperview()
        profileViewController.removeFromParent()
    }
    
    private lazy var profileViewController = ProfileViewController(viewModel: userViewModel)
}

// MARK: - TableView DataSource & Delegate
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

// MARK: - Pull to Reload
extension RootViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tweetListViewModel.shouldLoadMore = scrollView.isPullingUp || tweetListViewModel.shouldLoadMore
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isNearBottom && tweetListViewModel.didLoadMore() {
            tableView.reloadData()
            tweetListViewModel.shouldLoadMore.toggle()
        }
    }
}

extension UIScrollView {
    fileprivate var isPullingUp: Bool {
        var safeAreaBottomInset: CGFloat = 0
        if #available(iOS 11.0, *) {
            safeAreaBottomInset = safeAreaInsets.bottom
        }
        return contentOffset.y + frame.height - safeAreaBottomInset > contentSize.height
    }
    
    fileprivate var isNearBottom: Bool {
        var safeAreaBottomInset: CGFloat = 0
        if #available(iOS 11.0, *) {
            safeAreaBottomInset = safeAreaInsets.bottom
        }
        return contentOffset.y + frame.height - safeAreaBottomInset - contentSize.height < 0.1
    }
}

extension UIDeviceOrientation: CustomDebugStringConvertible {
    /// only care about portrait or landscape
    public var debugDescription: String {
        switch self {
        case .portrait, .portraitUpsideDown: return "portrait"
        case .landscapeRight, .landscapeLeft: return "landscape"
        default: return "unknown"
        }
    }
    
    fileprivate static func elementsToFilter(_ el: UIDeviceOrientation) -> Bool {
        switch el {
        case .faceDown, .faceUp, .unknown:
            return false
        default:
            return true
        }
    }
}
