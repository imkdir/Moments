//
// Created by Tung CHENG on 11/14/19.
// Copyright (c) 2019 Objective-CHENG. All rights reserved.
//

import UIKit

final class WrapperTableViewCell: UITableViewCell {
    var content: UIViewController!

    func configure(with content: UIViewController) {
        self.content = content

        contentView.addSubview(content.view)
        content.view.translatesAutoresizingMaskIntoConstraints = false
        content.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        content.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        content.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        content.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        if let content = self.content {
            content.willMove(toParent: nil)
            content.view.removeFromSuperview()
            content.removeFromParent()
        }
    }

    static var reuseIdentifier: String {
        NSStringFromClass(self)
    }
}
