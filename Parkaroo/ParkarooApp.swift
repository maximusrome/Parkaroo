//
//  ParkarooApp.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI
import Firebase

@main
struct ParkarooApp: App {
    
    init() {
        FirebaseApp.configure()
        NotificationsService.shared.configure()
    }
    
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
        }
    }
}
