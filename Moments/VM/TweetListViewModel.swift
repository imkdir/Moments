//
// Created by Tung CHENG on 11/15/19.
// Copyright (c) 2019 Objective-CHENG. All rights reserved.
//

import UIKit
import MomentModel

struct TweetListViewModel {
    private var model: [Tweet]
    private var imageProvider: ImageProviderProtocol
    
    private var length: Int = 5
    
    var shouldLoadMore: Bool = false
    
    mutating func resetLoadedContent() {
        length = min(model.count, 5)
    }

    func tweetViewModel(atIndexPath indexPath: IndexPath) -> TweetViewModel {
        TweetViewModel(model: model[indexPath.row], imageProvider: imageProvider)
    }

    var numberOfRows: Int {
        min(model.count, length)
    }

    init(model: [Tweet], imageProvider: ImageProviderProtocol) {
        self.imageProvider = imageProvider
        self.model = model.filter({ $0.content != nil || $0.images != nil })
        resetLoadedContent()
    }

    mutating func didLoadMore() -> Bool {
        guard shouldLoadMore else {
            return false
        }
        let oldValue = length
        length = min(model.count, length + 5)
        return oldValue != length
    }
}
