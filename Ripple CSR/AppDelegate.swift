//
//  AppDelegate.swift
//  Ripple CSR
//
//  Created by aayush shukla on 21/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
    var reachability: Reachability!
    static var ntwrk = 0
    static var titletext : String?
    static var controller : UINavigationController?
    static var navitem: UINavigationItem?
    static var setscanresult : Bool!
    static var sindex : IndexPath!
    static var origin : String!
    static var lotid : String!
    static var isorder : Bool!
    static var custid : String!
    static var loaderr : String!
    static var ordererr : String!
    static var isdelivered : Bool!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         print("--didFinishLaunchingWithOptions")
        
        IQKeyboardManager.shared.enable = true
        application.isIdleTimerDisabled = true
        do {
        try reachability = Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
        try reachability.startNotifier()
        } catch {
             print("This is not working.")
        }
        //MARK:- MS app center
    
      MSAppCenter.start("11b1430f-4ca8-4ad4-ac91-e570d21d8c44", withServices:[
          MSAnalytics.self,
          MSCrashes.self
        ])
        MSCrashes.setEnabled(true)
        MSCrashes.setUserConfirmationHandler({ (errorReports: [MSErrorReport]) in

          // Your code to present your UI to the user, e.g. an UIAlertController.
          MSCrashes.notify(with: .always)
          return true // Return true if the SDK should await user confirmation, otherwise return false.
        })
        return true
    }
    
    @objc func reachabilityChanged(_ note: NSNotification) {
    let reachability = note.object as! Reachability
        var image = UIImage(named: "")
    if reachability.connection != .unavailable {
    if reachability.connection == .wifi {
    print("Reachable via WiFi")
        AppDelegate.ntwrk = 1
        
    } else {
    print("Reachable via Cellular")
        AppDelegate.ntwrk = 1
        
    }
    } else {
    print("Not reachable")
        AppDelegate.ntwrk = 0
        
    }
        window = UIApplication.shared.windows[0]
//        if (window != nil) {
//        ((window!.rootViewController as? UINavigationController)?.topViewController as? BASEACTIVITY)?.setnav(title: "")
//        }
        let base = BASEACTIVITY()
        base.setnav(title: "")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("--applicationDidBecomeActive")
    }
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("--willFinishLaunchingWithOptions")
        return true
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("-applicationDidEnterBackground")
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("--applicationWillEnterForeground")
    }
    func applicationWillResignActive(_ application: UIApplication) {
         print("--applicationWillResignActive")
    }

    // MARK: UISceneSession Lifecycle
@available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
@available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

