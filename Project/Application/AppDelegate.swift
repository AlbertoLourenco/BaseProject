//
//  AppDelegate.swift
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()
    var orientationLock: UIInterfaceOrientationMask = [.portrait]
    
    //-----------------------------------------------------------------------
    //  MARK: - App Delegate -
    //-----------------------------------------------------------------------
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        notificationCenter.delegate = self
        
        //-----------------------------------
        //  Loading Mocks
        //-----------------------------------
        
        Preferences.isRunningTests = true
        Preferences.isRunningTestsFail = false
        
        //-----------------------------------
        //  BaseRouter
        //-----------------------------------
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = Preferences.theme == .dark ? .dark : .light
        window?.rootViewController = BaseRouter().getRootView()
        window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Constants.Notification.BecomeActive, object: nil)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(name: Constants.Notification.EnterBackground, object: nil)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(name: Constants.Notification.EnterForeground, object: nil)
    }
    
    //-----------------------------------------------------------------------
    //  MARK: - UNUserNotificationCenter Delegate -
    //-----------------------------------------------------------------------
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}

