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
    @Published var user: FBUser = .init(uid: "", vehicle: "", email: "", rating: 0, numberOfRatings: 0, credits: 0, serviceTokens: 0, badgeCount: 0, basicNotifications: true, advancedNotifications: false)
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
        let credits = self.user.credits + numberOfCredits
        FBFirestore.mergeFBUser([C_CREDITS:credits], uid: self.user.uid) { result in
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
        var credits = self.user.credits
        credits += 1
        FBFirestore.mergeFBUser([C_CREDITS:credits], uid: self.user.uid) { result in
            switch result {
            case .success(_):
                self.user.credits = credits
            case .failure(_):
                print("Error updating credits")
            }
        }
    }
    func RemoveOneCredit() {
        var credits = self.user.credits
        credits -= 1
        FBFirestore.mergeFBUser([C_CREDITS:credits], uid: self.user.uid) { result in
            switch result {
            case .success(_):
                self.user.credits = credits
            case .failure(_):
                print("Error updating credits")
            }
        }
    }
    func addServiceTokens(numberOfServiceTokens: Int, completion: @escaping (Result<Bool, Error>) -> ()) {
        let serviceTokens = self.user.serviceTokens + numberOfServiceTokens
        FBFirestore.mergeFBUser([C_SERVICETOKENS:serviceTokens], uid: self.user.uid) { result in
            switch result {
            case .success(_):
                self.user.serviceTokens = serviceTokens
            case .failure(_):
                print("Some Error")
            }
            completion(result)
        }
    }
    func AddOneServiceToken() {
        var serviceTokens = self.user.serviceTokens
        serviceTokens += 1
        FBFirestore.mergeFBUser([C_SERVICETOKENS:serviceTokens], uid: self.user.uid) { result in
            switch result {
            case .success(_):
                self.user.serviceTokens = serviceTokens
            case .failure(_):
                print("Error updating service tokens")
            }
        }
    }
    func RemoveOneServiceToken() {
        var serviceTokens = self.user.serviceTokens
        serviceTokens -= 1
        FBFirestore.mergeFBUser([C_SERVICETOKENS:serviceTokens], uid: self.user.uid) { result in
            switch result {
            case .success(_):
                self.user.serviceTokens = serviceTokens
            case .failure(_):
                print("Error updating tokens")
            }
        }
    }
}
