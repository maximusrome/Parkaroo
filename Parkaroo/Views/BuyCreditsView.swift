//
//  BuyCreditsView.swift
//  Parkaroo
//
//  Created by Bernie Cartin on 5/18/21.
//

import SwiftUI
import StoreKit

struct BuyCreditsView: View {
    
    @EnvironmentObject var iapManager: IAPManager
    @EnvironmentObject var userInfo: UserInfo
    @State private var showPurchaseConfirmation = false
    private var creditsPurchasing: products?
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Buy Credits")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.bottom)
            
            Divider()
            
            List(iapManager.myProducts, id: \.self) { product in
                HStack{
                    Text(product.localizedDescription)
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        print(product.localizedTitle)
                        iapManager.purchaseProduct(product: product)
                    }, label: {
                        Text("Buy for $\(product.price)")
                            .foregroundColor(.blue)
                    })
                }
                .padding(.vertical)
                
                Divider()
            }
            .onChange(of: iapManager.transactionState, perform: { value in
                switch iapManager.transactionState {
                
                case .purchased:
                    userInfo.addCredits(numberOfCredits: 1) { result in
                        switch result {
                        case .success(_):
                            self.showPurchaseConfirmation = true
                        case .failure(_):
                            print("Error updating credits")
                        }
                    }
                case .failed:
                    print("Error Purchasing")
                case .purchasing:
                    print("Purchasing...")
                default:
                    print("Other Error")
                }
            })
            .alert(isPresented: $showPurchaseConfirmation, content: {
                Alert(title: Text("Purchase Completed"), message: Text("The credits have been added to your account"), dismissButton: Alert.Button.default(Text("Okay")))
            })
            
//            HStack{
//                Text("1 Credit")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                Spacer()
//                Button(action: {}, label: {
//                    Text("Buy for $9.99")
//                })
//            }
//            .padding(.vertical)
//
//            Divider()
//
//            HStack{
//                Text("5 Credits")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                Spacer()
//                Button(action: {}, label: {
//                    Text("Buy for $49.99")
//                })
//            }
//            .padding(.vertical)
//
//            Divider()
//
//            HStack{
//                Text("10 Credits")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                Spacer()
//                Button(action: {}, label: {
//                    Text("Buy for $99.99")
//                })
//            }
//            .padding(.vertical)
//
//            Divider()
            
            Spacer()
        }
        .padding()
        .onAppear(perform: {
            iapManager.getProducts(productIDs: productIDs)
            SKPaymentQueue.default().add(iapManager)
        })
    }
    
}

struct BuyCreditsView_Previews: PreviewProvider {
    static var previews: some View {
        BuyCreditsView()
            .environmentObject(IAPManager())
            .environmentObject(UserInfo())
    }
}
