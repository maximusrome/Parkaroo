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
    @EnvironmentObject var locationTransfer: LocationTransfer
    @State private var showingCreditSetupAlert = false
    @State private var showSignInAlert = false
    
    @EnvironmentObject var iapManager: IAPManager
    @State private var showPurchaseConfirmation = false
    
    
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
                Button(action: {
                    if userInfo.isUserAuthenticated == .signedIn {
                        if let product = iapManager.creditProduct {
                            iapManager.currentPurchasingProduct = product
                            iapManager.purchaseProduct(product: product)
                        }
                    }
                    else {
                        showSignInAlert = true
                    }
                }, label: {
                    Text("Buy 1 Credit")
                        .bold()
                })
                
                Spacer()
            }
            .font(.title)
            .foregroundColor(Color("black1"))
            .navigationBarTitle("Credits", displayMode: .inline)
            .alert(isPresented: $showSignInAlert, content: {
                Alert(title: Text("You must be signed in to buy credits"))
            })
            .alert(isPresented: $showPurchaseConfirmation, content: {
                
                Alert(title: Text("Purchase Completed"), message: Text("The credits have been added to your account"), dismissButton: Alert.Button.default(Text("Okay"), action: {
                    iapManager.showActivityIndicator = false
                }))
            })
            .onChange(of: iapManager.transactionState, perform: { value in
                
                if iapManager.currentPurchasingProduct?.productIdentifier == "parkaroo.1credit"  {
                    
                    switch iapManager.transactionState {
                    
                    case .purchased:
                        iapManager.currentPurchasingProduct = nil
                        userInfo.addCredits(numberOfCredits: 1) { result in
                            switch result {
                            case .success(_):
                                self.showPurchaseConfirmation = true
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
            .environmentObject(LocationTransfer())
            .environmentObject(IAPManager())
    }
}
