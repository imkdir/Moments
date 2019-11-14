//
//  UserViewModel.swift
//  Moments
//
//  Created by Tung CHENG on 11/15/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import UIKit
import MomentModel

struct UserViewModel {
    private var model: User

    let avatarSize: CGFloat = 70

    var profileImage: UIImage {
        return UIImage()
    }

    var avatarImage: UIImage {
        return UIImage()
    }

    var nickname: String {
        return model.nick
    }

    init(model: User) {
        self.model = model
    }
}
