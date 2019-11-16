//
//  TweetListVMTests.swift
//  MomentsTests
//
//  Created by Tung CHENG on 11/14/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import XCTest
@testable import MomentModel
@testable import Moments

class TweetListVMTests: XCTestCase {
    var viewModel: TweetListViewModel!
    
    override func setUp() {
        let model: [Tweet] = (0 ... 15).map({ Tweet(content: "Dummy \($0)") })
        let url = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let imageCache = ImageCache(url: url)
        let imageProvider = ImageProvider(cache: imageCache)
        viewModel = TweetListViewModel(model: model, imageProvider: imageProvider)
    }

    override func tearDown() {
        viewModel = nil
    }

    func test_tweetListVM_setUpCorrectly() {
        XCTAssertFalse(viewModel.shouldLoadMore)
        XCTAssertEqual(viewModel.numberOfRows, 5)
    }

    func test_tweetListVM_shouldLoadMore() {
        viewModel.shouldLoadMore = true
        XCTAssertTrue(viewModel.didLoadMore())
        
        viewModel.shouldLoadMore.toggle()
        XCTAssertFalse(viewModel.didLoadMore())
    }
    
    func test_tweetListVM_resetLoadedContent() {
        viewModel.shouldLoadMore = true
        _ = viewModel.didLoadMore()
        XCTAssertEqual(viewModel.numberOfRows, 10)
        
        viewModel.resetLoadedContent()
        
        XCTAssertEqual(viewModel.numberOfRows, 5)
    }
}
