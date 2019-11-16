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
        
        window.rootViewController = PlaceholderViewController()
        
        let service = CloudService(baseURL: URL(string: "https://thoughtworks-mobile-2018.herokuapp.com")!)
        
        fetchProfileAndTweets(service: service, userId: "jsmith")
            .retry(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { user, tweets in
                let imageProvider = ImageProvider(cache: ImageCache.default)
                let tweetListVM = TweetListViewModel(model: tweets, imageProvider: imageProvider)
                let userVM = UserViewModel(model: user, imageProvider: imageProvider)
                window.rootViewController = RootViewController(tweetListViewModel: tweetListVM, userViewModel: userVM)
            }, onError: { [unowned self] _ in
                self.showLoadFailedAlert()
            })
            .disposed(by: disposeBag)
        
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func fetchProfileAndTweets<T:MomentRepository>(service: T, userId: String) -> Observable<(User, [Tweet])> {
        return Observable.combineLatest(service.getUser(byId: userId), service.getTweets(byUserId: userId))
    }
    
    private func showLoadFailedAlert() {
        let alert = UIAlertController(title: "Network Error", message: "Please try again later.", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: {_ in
            UIApplication.shared.perform(Selector("suspend"))
            Thread.sleep(forTimeInterval: 2)
            exit(0)
        }))
        window?.rootViewController?.present(alert, animated: true)
    }
}
