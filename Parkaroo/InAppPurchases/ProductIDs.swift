//
//  ProductIDs.swift
//  Parkaroo
//
//  Created by max rome on 5/18/21.
//

import Foundation

let productIDs = [
    "parkaroo.1credit",
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
//  @EnvironmentObject var iapManager: IAPManager
//                        if let product = iapManager.creditProduct {
//                            iapManager.currentPurchasingProduct = product
//                            iapManager.purchaseProduct(product: product)
//                        }
//            .onChange(of: iapManager.transactionState, perform: { value in
//                if iapManager.currentPurchasingProduct?.productIdentifier == "parkaroo.1credit"  {
//                    switch iapManager.transactionState {
//                    case .purchased:
//                        iapManager.currentPurchasingProduct = nil
//                        userInfo.addCredits(numberOfCredits: 1) { result in
//                            switch result {
//                            case .success(_):
//                                print("Successful purchase")
//                                iapManager.showActivityIndicator = false
//                            case .failure(_):
//                                print("Error updating credits")
//                                iapManager.showActivityIndicator = false
//                            }
//                        }
//                    case .failed:
//                        print("Error Purchasing")
//                        iapManager.showActivityIndicator = false
//                        iapManager.currentPurchasingProduct = nil
//                    case .purchasing:
//                        iapManager.showActivityIndicator = true
//                        print("Purchasing...")
//                    default:
//                        print("Other Error")
//                        iapManager.showActivityIndicator = false
//                        iapManager.currentPurchasingProduct = nil
//                    }
//                }
//            })
//            if iapManager.showActivityIndicator {
//                ActivityIndicatorView()
//            }
