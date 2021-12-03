//
//  FBUser.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import Foundation

struct FBUser: Equatable {
    // MARK: Public Properties
    let uid: String
    var vehicle: String
    let email: String
    var rating: Float = 0
    var numberOfRatings: Int = 0
    var credits: Int = 2
    var badgeCount: Int = 0
    var basicNotifications = true
    var saveLongitude: Float = 0
    var saveLatitude: Float = 0
    // Lifecycle
    init(uid: String, vehicle: String, email: String, rating: Float, numberOfRatings: Int, credits: Int, badgeCount: Int, basicNotifications: Bool, saveLongitude: Float, saveLatitude: Float) {
        self.uid = uid
        self.vehicle = vehicle
        self.email = email
        self.rating = rating
        self.numberOfRatings = numberOfRatings
        self.credits = credits
        self.badgeCount = badgeCount
        self.basicNotifications = basicNotifications
        self.saveLongitude = saveLongitude
        self.saveLatitude = saveLatitude
    }
}
// MARK: - Convenience functions
extension FBUser {
    init?(documentData: [String : Any]) {
        let uid = documentData[FBKeys.User.uid] as? String ?? ""
        let vehicle = documentData[FBKeys.User.vehicle] as? String ?? ""
        let email = documentData[FBKeys.User.email] as? String ?? ""
        let rating = documentData[C_RATING] as? Float ?? 0
        let numberOfRatings = documentData[C_NUMBEROFRATINGS] as? Int ?? 0
        let credits = documentData[C_CREDITS] as? Int ?? 2
        let badgeCount = documentData[C_BADGECOUNT] as? Int ?? 0
        let basicNotifications = documentData[C_BASICNOTIFICATIONS] as? Bool ?? true
        let saveLongitude = documentData[C_SAVELONGITUDE] as? Float ?? 0
        let saveLatitude = documentData[C_SAVELATITUDE] as? Float ?? 0
        self.init(uid: uid,
                  vehicle: vehicle,
                  email: email,
                  rating: rating,
                  numberOfRatings: numberOfRatings,
                  credits: credits,
                  badgeCount: badgeCount,
                  basicNotifications: basicNotifications,
                  saveLongitude: saveLongitude,
                  saveLatitude: saveLatitude
        )
    }
    static func dataDict(uid: String, vehicle: String, email: String) -> [String: Any] {
        var data: [String: Any] = [
            FBKeys.User.uid: uid,
            FBKeys.User.email: email
        ]
        if !vehicle.isEmpty {
            data[FBKeys.User.vehicle] = vehicle
        }
        return data
    }
}
