//
//  TestHelper.swift
//  MomentsTests
//
//  Created by Tung CHENG on 11/17/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import UIKit
import RxSwift
@testable import Moments

struct DummyImageProvider: ImageProviderProtocol {
    var cache: ImageCacheProtocol

    func downloadImage(url: URL) -> Observable<UIImage?> {
        return .just(nil)
    }
}

extension DummyImageProvider {
    init() {
        self.cache = DummyImageCache()
    }
}

final class DummyImageCache: NSObject, ImageCacheProtocol {
    subscript(key: String) -> UIImage? {
        set {}
        get { return nil }
    }
}

class SpyImageProvider: ImageProviderProtocol {
    
    var cache: ImageCacheProtocol
    var downloadRecords: [URL] = []
    
    required init(cache: ImageCacheProtocol) {
        self.cache = cache
    }
    
    func downloadImage(url: URL) -> Observable<UIImage?> {
        downloadRecords.append(url)
        return .just(nil)
    }
}

final class SpyImageCache: NSObject, ImageCacheProtocol {
    var cacheWriteRecords: [String] = []
    var cacheReadRecords: [Bool] = []
    
    subscript(key: String) -> UIImage? {
        set {
            cacheWriteRecords.append(key)
        }
        get {
            let hit = cacheWriteRecords.contains(key)
            cacheReadRecords.append(hit)
            return hit ? UIImage() : nil
        }
    }
}
