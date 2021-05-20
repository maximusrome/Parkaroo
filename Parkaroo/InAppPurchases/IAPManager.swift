//
//  IAPManager.swift
//  Parkaroo
//
//  Created by max rome on 2/12/21.
//

import Foundation
import StoreKit

class IAPManager: NSObject, ObservableObject, SKProductsRequestDelegate {
    
    
    @Published var myProducts = [SKProduct]()
    @Published var transactionState: SKPaymentTransactionState?
    var request: SKProductsRequest!
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Did receive response")
        
        if !response.products.isEmpty {
            for fetchedProduct in response.products {
                DispatchQueue.main.async {
                    self.myProducts.append(fetchedProduct)
                    self.myProducts.sort { p1, p2 in
                        return Double(truncating: p1.price) < Double(truncating: p2.price)
                    }
                }
            }
        }
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("Invalid identifiers found: \(invalidIdentifier)")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request did fail: \(error)")
    }
    
    func getProducts(productIDs: [String]) {
        print("Start requesting products ...")
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    
}

extension IAPManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                DispatchQueue.main.async {
                    self.transactionState = .purchasing
                }
            case .purchased:
                queue.finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.transactionState = .purchased
                }
            case .restored:
                queue.finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.transactionState = .restored
                }
            case .failed, .deferred:
                queue.finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.transactionState = .failed
                }
            default:
                queue.finishTransaction(transaction)
            }
        }
    }
    
    func purchaseProduct(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("User can't make payment.")
        }
    }
}

//private let allTicketIdentifiers: Set<String> = [
//    "parkaroo.1credit",
//    "parkaroo.5credits",
//    "parkaroo.10credits"
//]
//class IAPManager: NSObject {
//    static let shared = IAPManager()
//    private override init() {
//        super.init()
//    }
//    func getProducts() {
//        let request = SKProductsRequest(productIdentifiers: allTicketIdentifiers)
//        request.delegate = self
//        request.start()
//    }
//    func purchase(product: SKProduct) -> Bool {
//        if !IAPManager.shared.canMakePayments() {
//            return false
//        } else {
//            let payment = SKPayment(product: product)
//            SKPaymentQueue.default().add(payment)
//        }
//        return true
//    }
//    func canMakePayments() -> Bool {
//        return SKPaymentQueue.canMakePayments()
//    }
//}
//extension IAPManager: SKProductsRequestDelegate, SKRequestDelegate {
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        let badProducts = response.invalidProductIdentifiers
//        let goodProducts = response.products
//        if !goodProducts.isEmpty {
//            ProductsDB.shared.items = response.products
//            print("bon ", ProductsDB.shared.items)
//        }
//        print("badProducts ", badProducts)
//    }
//    func request(_ request: SKRequest, didFailWithError error: Error) {
//        print("didFailWithError ", error)
//        DispatchQueue.main.async {
//            print("purchase failed")
//        }
//    }
//    func requestDidFinish(_ request: SKRequest) {
//        DispatchQueue.main.async {
//            print("request did finish ")
//        }
//    }
//}
//final class ProductsDB: ObservableObject, Identifiable {
//    static let shared = ProductsDB()
//    var items: [SKProduct] = [] {
//        willSet {
//            DispatchQueue.main.async {
//                self.objectWillChange.send()
//            }
//        }
//    }
//    var price: [String] = ["$9.99", "$49.99", "$99.99"]
//    var creditsArray: [Int] = [1, 5, 10]
//}



