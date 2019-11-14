//
//  TweetViewModel.swift
//  Moments
//
//  Created by Tung CHENG on 11/15/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import UIKit
import MomentModel

struct TweetViewModel {
    private var model: Tweet

    let stackViewSpacing: CGFloat = 10

    let avatarCornerRadius: CGFloat = 4

    var avatarImage: UIImage {
        return UIImage()
    }

    var nickname: String {
        return model.sender.nick
    }

    var content: String {
        return model.content
    }

    var imageGrid: (content: [[UIImage]], size: CGSize) {
        // TODO: convert tweet.images to array of UIImage to image grid
        return ([], .zero)
    }

    var comments: [(content: String, nickname: String)] {
        return model.comments.map({($0.content, $0.sender.nick)})
    }

    init(model: Tweet) {
        self.model = model
    }
}
