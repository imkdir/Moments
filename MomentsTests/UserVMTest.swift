//
//  UserVMTest.swift
//  MomentsTests
//
//  Created by Tung CHENG on 11/16/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import XCTest
import UIKit
import RxSwift
@testable import MomentModel
@testable import Moments

class UserVMTest: XCTestCase {
    var model: User!
    var spyImageCache: SpyImageCache!
    var spyImageProvider: SpyImageProvider!
    var viewModel: UserViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        model = User(profileImage: ".jpg", avatar: ".png", nick: "dummy")
        spyImageCache = SpyImageCache()
        spyImageProvider = SpyImageProvider(cache: spyImageCache)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
        
        disposeBag = nil
        model = nil
        spyImageCache = nil
        spyImageProvider = nil
    }

    func test_user_nickname_shouldDisplayedCorrectly() {
        viewModel = UserViewModel(model: model, imageProvider: DummyImageProvider())
        XCTAssertEqual(viewModel.nickname, "dummy")
    }
    
    func test_user_profileImage_shouldDownloadWhenNoCache() {
        viewModel = UserViewModel(model: model, imageProvider: spyImageProvider)
        XCTAssertNotNil(URL(string: model.profileImage))
        
        let expectation = self.expectation(description: "fetch user profile image")
        viewModel
            .rx.profileImage
            .subscribe(onNext: { [unowned self] _ in
                XCTAssertEqual(self.spyImageProvider.downloadRecords.count, 1)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 0.01)
    }
    
    func test_user_profileImage_shouldSaveToCacheAfterDownload() {
        viewModel = UserViewModel(model: model, imageProvider: spyImageProvider)
        
        let expectation = self.expectation(description: "fetch user profile image")
        
        viewModel
            .rx.profileImage
            .subscribe(onNext: { [unowned self] _ in
                XCTAssertEqual(self.spyImageCache.cacheWriteRecords.count, 1)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 0.01)
    }
    
    func test_user_profileImage_shouldNotDownloadWhenThereIsCache() {
        viewModel = UserViewModel(model: model, imageProvider: spyImageProvider)
        spyImageCache["profileImage.jpg"] = UIImage()
        
        let expectation = self.expectation(description: "fetch user profile image")
        viewModel
            .rx.profileImage
            .subscribe(onNext: { [unowned self] _ in
                XCTAssertEqual(self.spyImageProvider.downloadRecords.count, 0)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 0.01)
    }
    
    func test_user_avatar_shouldDownloadWhenNoCache() {
        viewModel = UserViewModel(model: model, imageProvider: spyImageProvider)
        XCTAssertNotNil(URL(string: model.avatar))
        
        let expectation = self.expectation(description: "fetch user avatar")
        viewModel
            .rx.avatarImage
            .subscribe(onNext: { [unowned self] _ in
                XCTAssertEqual(self.spyImageProvider.downloadRecords.count, 1)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 0.01)
    }
    
    func test_user_avatar_shouldSaveToCacheAfterDownload() {
        viewModel = UserViewModel(model: model, imageProvider: spyImageProvider)
        
        let expectation = self.expectation(description: "fetch user avatar")
        
        viewModel
            .rx.avatarImage
            .subscribe(onNext: { [unowned self] _ in
                XCTAssertEqual(self.spyImageCache.cacheWriteRecords.count, 1)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 0.01)
    }
    
    func test_user_avatar_shouldNotDownloadWhenThereIsCache() {
        viewModel = UserViewModel(model: model, imageProvider: spyImageProvider)
        spyImageCache["avatarImage.png"] = UIImage()
        
        let expectation = self.expectation(description: "fetch user avatar")
        viewModel
            .rx.avatarImage
            .subscribe(onNext: { [unowned self] _ in
                XCTAssertEqual(self.spyImageProvider.downloadRecords.count, 0)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 0.01)
    }
}
