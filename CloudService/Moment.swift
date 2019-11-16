//
//  Moment.swift
//  CloudService
//
//  Created by Tung CHENG on 11/15/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import Foundation
import Moya
import Result
import MomentModel

enum Moment {
    case userProfile(id: String)
    case tweets(userId: String)
}

extension Moment: TargetType {
    
    var baseURL: URL { CloudService.baseURL }
    
    var path: String {
        switch self {
        case .userProfile(let id):
            return "/user/\(id)"
        case .tweets(let userId):
            return "/user/\(userId)/tweets"
        }
    }
    
    var method: Moya.Method { .get }
    
    var task: Task { .requestPlain }
    
    var sampleData: Data {
        switch self {
        case .userProfile:
            return """
                { "profile-image": "profile-image.jpg", "avatar": "avatar.png", "nick": "Tung CHENG", }
                """.data(using: .utf8)!
        case .tweets:
            return """
                [ { "content": "Hello World!", "images": [ { "url": "t001.jpeg" }, { "url": "t002.jpeg" }, { "url": "t003.jpeg" } ], "sender": { "nick": "Cheng Yao", "avatar": "u001.jpeg" }, "comments": [ { "content": "Good.", "sender": { "nick": "Lei Huang", "avatar": "u002.jpeg" }, }, { "content": "Like it too", "sender": { "nick": "WeiDong Gu", "avatar": "u003.jpeg" } } ] } ]
                """.data(using: .utf8)!
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
