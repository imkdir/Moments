//
//  User.swift
//  Moments
//
//  Created by Tung CHENG on 11/15/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import Foundation

public struct User: Codable {
    public let profileImage: String
    public let avatar: String
    public let nick: String
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile-image"
        case avatar
        case nick
    }
}
