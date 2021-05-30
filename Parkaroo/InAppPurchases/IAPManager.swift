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
    
    @Published var transactionProduct: SKProduct?
    @Published var creditProduct: SKProduct?
    
    @Published var currentPurchasingProduct: SKProduct?
    @Published var showActivityIndicator = false
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Did receive response")
        
        if !response.products.isEmpty {
            for fetchedProduct in response.products {
                DispatchQueue.main.async {
                    self.myProducts.append(fetchedProduct)
                    if fetchedProduct.productIdentifier == "parkaroo.1credit" {
                        self.creditProduct = fetchedProduct
                    }
                    else if fetchedProduct.productIdentifier == "parking.spot" {
                        self.transactionProduct = fetchedProduct
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
