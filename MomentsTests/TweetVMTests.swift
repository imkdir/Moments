//
//  TweetVMTests.swift
//  MomentsTests
//
//  Created by Tung CHENG on 11/16/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import XCTest
import RxSwift
@testable import MomentModel
@testable import Moments

class TweetVMTests: XCTestCase {
    
    var model: Tweet!
    var spyImageCache: SpyImageCache!
    var spyImageProvider: SpyImageProvider!
    var viewModel: TweetViewModel!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        model = Tweet(
        content: "dummy",
        images: [Tweet.Image(url: ".jpg")],
        sender: Tweet.Sender(nick: "me", avatar: ".png"),
        comments: [Tweet.Comment(
            content: "dummy",
            sender: Tweet.Sender(nick: "she", avatar: ".png"))])
        
        spyImageCache = SpyImageCache()
        spyImageProvider = SpyImageProvider(cache: spyImageCache)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
        
        disposeBag = nil
        spyImageProvider = nil
        spyImageCache = nil
        model = nil
    }

    func test_tweet_allProps_shouldDisplayedCorrectly() {
        viewModel = TweetViewModel(model: model, imageProvider: DummyImageProvider())
        
        XCTAssertEqual(viewModel.content, "dummy")
        XCTAssertEqual(viewModel.nickname, "me")
        XCTAssertEqual(viewModel.comments.count, 1)
        XCTAssertFalse(viewModel.isContentLabelHidden)
        XCTAssertFalse(viewModel.isImageGridHidden)
        XCTAssertFalse(viewModel.isCommentListHidden)
    }
    
    func test_tweet_hasNoContent_shouldHideContentLabel() {
        model.content = nil
        viewModel = TweetViewModel(model: model, imageProvider: DummyImageProvider())
        XCTAssertTrue(viewModel.isContentLabelHidden)
    }

    func test_tweet_hasNoImage_shouldHideImageGrid() {
        model.images = nil
        viewModel = TweetViewModel(model: model, imageProvider: DummyImageProvider())
        XCTAssertTrue(viewModel.isImageGridHidden)
    }
    
    func test_tweet_hasNoComment_shouldHideCommentList() {
        model.comments = nil
        viewModel = TweetViewModel(model: model, imageProvider: DummyImageProvider())
        XCTAssertTrue(viewModel.isCommentListHidden)
    }
    
    func test_tweet_withImages_shouldReturnCorrectGridLayout() {
        func dummyImages(count: Int) -> [Tweet.Image] {
            return Array(repeating: Tweet.Image(url: "dummy"), count: count)
        }
        model.images = dummyImages(count: 1)
        viewModel = TweetViewModel(model: model, imageProvider: DummyImageProvider())
        XCTAssertEqual([[180]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 2)
        viewModel = TweetViewModel(model: model, imageProvider: DummyImageProvider())
        XCTAssertEqual([[80, 80]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 3)
        viewModel = TweetViewModel(model: model, imageProvider: DummyImageProvider())
        XCTAssertEqual([[80, 80, 80]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 4)
        viewModel = TweetViewModel(model: model, imageProvider: DummyImageProvider())
        XCTAssertEqual([[80, 80], [80, 80]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 5)
        viewModel = TweetViewModel(model: model, imageProvider: DummyImageProvider())
        XCTAssertEqual([[80, 80, 80], [80, 80]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 6)
        viewModel = TweetViewModel(model: model, imageProvider: DummyImageProvider())
        XCTAssertEqual([[80, 80, 80], [80, 80, 80]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 7)
        viewModel = TweetViewModel(model: model, imageProvider: DummyImageProvider())
        XCTAssertEqual([[80, 80, 80], [80, 80, 80], [80]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 8)
        viewModel = TweetViewModel(model: model, imageProvider: DummyImageProvider())
        XCTAssertEqual([[80, 80, 80], [80, 80, 80], [80, 80]], viewModel.gridLayout)
        
        model.images = dummyImages(count: 9)
        viewModel = TweetViewModel(model: model, imageProvider: DummyImageProvider())
        XCTAssertEqual([[80, 80, 80], [80, 80, 80], [80, 80, 80]], viewModel.gridLayout)
    }
    
    func test_tweet_avatar_shouldDownloadWhenNoCache() {
        viewModel = TweetViewModel(model: model, imageProvider: spyImageProvider)
        XCTAssertNotNil(URL(string: model.sender!.avatar))
        
        let expectation = self.expectation(description: "fetch tweet sender avatar")
        viewModel
            .rx.avatarImage
            .subscribe(onNext: { [unowned self] _ in
                XCTAssertEqual(self.spyImageProvider.downloadRecords.count, 1)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 0.01)
    }
    
    func test_tweet_avatar_shouldSaveToCacheAfterDownload() {
        viewModel = TweetViewModel(model: model, imageProvider: spyImageProvider)
        
        let expectation = self.expectation(description: "fetch tweet sender avatar")
        
        viewModel
            .rx.avatarImage
            .subscribe(onNext: { [unowned self] _ in
                XCTAssertEqual(self.spyImageCache.cacheWriteRecords.count, 1)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 0.01)
    }
    
    func test_tweet_avatar_shouldNotDownloadWhenThereIsCache() {
        viewModel = TweetViewModel(model: model, imageProvider: spyImageProvider)
        spyImageCache["avatarImage.png"] = UIImage()
        
        let expectation = self.expectation(description: "fetch tweet sender avatar")
        viewModel
            .rx.avatarImage
            .subscribe(onNext: { [unowned self] _ in
                XCTAssertEqual(self.spyImageProvider.downloadRecords.count, 0)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 0.01)
    }
    
    func test_tweet_photo_shouldDownloadWhenNoCache() {
        viewModel = TweetViewModel(model: model, imageProvider: spyImageProvider)
        XCTAssertNotNil(URL(string: model.images!.first!.url))
        
        let expectation = self.expectation(description: "fetch tweet photo")
        viewModel
            .rx.indexedImage
            .subscribe(onNext: { [unowned self] _ in
                XCTAssertEqual(self.spyImageProvider.downloadRecords.count, 1)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 0.01)
    }
    
    func test_tweet_photo_shouldSaveToCacheAfterDownload() {
        viewModel = TweetViewModel(model: model, imageProvider: spyImageProvider)
        
        let expectation = self.expectation(description: "fetch tweet photo")
        
        viewModel
            .rx.indexedImage
            .subscribe(onNext: { [unowned self] _ in
                XCTAssertEqual(self.spyImageCache.cacheWriteRecords.count, 1)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 0.01)
    }
    
    func test_tweet_photo_shouldNotDownloadWhenThereIsCache() {
        viewModel = TweetViewModel(model: model, imageProvider: spyImageProvider)
        spyImageCache["indexedImage.jpg"] = UIImage()
        
        let expectation = self.expectation(description: "fetch tweet photo")
        viewModel
            .rx.indexedImage
            .subscribe(onNext: { [unowned self] _ in
                XCTAssertEqual(self.spyImageProvider.downloadRecords.count, 0)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 0.01)
    }
}
