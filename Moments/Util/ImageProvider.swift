//
//  ImageProvider.swift
//  Moments
//
//  Created by Tung CHENG on 11/15/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CloudService

protocol ImageProviderProtocol {
    var cache: ImageCacheProtocol { get }
    init(cache: ImageCacheProtocol)
    func downloadImage(url: URL) -> Observable<UIImage?>
}

extension ImageProviderProtocol {
    func rx_image(path: String, cacheGroupId: String = #function) -> Observable<UIImage?> {
        guard let url = URL(string: path) else {
            return .just(nil)
        }
        let cacheKey = cacheGroupId + url.lastPathComponent
        if let cachedResult = cache[cacheKey] {
            return .just(cachedResult)
        }
        return downloadImage(url: url)
            .do(onNext: { [cache] in
                cache[cacheKey] = $0
            })
    }
}

struct ImageProvider: ImageProviderProtocol {
    fileprivate(set) var cache: ImageCacheProtocol
    
    init(cache: ImageCacheProtocol) {
        self.cache = cache
    }
    
    func downloadImage(url: URL) -> Observable<UIImage?> {
        let session = URLSession(configuration: .default)
        return session.rx
            .data(request: URLRequest(url: url))
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .utility))
            .map(UIImage.init(data:))
    }
}
