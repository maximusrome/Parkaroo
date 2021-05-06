//
//  UserInfo.swift
//  Parkaroo
//
//  Created by max rome on 1/2/21.
//

import Foundation
import Firebase

class UserInfo: ObservableObject {
    enum FBAuthState {
        case undefined, signedOut, signedIn
    }
    @Published var isUserAuthenticated: FBAuthState = .undefined
    @Published var user: FBUser = .init(uid: "", vehicle: "", email: "")
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    func configureFirebaseStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (_, user) in
            guard let _ = user else {
                self.isUserAuthenticated = .signedOut
                return
            }
            self.isUserAuthenticated = .signedIn
        })
    }
}
