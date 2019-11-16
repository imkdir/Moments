//
// Created by Tung CHENG on 11/14/19.
// Copyright (c) 2019 Objective-CHENG. All rights reserved.
//

import UIKit

final class WrapperTableViewCell: UITableViewCell {
    var content: UIViewController!

    func configure(with content: UIViewController) {
        self.content = content
        selectionStyle = .none

        contentView.addSubview(content.view)
        content.view.translatesAutoresizingMaskIntoConstraints = false
        content.view.edges(equal: contentView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        guard let content = self.content else { return }
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }

    static var reuseIdentifier: String {
        NSStringFromClass(self)
    }
}
