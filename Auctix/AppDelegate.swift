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

    let notificationCenter = UNUserNotificationCenter.current()
    
    let notificationIdentifier = ["notification"]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let currentDate = Date()
        notificationCenter.requestAuthorization(options: [.alert,.sound]) { granted, error in
            guard granted else { return }
            self.notificationCenter.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else { return }
            }
        }
       // sendNotification()
        if UserDefaults.standard.bool(forKey: "lastDate") {
            let lastDate = UserDefaults.standard.object(forKey: "lastDate") as! Date
            if currentDate.compareCloseTo(lastDate, precision: 5.days.timeInterval) {
              removeNotifications(withIdentifiers: notificationIdentifier)
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let dateOfTermination = Date()
        UserDefaults.standard.set(dateOfTermination, forKey: "lastDate")
        sendNotification(inDays: 5)
    }

    func sendNotification(inDays days: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "AUCTIX"
        content.body = "You haven't made a bet for a long time!\nLet's make it!"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: days * 24 * 60 * 60, repeats: false)
        let request = UNNotificationRequest(identifier: notificationIdentifier[0], content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            print(error?.localizedDescription)
        }
    }
    
    func removeNotifications(withIdentifiers identifiers: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}

