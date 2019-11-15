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
    
    var gridLayout: [[CGFloat]] {
        guard let images = model.images else { return [] }
        return calculateGridLayout(imageCount: images.count)
    }
    
    private func calculateGridLayout(imageCount: Int) -> [[CGFloat]] {
        switch imageCount {
        case 0: return []
        case 1: return [[180]]
        case 2, 4:
            return Array(repeating: CGFloat(80), count: imageCount).subgroup(bound: 2)
        default:
            return Array(repeating: CGFloat(80), count: imageCount).subgroup(bound: 3)
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
    
    var imageGrid: Observable<[UIImage]> {
        let transform: (Tweet.Image) -> Observable<UIImage?> = { [base] in
            base.imageProvider.rx.image(path: $0.url)
        }
        guard let images = base.model.images else {
            return .just([])
        }
        return Observable
            .zip(images.map(transform))
            .map({ $0.compactMap({ $0 }) })
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
