//
//  GetRequestView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI
import StoreKit

struct GetRequestView: View {
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var iapManager: IAPManager
    @State var rating = 5
    @State private var showingReserveSetupAlert = false
    @State private var showingNotEnoughCreditsAlert = false
    @State private var showPurchaseConfirmation = false
    @State private var showActivityIndicator = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var depart = Int()
    var body: some View {
        VStack {
            VStack {
                Text("Departing in: \(depart >= 0 ? String(depart) + " minutes" : "")")
                    .bold()
                    .padding()
                    .padding(.top, 10)
                    .onReceive(timer, perform: { input in
                        let diff = Date().distance(to: self.locationTransfer.gettingPin?.departure.dateValue() ?? Date())
                        depart = Int(diff / 60)
                    })
                Spacer()
                HStack {
                    Text("Rating: \(String(format: "%.2f", self.locationTransfer.seller?.rating ?? 0))")
                        .bold()
                    Image(systemName: "star.fill")
                        .foregroundColor(Color("orange1"))
                    Text("\(self.locationTransfer.seller?.numberOfRatings ?? 0) ratings")
                        .font(.footnote)
                }
                Spacer()
                HStack {
                    Button(action: {
                        self.gGRequestConfirm.showGetRequestView = false
                    }) {
                        Text("close")
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                    }
                    Button(action: {
                        reserveSpot()
                    }) {
                        Text("Reserve Spot")
                            .bold()
                            .padding(10)
                            .background(Color("orange1"))
                            .cornerRadius(50)
                    }.alert(isPresented: $showingReserveSetupAlert) {
                        Alert(title: Text("Get Set Up"), message: Text("To reserve a spot you must have an account. Go to Sign Up or Login under the menu."), dismissButton: .default(Text("Okay")))
                    }
                }.padding(.top)
                .padding(.horizontal)
                HStack {
                Spacer()
                Spacer()
                Spacer()
                Text("1 credit + $0.99 service fee")
                    .font(.footnote)
                    .alert(isPresented: $showingNotEnoughCreditsAlert) {
                        Alert(title: Text("Not Enough Credits"), message: Text("You don't have enough credits. You can give up your spot to earn a credit or purchase them in the credits page under the menu."), dismissButton: .default(Text("Okay")))
                    }
                Spacer()
                }.padding(.bottom, 25)
            }.frame(width: 300, height: 200)
            .background(Color("white1"))
            .foregroundColor(Color("black1"))
            .cornerRadius(30)
            .shadow(radius: 5)
            .padding(.bottom)
            .padding(.horizontal, 50)
        }
        .onChange(of: iapManager.transactionState, perform: { value in
            if iapManager.currentPurchasingProduct?.productIdentifier == "parking.spot" {
                switch iapManager.transactionState {
                case .purchased:
                    iapManager.showActivityIndicator = false
                    userInfo.addCredits(numberOfCredits: -1) { result in
                        switch result {
                        case .success(_):
                            iapManager.currentPurchasingProduct = nil
                            self.completeTransaction()
                        case .failure(_):
                            print("Error updating credits")
                        }
                    }
                case .failed:
                    iapManager.currentPurchasingProduct = nil
                    print("Error Purchasing")
                    iapManager.showActivityIndicator = false
                case .purchasing:
                    iapManager.showActivityIndicator = true
                    print("Purchasing...")
                default:
                    iapManager.currentPurchasingProduct = nil
                    print("Other Error")
                    iapManager.showActivityIndicator = false
                }
            }
        })
    }
    private func reserveSpot() {
        //UNCOMMENT TO TEST ON SIMULATOR
        //        userInfo.addCredits(numberOfCredits: -1) { result in
        //            switch result {
        //            case .success(_):
        //                self.completeTransaction()
        //            case .failure(_):
        //                print("Error updating credits")
        //            }
        //        }
        //UNCOMMENT TO RUN PRODUCTION VERSION
        if self.userInfo.isUserAuthenticated == .signedIn {
            if self.userInfo.user.credits > 0 {
                if self.userInfo.user.email.contains("tester101") {
                    userInfo.addCredits(numberOfCredits: -1) { result in
                        switch result {
                        case .success(_):
                            self.completeTransaction()
                            print("Credit subtracted")
                        case .failure(_):
                            print("Error updating credits")
                        }
                    }
                    print("This is a tester")
                } else {
                    if let product = iapManager.transactionProduct {
                        iapManager.currentPurchasingProduct = product
                        iapManager.purchaseProduct(product: product)
                    }
                    print("This is NOT a tester")
                }
            } else {
                self.showingNotEnoughCreditsAlert = true
            }
        } else {
            self.showingReserveSetupAlert = true
        }
    }
    private func completeTransaction() {
        self.gGRequestConfirm.showGetRequestView = false
        self.gGRequestConfirm.showGetConfirmView = true
        let data = [C_BUYER:userInfo.user.uid, C_STATUS: pinStatus.reserved.rawValue]
        self.locationTransfer.updateGettingPin(data: data)
        if let id = self.locationTransfer.gettingPin?.id {
            self.locationTransfer.fetchGettingPin(id: id)
        }
        if let seller = locationTransfer.seller {
            NotificationsService.shared.sendNotification(uid: seller.uid, message: "Your spot was reserved")
        }
        // add pin
        if let location = locationTransfer.gettingPin?.location {
            let annotation = CustomMKPointAnnotation()
            annotation.coordinate = location
            annotation.id = locationTransfer.gettingPin?.id
            annotation.type = .reserved
            self.locationTransfer.gettingAnnotation = annotation
        }
    }
}
struct GetRequestView_Previews: PreviewProvider {
    static var previews: some View {
        GetRequestView()
            .previewLayout(.sizeThatFits)
            .environmentObject(GGRequestConfirm())
            .environmentObject(LocationTransfer())
            .environmentObject(UserInfo())
            .environmentObject(IAPManager())
    }
}
