//
//  Tweet.swift
//  Moments
//
//  Created by Tung CHENG on 11/15/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import Foundation

public struct Tweet: Decodable {

    public var content: String?
    public var images: [Image]?
    public var sender: Sender?
    public var comments: [Comment]?
    
    public struct Image: Decodable {
        public let url: String
    }

    public struct Sender: Decodable {
        public let nick: String
        public let avatar: String
    }

    public struct Comment: Decodable {
        public let content: String
        public let sender: Sender
    }
    
    private enum CodingKeys: String, CodingKey {
        case content
        case images
        case sender
        case comments
    }
}

extension Tweet {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.images = try container.decodeIfPresent([Image].self, forKey: .images)
        self.sender = try container.decodeIfPresent(Sender.self, forKey: .sender)
        self.comments = try container.decodeIfPresent([Comment].self, forKey: .comments)
    }
}
