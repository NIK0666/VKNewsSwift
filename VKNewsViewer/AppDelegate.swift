//
//  AppDelegate.swift
//  VKNewsViewer
//
//  Copyright © 2018 NIKO. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //Setup initial window
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        var isAuthorized = false
        if let access_token = UserDefaults.standard.value(forKey: "ACCESS_TOKEN") as? String {
            if let expires_token = UserDefaults.standard.value(forKey: "EXPIRES_TOKEN") as? Date {
                if expires_token > Date() {
                    API.shared.token = access_token
                    isAuthorized = true
                }
            }
        }
        
        var rootViewController: UIViewController!
        if isAuthorized {
            rootViewController = FeedNewsViewController(collectionViewLayout: UICollectionViewFlowLayout())
        } else {
            rootViewController = AuthViewController()
        }
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        
        //appearance
        UINavigationBar.appearance().barTintColor = UIColor("326ab2")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor("fbfbfb")]
        
        //setup image cache
        URLCache.shared.memoryCapacity = 200 * 1024 * 1024
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

