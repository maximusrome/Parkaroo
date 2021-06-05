//
//  FBUser.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import Foundation

struct FBUser: Equatable {
    let uid: String
    let vehicle: String
    let email: String
    var rating: Float = 0
    var numberOfRatings: Int = 0
    var credits: Int = 0
    var badgeCount: Int = 0
    var basicNotifications = true
    var advancedNotifications = false
    init(uid: String, vehicle: String, email: String, rating: Float, numberOfRatings: Int, credits: Int, badgeCount: Int, basicNotifications: Bool, advancedNotifications: Bool) {
        self.uid = uid
        self.vehicle = vehicle
        self.email = email
        self.rating = rating
        self.numberOfRatings = numberOfRatings
        self.credits = credits
        self.badgeCount = badgeCount
        self.basicNotifications = basicNotifications
        self.advancedNotifications = advancedNotifications
    }
}
extension FBUser {
    init?(documentData: [String : Any]) {
        let uid = documentData[FBKeys.User.uid] as? String ?? ""
        let vehicle = documentData[FBKeys.User.vehicle] as? String ?? ""
        let email = documentData[FBKeys.User.email] as? String ?? ""
        let rating = documentData[C_RATING] as? Float ?? 0
        let numberOfRatings = documentData[C_NUMBEROFRATINGS] as? Int ?? 0
        let credits = documentData[C_CREDITS] as? Int ?? 0
        let badgeCount = documentData[C_BADGECOUNT] as? Int ?? 0
        let basicNotifications = documentData[C_BASICNOTIFICATIONS] as? Bool ?? true
        let advancedNotifications = documentData[C_ADVANCEDNOTIFICATIONS] as? Bool ?? false
        self.init(uid: uid,
                  vehicle: vehicle,
                  email: email,
                  rating: rating,
                  numberOfRatings: numberOfRatings,
                  credits: credits,
                  badgeCount: badgeCount,
                  basicNotifications: basicNotifications,
                  advancedNotifications: advancedNotifications
        )
    }
    static func dataDict(uid: String, vehicle: String, email: String) -> [String: Any] {
        var data: [String: Any]
        if vehicle != "" {
            data = [
                FBKeys.User.uid: uid,
                FBKeys.User.vehicle: vehicle,
                FBKeys.User.email: email
            ]
        } else {
            data = [
                FBKeys.User.uid: uid,
                FBKeys.User.email: email
            ]
        }
        return data
    }
}
