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
    fileprivate var imageProvider: ImageProvider
    
    init(model: Tweet, imageProvider: ImageProvider) {
        self.model = model
        self.imageProvider = imageProvider
    }

    let stackViewSpacing: CGFloat = 10
    let avatarCornerRadius: CGFloat = 4

    var nickname: String? {
        return model.sender?.nick
    }

    var content: String? {
        return model.content
    }

    var comments: [(content: String, nickname: String)] {
        return model.comments?.map({($0.content, $0.sender.nick)}) ?? []
    }

    var isImageGridHidden: Bool {
        return model.images?.isEmpty ?? true
    }

    var isCommentListHidden: Bool {
        return model.comments?.isEmpty ?? true
    }
    
    func createImageGrid(images: [UIImage]) -> ([[UIImage]], CGSize) {
        guard !images.isEmpty else {
            return ([[]], .zero)
        }
        var size: CGSize
        if images.count == 1, let image = images.first {
            precondition(image.size.height > 0)
            let ratio = image.size.width / image.size.height
            if ratio > 1 {
                size = CGSize(width: 180, height: 180 / ratio)
            } else {
                size = CGSize(width: 180 * ratio, height: 180)
            }
            return ([[image]], size)
        }
        size = CGSize(width: 80, height: 80)
        if images.count == 2 || images.count == 4 {
            return (images.subgroup(bound: 2), size)
        } else {
            return (images.subgroup(bound: 3), size)
        }
    }
}

extension Reactive where Base == TweetViewModel {
    
    var avatarImage: Observable<UIImage> {
        guard let path = base.model.sender?.avatar else {
            return .just(UIImage())
        }
        return base.imageProvider
            .rx.image(path: path)
            .map({ $0 ?? UIImage() })
    }
    
    var imageGrid: Observable<([[UIImage]], CGSize)> {
        let transform: (Tweet.Image) -> Observable<UIImage?> = { [base] in
            base.imageProvider.rx.image(path: $0.url)
        }
        guard let images = base.model.images else {
            return .just(([], .zero))
        }
        return Observable
            .zip(images.map(transform))
            .map({ $0.compactMap({ $0 }) })
            .map({ [base] in base.createImageGrid(images: $0) })
    }
}

extension Sequence {
    func subgroup(bound: Int) -> [[Element]] {
        var i: Int = 0
        return self.reduce(into: [[Element]](), { accu, el in
            i = i % bound
            if i == 0 {
                accu.append([])
            }
            accu[accu.count-1] = accu.last! + [el]
            i += 1
        })
    }
}
