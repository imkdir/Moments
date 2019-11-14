//
//  AppDelegate.swift
//  Moments
//
//  Created by Tung CHENG on 11/14/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import UIKit
import MomentModel


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        compositionRoot()
        return true
    }

    private func compositionRoot() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let tweetListVM = TweetListViewModel(model: [])
        let userVM = UserViewModel(model: User(
            profileImage: "https://thoughtworks-mobile-2018.herokuapp.com/images/user/profile-image.jpg",
            avatar: "https://thoughtworks-mobile-2018.herokuapp.com/images/user/avatar.png",
            nick: "Huan Hua"))
        window.rootViewController = RootViewController(tweetListViewModel: tweetListVM, userViewModel: userVM)
        window.makeKeyAndVisible()
        self.window = window
    }
}
