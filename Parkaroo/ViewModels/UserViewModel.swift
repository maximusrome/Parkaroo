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
                                      "^([a-zA-Z0-9 /-]{7,35})$")
        return vehicleTest.evaluate(with: vehicle)
    }
    func containsProfanity() -> Bool {
        return profanity.contains(where: vehicle.contains)
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
    func isEmailNotContainingSpace() -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[^ ]*")
        return emailTest.evaluate(with: email)
    }
    func isEmailNotContainingUppercase() -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[^A-Z]*")
        return emailTest.evaluate(with: email)
    }
    var isSignUpComplete: Bool {
        if !isPasswordValid() || !isEmailValid() || !isVehicleValid() || containsProfanity() || !isEmailNotContainingSpace() || !isEmailNotContainingUppercase() {
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
    var isVehicleComplete: Bool {
        if  !isVehicleValid() || containsProfanity() {
            return false
        }
        return true
    }
    let profanity = ["shit","fuck","poop","ass","cunt","testicle","wanker","pussy","dick","twat","penis","vagina","bitch","bastard","damn","piss","hoser","slut","whore","fag","homo","shag","cock","crap","douche","bollocks","sod","arse","tits","boob","prick","pecker","bomb","anus","jizz","cum","fanny","tranny","anal","ballsack","blowjob","boner","butt","dildo","dyke","jerk","nigger","nigga","pube","scrotum","sex","spunk","bimbo","breast","hooker","horny","pedophile","lesbo","molest","moron","idiot","pimp","queer","wtf","turd","retard","rape","porn","pee","nazi","kkk","klan","honkey","kooch","kike","drugs","Shit","Fuck","Poop","Ass","Cunt","Testicle","Wanker","Pussy","Dick","Twat","Penis","Vagina","Bitch","Bastard","Damn","Piss","Hoser","Slut","Whore","Fag","Homo","Shag","Cock","Crap","Douche","Bollocks","Sod","Arse","Tits","Boob","Prick","Pecker","Bomb","Anus","Jizz","Cum","Fanny","Tranny","Anal","Ballsack","Blowjob","Boner","Butt","Dildo","Dyke","Jerk","Nigger","Nigga","Pube","Scrotum","Sex","Spunk","Bimbo","Breast","Hooker","Horny","Pedophile","Lesbo","Molest","Moron","Idiot","Pimp","Queer","Wtf","Turd","Retard","Rape","Porn","Pee","Nazi","Kkk","Klan","Honkey","Kooch","Kike","Drugs"]
}
