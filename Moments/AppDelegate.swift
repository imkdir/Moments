//
//  AppDelegate.swift
//  Moments
//
//  Created by Tung CHENG on 11/14/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import UIKit
import RxSwift
import MomentModel
import CloudService

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        compositionRoot()
        return true
    }

    private func compositionRoot() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        window.rootViewController = UIViewController()
        
        fetchProfileAndTweets(userId: "jsmith")
            .observeOn(MainScheduler.instance)
            .retry(1)
            .subscribe(onNext: { user, tweets in
                let imageProvider = ImageProvider(cache: ImageCache.instance)
                let tweetListVM = TweetListViewModel(model: tweets, imageProvider: imageProvider)
                let userVM = UserViewModel(model: user, imageProvider: imageProvider)
                window.rootViewController = RootViewController(tweetListViewModel: tweetListVM, userViewModel: userVM)
            }, onError: {
                print($0.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func fetchProfileAndTweets(userId: String) -> Observable<(User, [Tweet])> {
        let service = CloudService(baseURL: URL(string: "https://thoughtworks-mobile-2018.herokuapp.com")!)
        return Observable.combineLatest(service.getUser(byId: userId), service.getTweets(byUserId: userId))
    }
}
