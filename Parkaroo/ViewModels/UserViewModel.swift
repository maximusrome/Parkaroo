//
//  UserViewModel.swift
//  Parkaroo
//
//  Created by max rome on 1/1/21.
//

import Foundation

struct UserViewModel {
    var email = ""
    var password = ""
    var vehicle = ""
    
    func isVehicleValid() -> Bool {
        let vehicleTest = NSPredicate(format: "SELF MATCHES %@",
                                      "^([1-zA-Z0-1@.\\s]{7,30})$")
        return vehicleTest.evaluate(with: vehicle)
    }
    
    func isPasswordValid() -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*\\d)(?=.*[a-z]).{6,64}$")
        return passwordTest.evaluate(with: password)
    }
    
    func isEmailValid() -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])")
        return emailTest.evaluate(with: email)
    }
    
    var vehiclePrompt: String {
        if isVehicleValid() {
            return " "
        } else {
            return "Enter the color and brand of your car"
        }
    }
    
    var emailPrompt: String {
        if isEmailValid() {
            return " "
        } else {
            return "Enter a valid email address"
        }
    }
    
    var passwordPrompt: String {
        if isPasswordValid() {
            return " \n"
        } else {
            return "Must be more than 6 characters containing a mix of letters and numbers"
        }
    }
    
    var isSignUpComplete: Bool {
        if !isPasswordValid() || !isEmailValid() || !isVehicleValid() {
            return false
        }
        return true
    }
    
    var isLoginComplete: Bool {
        if !isPasswordValid() || !isEmailValid() {
            return false
        }
        return true
    }
}
