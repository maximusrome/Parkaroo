//
//  ProductIDs.swift
//  Parkaroo
//
//  Created by Bernie Cartin on 5/18/21.
//

import Foundation

let productIDs = [
        "parkaroo.1credit",
        "parkaroo.5credits",
        "parkaroo.10credits"
    ]

enum products: Int {
    case Credit1 = 1
    case Credits5 = 5
    case Credits10 = 10
}
