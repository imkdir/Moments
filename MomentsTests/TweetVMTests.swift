//
//  TweetVMTests.swift
//  MomentsTests
//
//  Created by Tung CHENG on 11/16/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import XCTest
@testable import MomentModel
@testable import Moments

class TweetVMTests: XCTestCase {
    
    var model: Tweet!
    var imageProvider: ImageProvider!
    var viewModel: TweetViewModel!
    
    override func setUp() {
        let url = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let imageCache = ImageCache(url: url)
        imageProvider = ImageProvider(cache: imageCache)
        
        model = Tweet(
            content: "dummy",
            images: [Tweet.Image(url: "dummy")],
            sender: Tweet.Sender(nick: "me", avatar: "avatar.png"),
            comments: [Tweet.Comment(
                content: "dummy",
                sender: Tweet.Sender(nick: "she", avatar: "avatar.png"))])
    }

    override func tearDown() {
        viewModel = nil
        imageProvider = nil
        model = nil
    }

    func test_tweet_allProps_shouldDisplayedCorrectly() {
        viewModel = TweetViewModel(model: model, imageProvider: imageProvider)
        
        XCTAssertEqual(viewModel.content, "dummy")
        XCTAssertEqual(viewModel.nickname, "me")
        XCTAssertEqual(viewModel.comments.count, 1)
        XCTAssertFalse(viewModel.isContentLabelHidden)
        XCTAssertFalse(viewModel.isImageGridHidden)
        XCTAssertFalse(viewModel.isCommentListHidden)
    }
    
    func test_tweet_hasNoContent_shouldHideContentLabel() {
        model.content = nil
        viewModel = TweetViewModel(model: model, imageProvider: imageProvider)
        XCTAssertTrue(viewModel.isContentLabelHidden)
    }

    func test_tweet_hasNoImage_shouldHideImageGrid() {
        model.images = nil
        viewModel = TweetViewModel(model: model, imageProvider: imageProvider)
        XCTAssertTrue(viewModel.isImageGridHidden)
    }
    
    func test_tweet_hasNoComment_shouldHideCommentList() {
        model.comments = nil
        viewModel = TweetViewModel(model: model, imageProvider: imageProvider)
        XCTAssertTrue(viewModel.isCommentListHidden)
    }
    
    func test_tweet_withImages_shouldReturnCorrectGridLayout() {
        func dummyImages(count: Int) -> [Tweet.Image] {
            return Array(repeating: Tweet.Image(url: "dummy"), count: count)
        }
        model.images = dummyImages(count: 1)
        viewModel = TweetViewModel(model: model, imageProvider: imageProvider)
        XCTAssertEqual([[180]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 2)
        viewModel = TweetViewModel(model: model, imageProvider: imageProvider)
        XCTAssertEqual([[80, 80]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 3)
        viewModel = TweetViewModel(model: model, imageProvider: imageProvider)
        XCTAssertEqual([[80, 80, 80]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 4)
        viewModel = TweetViewModel(model: model, imageProvider: imageProvider)
        XCTAssertEqual([[80, 80], [80, 80]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 5)
        viewModel = TweetViewModel(model: model, imageProvider: imageProvider)
        XCTAssertEqual([[80, 80, 80], [80, 80]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 6)
        viewModel = TweetViewModel(model: model, imageProvider: imageProvider)
        XCTAssertEqual([[80, 80, 80], [80, 80, 80]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 7)
        viewModel = TweetViewModel(model: model, imageProvider: imageProvider)
        XCTAssertEqual([[80, 80, 80], [80, 80, 80], [80]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 8)
        viewModel = TweetViewModel(model: model, imageProvider: imageProvider)
        XCTAssertEqual([[80, 80, 80], [80, 80, 80], [80, 80]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 9)
        viewModel = TweetViewModel(model: model, imageProvider: imageProvider)
        XCTAssertEqual([[80, 80, 80], [80, 80, 80], [80, 80, 80]], viewModel.gridLayout)
    }
}
