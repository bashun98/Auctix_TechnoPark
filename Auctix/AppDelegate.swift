//
//  AppDelegate.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 11.10.2021.
//

import UIKit
import Firebase
import UserNotifications
import SwiftDate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let currentDate = Date()

    var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        NotificationService.shared.requestAuthorization()
        
        if UserDefaults.standard.bool(forKey: "lastDate") {
            let lastDate = UserDefaults.standard.object(forKey: "lastDate") as! Date
            if currentDate.compareCloseTo(lastDate, precision: 5.days.timeInterval) {
                NotificationService.shared.removeNotifications()
            }
        }
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        let dateOfTermination = Date()
        UserDefaults.standard.set(dateOfTermination, forKey: "lastDate")
        NotificationService.shared.sendNotification(inDays: 5)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }

}

