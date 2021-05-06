//
//  FBUser.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import Foundation

struct FBUser {
    let uid: String
    let vehicle: String
    let email: String
    init(uid: String, vehicle: String, email: String) {
        self.uid = uid
        self.vehicle = vehicle
        self.email = email
    }
}
extension FBUser {
    init?(documentData: [String : Any]) {
        let uid = documentData[FBKeys.User.uid] as? String ?? ""
        let vehicle = documentData[FBKeys.User.vehicle] as? String ?? ""
        let email = documentData[FBKeys.User.email] as? String ?? ""
        self.init(uid: uid,
                  vehicle: vehicle,
                  email: email
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
