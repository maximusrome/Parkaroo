//
//  ProductIDs.swift
//  Parkaroo
//
//  Created by max rome on 5/18/21.
//

import Foundation

let productIDs = [
    "parkaroo.1credit",
    "parkaroo.1serviceToken"
]
enum Products: String {
    case Credit1 = "parkaroo.1credit"
    var creditValue: Int {
        switch self {
        case .Credit1:
            return 1
        }
    }
}
