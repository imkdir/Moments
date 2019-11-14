//
//  RootViewController.swift
//  Moments
//
//  Created by Tung CHENG on 11/14/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    private let tableView = UITableView()
    private var profileHeaderViewController: ProfileViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewHierarchy()
        configureAppearance()
        addViewConstraints()
    }

    private func addViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func setupViewHierarchy() {
        view.addSubview(tableView)
        let headerFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 435)
        let headerView = UIView(frame: headerFrame)
        let vc = ProfileViewController()
        self.addChild(vc)
        headerView.addSubview(vc.view)
        headerView.backgroundColor = .white
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        vc.view.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -60).isActive = true
        vc.didMove(toParent: self)
        tableView.tableHeaderView = headerView
    }

    private func configureAppearance() {
        tableView.backgroundColor = UIColor(named: "tableview.background")
        tableView.estimatedRowHeight = 100
        tableView.contentInset = UIEdgeInsets(top: -55, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.separatorColor = UIColor(named: "tableview.separator")
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(WrapperTableViewCell.self, forCellReuseIdentifier: WrapperTableViewCell.reuseIdentifier)

        // TODO: extract out delegates
        tableView.dataSource = self
    }
}

extension RootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vc = TweetViewController()
        let cell = tableView.dequeueReusableCell(withIdentifier: WrapperTableViewCell.reuseIdentifier) as! WrapperTableViewCell
        cell.selectionStyle = .none
        self.addChild(vc)
        cell.configure(with: vc)
        vc.didMove(toParent: self)
        return cell
    }
}
