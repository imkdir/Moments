//
//  Tweet.swift
//  Moments
//
//  Created by Tung CHENG on 11/15/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import Foundation

public struct Tweet: Codable {

    public let content: String
    public let images: [Image]
    public let sender: Sender
    public let comments: [Comment]
    
    public struct Image: Codable {
        public let url: String
    }

    public struct Sender: Codable {
        public let nick: String
        public let avatar: String
    }

    public struct Comment: Codable {
        public let content: String
        public let sender: Sender
    }
}
