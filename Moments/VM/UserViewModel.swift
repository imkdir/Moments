//
//  UserViewModel.swift
//  Moments
//
//  Created by Tung CHENG on 11/15/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import UIKit
import RxSwift
import MomentModel

final class UserViewModel: NSObject {
    fileprivate var model: User
    fileprivate var imageProvider: ImageProvider

    var nickname: String {
        model.nick
    }

    init(model: User, imageProvider: ImageProvider) {
        self.model = model
        self.imageProvider = imageProvider
    }
}

extension Reactive where Base == UserViewModel {
    var avatarImage: Observable<UIImage?> {
        base.imageProvider.rx.image(path: base.model.avatar)
    }
    
    var profileImage: Observable<UIImage?> {
        base.imageProvider.rx.image(path: base.model.profileImage)
    }
}
