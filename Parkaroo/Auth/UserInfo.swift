//
//  UserInfo.swift
//  Parkaroo
//
//  Created by max rome on 1/2/21.
//

import Foundation
import Firebase

class UserInfo: ObservableObject, Equatable {
    static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.user.uid == rhs.user.uid
    }
    enum FBAuthState {
        case undefined, signedOut, signedIn
    }
    @Published var isUserAuthenticated: FBAuthState = .undefined
    @Published var user: FBUser = .init(uid: "", vehicle: "", email: "", rating: 0, numberOfRatings: 0, credits: 2, badgeCount: 0, basicNotifications: true, saveLongitude: 0, saveLatitude: 0)
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    func configureFirebaseStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (_, user) in
            guard let _ = user else {
                self.isUserAuthenticated = .signedOut
                return
            }
            self.isUserAuthenticated = .signedIn
            self.loadUser()
        })
    }
    func loadUser() {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        FBFirestore.retrieveFBUser(uid: userID) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                self?.user = user
            }
        }
    }
    func addCredits(numberOfCredits: Int, completion: @escaping (Result<Bool, Error>) -> ()) {
        let credits = user.credits + numberOfCredits
        FBFirestore.mergeFBUser([C_CREDITS:credits], uid: user.uid) { result in
            switch result {
            case .success(_):
                self.user.credits = credits
            case .failure(_):
                print("Some Error")
            }
            completion(result)
        }
    }
    func AddOneCredit() {
        var credits = user.credits
        credits += 1
        FBFirestore.mergeFBUser([C_CREDITS:credits], uid: user.uid) { result in
            switch result {
            case .success(_):
                self.user.credits = credits
            case .failure(_):
                print("Error updating credits")
            }
        }
    }
    func RemoveOneCredit() {
        var credits = user.credits
        credits -= 1
        FBFirestore.mergeFBUser([C_CREDITS:credits], uid: user.uid) { result in
            switch result {
            case .success(_):
                self.user.credits = credits
            case .failure(_):
                print("Error updating credits")
            }
        }
    }
    func SaveLocation(SLongitude: Float, SLatitude: Float) {
        var saveLongitude = user.saveLongitude
        var saveLatitude = user.saveLatitude
        saveLongitude = SLongitude
        saveLatitude = SLatitude
        FBFirestore.mergeFBUser([C_SAVELONGITUDE:saveLongitude], uid: user.uid) { result in
            switch result {
            case .success(_):
                self.user.saveLongitude = saveLongitude
            case .failure(_):
                print("Error updating save longitude")
            }
        }
        FBFirestore.mergeFBUser([C_SAVELATITUDE:saveLatitude], uid: user.uid) { result in
            switch result {
            case .success(_):
                self.user.saveLongitude = saveLatitude
            case .failure(_):
                print("Error updating save latitude")
            }
        }
    }
}
