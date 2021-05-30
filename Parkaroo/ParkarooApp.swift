//
//  ParkarooApp.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI
import Firebase
import FirebaseMessaging
import StoreKit

@main
struct ParkarooApp: App {
 
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var iapManager = IAPManager()
    var locationTransfer = LocationTransfer()
    var gGRequestConfirm = GGRequestConfirm()
    var userInfo = UserInfo()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationTransfer)
                .environmentObject(gGRequestConfirm)
                .environmentObject(userInfo)
                .environmentObject(iapManager)
                .onAppear(perform: {
                    iapManager.getProducts(productIDs: productIDs)
                    SKPaymentQueue.default().add(iapManager)
                })
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        configuteNotifications()
        LocationService.shared.checkLocationAuthStatus()
//        NotificationsService.shared.configure()
        
        return true
    }
    
    func configuteNotifications() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        UIApplication.shared.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        LocationService.shared.checkLocationAuthStatus()
    }
    
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
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
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let tokenDict = ["token": fcmToken ?? ""]
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
