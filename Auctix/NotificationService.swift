//
//  NotificationService.swift
//  Auctix
//
//  Created by Евгений Башун on 23.11.2021.
//

import UserNotifications
import SwiftDate

final class NotificationService {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let notificationIdentifier = ["notification"]
    static let shared = NotificationService()
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
            guard granted else { return }
            self.fetchNotificationSettings()
        }
    }
    
    func fetchNotificationSettings() {
        self.notificationCenter.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
        }
    }
    
    func removeNotifications() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: notificationIdentifier)
    }
    
    func sendNotification(inDays days: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "AUCTIX"
        content.body = "You haven't made a bet for a long time!\nLet's make it!"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: days * 24 * 60 * 60 , repeats: false)
        let request = UNNotificationRequest(identifier: notificationIdentifier[0], content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            print(error?.localizedDescription)
        }
    }
}
