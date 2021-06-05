//
//  CreditsView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI
import StoreKit

struct CreditsView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var iapManager: IAPManager
    @State private var showSignInAlert = false
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("Your Credits")
                    .bold()
                    .padding(.bottom)
                Text("\(String(self.userInfo.user.credits))")
                    .bold()
                Spacer()
                Text("Buy 1 Credit")
                    .bold()
                    .padding(.bottom)
                Button(action: {
                    if userInfo.isUserAuthenticated == .signedIn {
                        if let product = iapManager.creditProduct {
                            iapManager.currentPurchasingProduct = product
                            iapManager.purchaseProduct(product: product)
                        }
                    } else {
                        self.showSignInAlert = true
                    }
                }) {
                    Text("$9.99")
                        .bold()
                        .font(.title2)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color("orange1"))
                        .cornerRadius(50)
                }.alert(isPresented: $showSignInAlert, content: {
                    Alert(title: Text("Get Set Up"), message: Text("To purchase a credit you must have an account. Go to Sign Up or Login under menu."), dismissButton: Alert.Button.default(Text("Okay")))
                })
                Spacer()
            }.font(.title)
            .foregroundColor(Color("black1"))
            .navigationBarTitle("Credits", displayMode: .inline)
            .onChange(of: iapManager.transactionState, perform: { value in
                if iapManager.currentPurchasingProduct?.productIdentifier == "parkaroo.1credit"  {
                    switch iapManager.transactionState {
                    case .purchased:
                        iapManager.currentPurchasingProduct = nil
                        userInfo.addCredits(numberOfCredits: 1) { result in
                            switch result {
                            case .success(_):
                                print("Successful purchase")
                                iapManager.showActivityIndicator = false
                            case .failure(_):
                                print("Error updating credits")
                                iapManager.showActivityIndicator = false
                            }
                        }
                    case .failed:
                        print("Error Purchasing")
                        iapManager.showActivityIndicator = false
                        iapManager.currentPurchasingProduct = nil
                    case .purchasing:
                        iapManager.showActivityIndicator = true
                        print("Purchasing...")
                    default:
                        print("Other Error")
                        iapManager.showActivityIndicator = false
                        iapManager.currentPurchasingProduct = nil
                    }
                }
            })
            if iapManager.showActivityIndicator {
                ActivityIndicatorView()
            }
        }
    }
}
struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
            .environmentObject(UserInfo())
            .environmentObject(IAPManager())
    }
}
