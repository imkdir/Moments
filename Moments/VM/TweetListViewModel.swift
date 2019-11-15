//
// Created by Tung CHENG on 11/15/19.
// Copyright (c) 2019 Objective-CHENG. All rights reserved.
//

import Foundation
import MomentModel

struct TweetListViewModel {
    private var model: [Tweet]
    private var imageProvider: ImageProvider

    func tweetViewModel(atIndexPath indexPath: IndexPath) -> TweetViewModel {
        return TweetViewModel(model: model[indexPath.row], imageProvider: imageProvider)
    }

    var numberOfRows: Int {
        return model.count
    }

    init(model: [Tweet], imageProvider: ImageProvider) {
        self.imageProvider = imageProvider
        self.model = model.filter({
            ($0.content != nil || $0.images != nil)
        })
    }
}
