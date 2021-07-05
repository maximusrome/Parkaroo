//
//  StripePaymentSheetPreparationResponse.swift
//  Parkaroo
//
//  Created by Carlos Aguilar on 7/3/21.
//

import Foundation

struct StripePaymentSheetPreparationResponse: Codable {
    let customer: String?
    let ephemeralKey: String?
    let paymentIntent: String?
}
