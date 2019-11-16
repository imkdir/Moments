//
//  CloudService.swift
//  CloudService
//
//  Created by Tung CHENG on 11/15/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import MomentModel

public enum CloudServiceError: Error {
    case unknown
}

public struct CloudService {
    internal static var baseURL: URL = URL(string: "https://thoughtworks-mobile-2018.herokuapp.com")!
    
    internal var provider = MoyaProvider<Moment>()
    
    public init(baseURL: URL) {
        CloudService.baseURL = baseURL
    }
    
    internal func request<T:Decodable>(_ token: Moment) -> Observable<T> {
        provider.rx
            .request(token)
            .map(unwrapResponse)
            .asObservable()
    }
    
    internal func unwrapResponse<T: Decodable>(response: Response) throws -> T {
        let decoder = JSONDecoder()
        guard response.statusCode == 200 else {
            throw CloudServiceError.unknown
        }
        return try decoder.decode(T.self, from: response.data)
    }
}

extension CloudService: MomentRepository {

    public func getUser(byId id: String) -> Observable<User> {
        request(.userProfile(id: id))
    }
    
    public func getTweets(byUserId userId: String) -> Observable<[Tweet]> {
        request(.tweets(userId: userId))
    }
}
