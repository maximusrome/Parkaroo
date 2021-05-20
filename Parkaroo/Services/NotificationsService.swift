//
//  NotificationsService.swift
//  Parkaroo
//
//  Created by Bernie Cartin on 5/19/21.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
import FirebaseFunctions

class NotificationsService: NSObject, MessagingDelegate, UIApplicationDelegate {
    
    private override init() {}
    static let shared = NotificationsService()
    let unCenter = UNUserNotificationCenter.current()
    var window: UIWindow?
    
    lazy var functions = Functions.functions()
    
    func authorize() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard granted else {return}
            DispatchQueue.main.async {
                self.configure()
            }
        }
    }
    
   // fGWJVRzQgkJQlfotYxR0gU:APA91bG7IXr0k_refZTmjDKDoz3K0LpMOm4Z9rHD9irNSLH0zWcXzUZjfc_Ud1YPlwrH5HUGFrEpsKZSH43wo5kJkdr0ixf-qwp6VSULon1x0KnfiBdZMGlPSxNLDVRbtyUDFdpcw3t-
    
    
    func unauthorize() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    func configure() {
        unCenter.delegate = self
        Messaging.messaging().delegate = self
        
        let application = UIApplication.shared
        application.registerForRemoteNotifications()
    }
    
    func notificationsAuthStatus(completion: @escaping(_ status: Bool) -> Void) {
        unCenter.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    completion(true)
                }
                else {
                    completion(false)
                }
            }
        }
    }
    
    func saveToken() {
        if let uid = Auth.auth().currentUser?.uid {
            Messaging.messaging().token { token, error in
                if let err = error {
                    print("Error Retrieving Token: ", err.localizedDescription)
                    return
                }
                if let token = token {
                    FBFirestore.mergeFBUser([C_TOKEN:token], uid: uid) { result in
                        switch result {
                        
                        case .success(_):
                            print("Token Saved 1")
                        case .failure(_):
                            print("Token Failed")
                        }
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Setting apns", deviceToken)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        subscribeToNotifications(topic: C_EVERYONE)
        if let uid = Auth.auth().currentUser?.uid {
            FBFirestore.mergeFBUser([C_TOKEN:fcmToken], uid: uid) { result in
                switch result {
                
                case .success(_):
                    print("Token Saved 2")
                case .failure(_):
                    print("Token Failed")
                }
            }
        }
    }
    
    func subscribeToNotifications(topic: String) {
        Messaging.messaging().subscribe(toTopic: topic)
    }
    
    func unsubscribeFromNotifications(topic: String) {
        Messaging.messaging().unsubscribe(fromTopic: topic)
    }
    
    
    
}

extension NotificationsService: UNUserNotificationCenterDelegate {
  
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

          Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler([.banner, .sound, .badge])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
          completionHandler(.noData)
    }
    
    func sendSpotReservedNotification(uid: String) {
        self.functions.httpsCallable("spotReserved").call(["user":uid], completion: { (result, error) in
            if let error = error as NSError? {
              if error.domain == FunctionsErrorDomain {
                let message = error.localizedDescription
                print(message)
              }
            }
            else {
                print("Notification Sent")
            }
        })
    }
    
}

