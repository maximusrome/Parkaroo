//
//  IAPManager.swift
//  Parkaroo
//
//  Created by max rome on 2/12/21.
//

import Foundation
import StoreKit

private let allTicketIdentifiers: Set<String> = [
    "parkaroo.1credit",
    "parkaroo.5credits",
    "parkaroo.10credits"
]
class IAPManager: NSObject {
    static let shared = IAPManager()
    private override init() {
        super.init()
    }
    func getProducts() {
        let request = SKProductsRequest(productIdentifiers: allTicketIdentifiers)
        request.delegate = self
        request.start()
    }
    func purchase(product: SKProduct) -> Bool {
        if !IAPManager.shared.canMakePayments() {
            return false
        } else {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
        return true
    }
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
}
extension IAPManager: SKProductsRequestDelegate, SKRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let badProducts = response.invalidProductIdentifiers
        let goodProducts = response.products
        if !goodProducts.isEmpty {
            ProductsDB.shared.items = response.products
            print("bon ", ProductsDB.shared.items)
        }
        print("badProducts ", badProducts)
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("didFailWithError ", error)
        DispatchQueue.main.async {
            print("purchase failed")
        }
    }
    func requestDidFinish(_ request: SKRequest) {
        DispatchQueue.main.async {
            print("request did finish ")
        }
    }
}
final class ProductsDB: ObservableObject, Identifiable {
    static let shared = ProductsDB()
    var items: [SKProduct] = [] {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    var price: [String] = ["$9.99", "$49.99", "$99.99"]
    var creditsArray: [Int] = [1, 5, 10]
}
