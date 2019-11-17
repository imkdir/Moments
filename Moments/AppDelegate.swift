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
import UIWindowTransitions

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = PlaceholderViewController()
        compositionRoot(window: window)
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    private func compositionRoot(window: UIWindow, timeout: Double = 2) {
        
        let service = CloudService(baseURL: URL(string: "https://thoughtworks-mobile-2018.herokuapp.com"))
        
        fetchData(service: service, userId: "jsmith")
            .timeout(timeout, scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] user, tweets in
                self.showRootViewController(window: window, user: user, tweets: tweets)
            }, onError: { [unowned self] error in
                var message = error.localizedDescription
                if case RxError.timeout = error {
                    message = "The Internet connection appears to be slow."
                }
                self.showLoadFailedAlert(window: window, message: message, timeout: timeout + 1)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchData<T:MomentRepository>(service: T, userId: String) -> Observable<(User, [Tweet])> {
        Observable.combineLatest(service.getUser(byId: userId), service.getTweets(byUserId: userId))
    }
    
    private func showRootViewController(window: UIWindow, user: User, tweets: [Tweet]) {
        let imageProvider = ImageProvider(cache: ImageCache.default)
        let tweetListVM = TweetListViewModel(model: tweets, imageProvider: imageProvider)
        let userVM = UserViewModel(model: user, imageProvider: imageProvider)
        let rootVC = RootViewController(tweetListViewModel: tweetListVM, userViewModel: userVM)
        let options = UIWindow.TransitionOptions(direction: .fade, style: .easeIn)
        window.setRootViewController(rootVC, options: options)
    }
    
    private func showLoadFailedAlert(window: UIWindow, message: String, timeout: Double) {
        let alert = UIAlertController(title: "Network Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Try Again", style: .default, handler: {_ in
            self.compositionRoot(window: window, timeout: timeout)
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel))
        window.rootViewController?.present(alert, animated: true)
    }
}
