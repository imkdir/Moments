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

final class ImageProvider: NSObject {
    fileprivate var cache: ImageCache
    
    init(cache: ImageCache) {
        self.cache = cache
    }
}

extension Reactive where Base == ImageProvider {
    func image(path: String, cacheGroupId: String = #function) -> Observable<UIImage?> {
        guard let url = URL(string: path) else {
            return .just(nil)
        }
        let cacheKey = cacheGroupId + url.lastPathComponent
        if let cachedResult = base.cache[cacheKey] {
            return .just(cachedResult)
        }
        let session = URLSession(configuration: .default)
        return session.rx
            .data(request: URLRequest(url: url))
            .map(UIImage.init(data:))
            .do(onNext: { [base] in
                base.cache[cacheKey] = $0
            })
    }
}
