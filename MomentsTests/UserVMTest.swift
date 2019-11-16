//
//  UserVMTest.swift
//  MomentsTests
//
//  Created by Tung CHENG on 11/16/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import XCTest
@testable import MomentModel
@testable import Moments

class UserVMTest: XCTestCase {
    var model: User!
    var imageProvider: ImageProvider!
    var viewModel: UserViewModel!

    override func setUp() {
        let url = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let imageCache = ImageCache(url: url)
        imageProvider = ImageProvider(cache: imageCache)
        
        model = User(profileImage: "profile-image.jpg", avatar: "avatar.png", nick: "Dummy")
    }

    override func tearDown() {
        viewModel = nil
        imageProvider = nil
        model = nil
    }

    func test_user_nickname_shouldDisplayedCorrectly() {
        viewModel = UserViewModel(model: model, imageProvider: imageProvider)
        XCTAssertEqual(viewModel.nickname, "Dummy")
    }
}
