//
//  CreditsView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI

struct CreditsView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var locationTransfer: LocationTransfer
    @State private var showingCreditSetupAlert = false
//    @ObservedObject var products = ProductsDB.shared
    @State private var showBuyCreditsView = false
    @State private var showSignInAlert = false
    
    
    
    var body: some View {
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
                    self.showBuyCreditsView = true
                }
                else {
                    showSignInAlert = true
                }
            }, label: {
                Text("Buy Credits")
                    .bold()
            })
            
            Spacer()
//            ForEach((0 ..< self.products.items.count), id: \.self) { column in
//                HStack {
//                    Spacer()
//                    Text(self.products.items[column].localizedDescription)
//                        .bold()
//                    Spacer()
//                    Text(self.products.price[column])
//                        .bold()
//                        .padding(10)
//                        .background(Color("orange1"))
//                        .cornerRadius(50)
//                        .font(.title3)
//                        .onTapGesture {
//                            if self.userInfo.isUserAuthenticated == .undefined || self.userInfo.isUserAuthenticated == .signedOut {
//                                self.showingCreditSetupAlert.toggle()
//                            } else {
//                                let _ = IAPManager.shared.purchase(product: self.products.items[column])
//                                self.locationTransfer.credits = self.locationTransfer.credits + self.products.creditsArray[column]
//                                self.locationTransfer.createCredit()
//                                self.locationTransfer.readCredit()
//                            }
//                        }
//                        .alert(isPresented: $showingCreditSetupAlert) {
//                            Alert(title: Text("Get Set Up"), message: Text("To reserve a spot you must have an account. Go to Sign Up or Login under menu."), dismissButton: .default(Text("Okay")))
//                        }
//                    Spacer()
//                }.padding(.vertical)
//            }
//            Spacer()
        }
        .font(.title)
        .foregroundColor(Color("black1"))
        .navigationBarTitle("Credits", displayMode: .inline)
//        .onAppear() {
//            IAPManager.shared.getProducts()
//            if self.userInfo.isUserAuthenticated == .signedIn {
//                self.locationTransfer.readCredit()
//            }
//        }
        .sheet(isPresented: $showBuyCreditsView, content: {
            BuyCreditsView()
        })
        .alert(isPresented: $showSignInAlert, content: {
            Alert(title: Text("You must be signed in to buy credits"))
        })
    }
}



struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
            .environmentObject(UserInfo())
            .environmentObject(LocationTransfer())
    }
}
