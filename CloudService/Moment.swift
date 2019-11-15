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
        // TODO: load sample data from bundle
        return Data()
    }

    var headers: [String : String]? {
        return nil
    }
}
