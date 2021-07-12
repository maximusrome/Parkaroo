//
//  FBError.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import Foundation

enum EmailAuthError: Error {
    case invalidEmail
    case incorrectPassword
    case accoundDoesNotExist
    case unknownError
    case couldNotCreate
    case extraDataNotCreated
}
extension EmailAuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return NSLocalizedString("Please enter a valid email.", comment: "")
        case .incorrectPassword:
            return NSLocalizedString("Incorrect password for this account.", comment: "")
        case .accoundDoesNotExist:
            return NSLocalizedString("Please enter a valid email. This account does not exist.", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown error. Cannot log in.", comment: "")
        case .couldNotCreate:
            return NSLocalizedString("Could not create user at this time.", comment: "")
        case .extraDataNotCreated:
            return NSLocalizedString("Could not save user's full name.", comment: "")
        }
    }
}
