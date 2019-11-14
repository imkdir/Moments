//
//  MomentRepository.swift
//  Moments
//
//  Created by Tung CHENG on 11/15/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import Foundation

public protocol MomentRepository {
    func getUser(byId id: String) -> User
    func getTweets(byUser user: User) -> [Tweet]
}
