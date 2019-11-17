//
//  TweetViewModel.swift
//  Moments
//
//  Created by Tung CHENG on 11/15/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import UIKit
import RxSwift
import MomentModel

final class TweetViewModel: NSObject {
    fileprivate var model: Tweet
    fileprivate var imageProvider: ImageProviderProtocol
    
    init(model: Tweet, imageProvider: ImageProviderProtocol) {
        self.model = model
        self.imageProvider = imageProvider
    }

    var nickname: String? { model.sender?.nick }

    var content: String? { model.content }

    var comments: [(content: String, nickname: String)] {
        model.comments?.map({($0.content, $0.sender.nick)}) ?? []
    }
    
    var isContentLabelHidden: Bool {
        model.content?.isEmpty ?? true
    }

    var isImageGridHidden: Bool {
        model.images?.isEmpty ?? true
    }

    var isCommentListHidden: Bool {
        model.comments?.isEmpty ?? true
    }
    
    var gridLayout: [[CGFloat]] {
        guard let images = model.images else {
            return []
        }
        return calculateGridLayout(count: images.count)
    }
    
    /// default image ratio is 1 since we can't get the w/h ratio
    /// without an instance of UIImage or a ratio value from backend api.
    private func calculateGridLayout(count: Int) -> [[CGFloat]] {
        switch count {
        case 0: return []
        case 1: return [[singleImageSize]]
        default:
            let bound = (count == 2 || count == 4) ? 2 : 3
            return Array(repeating: CGFloat(80), count: count).subgroup(bound: bound)
        }
    }
    
    private let singleImageSize: CGFloat = 180
}

extension Reactive where Base == TweetViewModel {
    
    var avatarImage: Observable<UIImage?> {
        guard let path = base.model.sender?.avatar else {
            return .just(nil)
        }
        return base.imageProvider.fetchImage(path: path)
    }
    
    var indexedImage: Observable<(UIImage?, Int)> {
        let transform: (Int, Tweet.Image) -> Observable<(UIImage?, Int)> = { [base] index, image in
            base.imageProvider.fetchImage(path: image.url).map({ ($0, index) })
        }
        guard let images = base.model.images else {
            return .empty()
        }
        return Observable.merge(images.enumerated().map(transform))
    }
}

extension Sequence {
    func subgroup(bound: Int) -> [[Element]] {
        var i: Int = 0
        return reduce(into: [[Element]](), { accu, el in
            i = i % bound
            if i == 0 {
                accu.append([])
            }
            accu[accu.count-1] = accu.last! + [el]
            i += 1
        })
    }
}
