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
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.banner)
    }
    
    private func configureUserNotifications() {
      UNUserNotificationCenter.current().delegate = self
    }
}
