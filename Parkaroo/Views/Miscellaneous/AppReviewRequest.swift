//
//  AppReviewRequest.swift
//  Parkaroo
//
//  Created by max rome on 5/16/21.
//
import SwiftUI
import StoreKit

enum AppReviewRequest {
    static var theshold = 3
    @AppStorage("runsSinceLastRequest") static var runsSinceLastRequest = 0
    @AppStorage("version") static var version = ""
    static func requestreviewIfNeeded() {
        runsSinceLastRequest += 1
        let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let thisVersion = "\(appVersion) build: \(appBuild)"
        print("Run Count: \(runsSinceLastRequest)")
        print("Verson: \(thisVersion)")
        if thisVersion != version {
            if runsSinceLastRequest >= theshold {
                if let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive}) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                    version = thisVersion
                    runsSinceLastRequest = 0
                }
            }
        } else {
            runsSinceLastRequest = 0
        }
    }
}
