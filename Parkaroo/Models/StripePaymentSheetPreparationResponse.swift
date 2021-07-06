//
//  StripePaymentSheetPreparationResponse.swift
//  Parkaroo
//
//  Created by max rome on 7/5/21.
//

import Foundation

struct StripePaymentSheetPreparationResponse: Codable {
    let customer: String?
    let ephemeralKey: String?
    let paymentIntent: String?
}
