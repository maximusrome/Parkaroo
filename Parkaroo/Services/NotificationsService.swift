//
//  NotificationsService.swift
//  Parkaroo
//
//  Created by max rome on 5/19/21.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
import FirebaseFunctions

class NotificationsService: NSObject, UIApplicationDelegate {
    private override init() {}
    static let shared = NotificationsService()
    let unCenter = UNUserNotificationCenter.current()
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    lazy var functions = Functions.functions()
    func configure() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        UIApplication.shared.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
}
extension NotificationsService: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let tokenDict = ["token": fcmToken ]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: tokenDict)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        FBFirestore.mergeFBUser(tokenDict, uid: uid) { result in
            switch result {
            case .success(_):
                print("Token Saved: ", fcmToken)
            case .failure(_):
                print("Error Saving Token")
            }
        }
    }
}
extension NotificationsService: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.banner, .sound]])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
//        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//            Messaging.messaging().appDidReceiveMessage(userInfo)
//
//            if let messageID = userInfo[gcmMessageIDKey] {
//                print("MessageID: \(messageID)")
//            }
//
//            completionHandler(.noData)
//        }
    func sendN(uid: String, message: String) {
        self.functions.httpsCallable("createNotification").call(["user":uid, "message":message], completion: { (result, error) in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let message = error.localizedDescription
                    print(message)
                }
            } else {
                print("Notification Sent")
            }
        })
    }
}
