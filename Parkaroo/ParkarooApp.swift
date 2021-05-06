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
    }
    var locationTransfer = LocationTransfer()
    var gGRequestConfirm = GGRequestConfirm()
    var userInfo = UserInfo()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationTransfer)
                .environmentObject(gGRequestConfirm)
                .environmentObject(userInfo)
        }
    }
}
