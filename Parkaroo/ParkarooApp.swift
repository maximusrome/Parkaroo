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
        NotificationsService.shared.configure()
        
        return true
    }
    
}



