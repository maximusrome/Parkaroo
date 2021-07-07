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
    let vehicle: String
    let email: String
    var rating: Float = 0
    var numberOfRatings: Int = 0
    var credits: Int = 0
    var badgeCount: Int = 0
    var basicNotifications = true
    
    // Lifecycle
    init(uid: String, vehicle: String, email: String, rating: Float, numberOfRatings: Int, credits: Int, badgeCount: Int, basicNotifications: Bool) {
        self.uid = uid
        self.vehicle = vehicle
        self.email = email
        self.rating = rating
        self.numberOfRatings = numberOfRatings
        self.credits = credits
        self.badgeCount = badgeCount
        self.basicNotifications = basicNotifications
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
        let credits = documentData[C_CREDITS] as? Int ?? 0
        let badgeCount = documentData[C_BADGECOUNT] as? Int ?? 0
        let basicNotifications = documentData[C_BASICNOTIFICATIONS] as? Bool ?? true
        self.init(uid: uid,
                  vehicle: vehicle,
                  email: email,
                  rating: rating,
                  numberOfRatings: numberOfRatings,
                  credits: credits,
                  badgeCount: badgeCount,
                  basicNotifications: basicNotifications
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
