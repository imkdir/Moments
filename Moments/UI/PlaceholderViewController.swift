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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headerView)
        
        view.backgroundColor = .white
        headerView.backgroundColor = UIColor(named: "tableview.background")
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: -35).isActive = true
        headerView.widthAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 1).isActive = true
    }
}
