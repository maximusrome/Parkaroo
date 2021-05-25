//
//  ProductIDs.swift
//  Parkaroo
//
//  Created by Bernie Cartin on 5/18/21.
//

import Foundation

let productIDs = [
        "parkaroo.1credit",
//        "parkaroo.5credits",
//        "parkaroo.10credits",
        "parking.spot"
    ]

enum Products: String {
    case Credit1 = "parkaroo.1credit"
    case Credits5 = "parkaroo.5credits"
    case Credits10 = "parkaroo.10credits"
    
    var creditValue: Int {
        switch self {
        
        case .Credit1:
            return 1
        case .Credits5:
            return 5
        case .Credits10:
            return 10
        }
    }
}
