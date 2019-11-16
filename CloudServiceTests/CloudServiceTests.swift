//
//  CloudServiceTests.swift
//  CloudServiceTests
//
//  Created by Tung CHENG on 11/15/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import XCTest
import Moya
import RxSwift
@testable import CloudService

class CloudServiceTests: XCTestCase {
    var service: CloudService!
    var disposeBag: DisposeBag!

    override func setUp() {
        service = CloudService(baseURL: URL(string: "http://example.com")!)
        service.provider = MoyaProvider<Moment>.init(stubClosure: MoyaProvider.immediatelyStub)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        service = nil
        disposeBag = nil
    }

    func test_getUser_shouldReturnAUserProfile() {
        
        let expectation = self.expectation(description: "request user profile")
        service.getUser(byId: "dummy")
            .subscribe(onNext: { user in
                XCTAssertEqual(user.nick, "Tung CHENG")
                XCTAssertEqual(user.avatar, "avatar.png")
                XCTAssertEqual(user.profileImage, "profile-image.jpg")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 0.01)
    }

    func test_getTweets_shouldReturnAListOfTweets() {
        let expectation = self.expectation(description: "request tweets")
        service.getTweets(byUserId: "dummy")
            .subscribe(onNext: { tweets in
                XCTAssertEqual(tweets.count, 1)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 0.01)
    }

}
