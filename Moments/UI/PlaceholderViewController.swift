//
//  PlaceholderViewController.swift
//  Moments
//
//  Created by Tung CHENG on 11/15/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import UIKit

final class PlaceholderViewController: UIViewController {
    private let headerView = UIView()
    private let avatarView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headerView)
        view.addSubview(avatarView)
        
        view.backgroundColor = .white
        headerView.backgroundColor = UIColor(named: "tableview.background")
        avatarView.backgroundColor = .white
        avatarView.layer.cornerRadius = 10
        avatarView.layer.masksToBounds = true
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.align(.leading, to: view).isActive = true
        headerView.align(.trailing, to: view).isActive = true
        headerView.align(.top, to: view, offset: -35).isActive = true
        headerView.aspect(ratio: 1).isActive = true
        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.align(.trailing, to: view, offset: -16).isActive = true
        avatarView.set(.width, to: 70).isActive = true
        avatarView.aspect(ratio: 1).isActive = true
        avatarView.align(.bottom, to: headerView, offset: 20).isActive = true
    }
}
