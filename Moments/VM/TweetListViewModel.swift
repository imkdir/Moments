//
// Created by Tung CHENG on 11/15/19.
// Copyright (c) 2019 Objective-CHENG. All rights reserved.
//

import Foundation
import MomentModel

struct TweetListViewModel {
    var model: [Tweet]

    func tweetViewModel(atIndexPath indexPath: IndexPath) -> TweetViewModel {
        return TweetViewModel(model: model[indexPath.row])
    }

    var numberOfRows: Int {
        return model.count
    }

    init(model: [Tweet]) {
        self.model = model
    }
}
