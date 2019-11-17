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
    fileprivate var imageProvider: ImageProviderProtocol

    var nickname: String { model.nick }

    init(model: User, imageProvider: ImageProviderProtocol) {
        self.model = model
        self.imageProvider = imageProvider
    }
}

extension Reactive where Base == UserViewModel {
    var avatarImage: Observable<UIImage?> {
        base.imageProvider.fetchImage(path: base.model.avatar)
    }
    
    var profileImage: Observable<UIImage?> {
        base.imageProvider.fetchImage(path: base.model.profileImage)
    }
}
