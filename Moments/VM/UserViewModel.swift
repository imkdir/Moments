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

    let avatarSize: CGFloat = 70

    var nickname: String {
        return model.nick
    }

    init(model: User, imageProvider: ImageProvider) {
        self.model = model
        self.imageProvider = imageProvider
    }
}

extension Reactive where Base == UserViewModel {
    var avatarImage: Observable<UIImage> {
        return base.imageProvider.rx.image(path: base.model.avatar).map({ $0 ?? UIImage() })
    }
    
    var profileImage: Observable<UIImage> {
        return base.imageProvider.rx.image(path: base.model.profileImage).map({ $0 ?? UIImage() })
    }
}
