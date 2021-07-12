//
//  CreditsViewModel.swift
//  Parkaroo
//
//  Created by max rome on 7/5/21.
//

import Foundation

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFunctions
import Stripe
import SwiftUI

final class CreditsViewModel: ObservableObject {
    // MARK: Public Properties
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    // MARK: Private Properties
    private let store = Firestore.firestore()
    private let functions = Functions.functions()
    init() {
        // Test Key
        //        StripeAPI.defaultPublishableKey = "pk_test_51J7X2vEW9EnruuomqDM0TdptXMw9LoVWJTsOiUSIAkzVCBDl7EmVEWG5mzAXahAbdZHtZYSimNF3Qc2G4S3lbjlo00miS2vVzp"
        // Production Key
        STPAPIClient.shared.publishableKey = "pk_live_51J7X2vEW9EnruuomxkLBUbuF8nLGas9IVN04uC7vHpdKEAzox4V6gSxVLxXrKZbBugLCdVCRT87d1jX8wkI82v3J00IOWDyfDR"
    }
    func preparePaymentSheet() {
        // MARK: - Fetch the PaymentIntent and Customer information form the backend
        functions.httpsCallable("preparePaymentSheet").call { [self] result, error in
            if let error = error {
                print("Error getting values from Firebase Functions: \(error)")
            } else if let result = result, let resultDict = result.data as? [String: String] {
                do {
                    let resultData = try JSONSerialization.data(withJSONObject: resultDict, options: .prettyPrinted)
                    let response = try JSONDecoder().decode(StripePaymentSheetPreparationResponse.self, from: resultData)
                    guard let customerId = response.customer,
                          let cusomerEphemeralKeySecret = response.ephemeralKey,
                          let paymentIntentClientSecret = response.paymentIntent
                    else { return }
                    // Create a PaymentSheet instance
                    var configuration = PaymentSheet.Configuration()
                    configuration.applePay = .init(merchantId: "merchant.org.parkaroo.maxrome", merchantCountryCode: "US")
                    configuration.merchantDisplayName = "Parkaroo, LLC"
                    configuration.primaryButtonColor = UIColor(Color("orange1"))
                    configuration.customer = .init(id: customerId, ephemeralKeySecret: cusomerEphemeralKeySecret)
                    paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
                } catch {
                    print(error)
                }
            }
        }
    }
    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
    }
}
