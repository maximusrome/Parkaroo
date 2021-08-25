//
//  GetRequestView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI
import StoreKit
import Firebase

struct GetRequestView: View {
    init() {
        viewModel.fetchData()
    }
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var userInfo: UserInfo
    @ObservedObject var viewModel = ChatroomsViewModel()
    @State var rating = 5
    @State private var showingSameUserReserveAlert = false
    @State private var showingReserveSetupAlert = false
    @State private var showingNotEnoughCreditsAlert = false
    @State private var showPurchaseConfirmation = false
    @State private var showActivityIndicator = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var depart = Int()
    @State private var hours = Int()
    @State private var mins = Int()
    var body: some View {
        VStack {
            Text("Departing in: \(hours > 0 ? String(hours) + " hr" : "") \((mins > 0 || hours <= 0) ? String(mins) + " min" : "")")
                .bold()
                .padding(.top, 35)
                .onReceive(timer, perform: { input in
                    let diff = Date().distance(to: locationTransfer.gettingPin?.departure.dateValue() ?? Date())
                    depart = Int(diff / 60)
                    separateHoursAndMinutes()
                })
            Spacer()
            HStack {
                Text("Street Info:")
                    .bold()
                Text("\(locationTransfer.getStreetInfoSelection)")
                    .bold()
                    .multilineTextAlignment(.center)
            }
            Spacer()
            HStack {
                if locationTransfer.seller?.rating != 0 {
                    Text("Seller Rating: \(String(format: "%.2f", locationTransfer.seller?.rating ?? 0))")
                        .bold()
                } else {
                    Text("Seller Rating: N/A")
                        .bold()
                }
                Text("\(locationTransfer.seller?.numberOfRatings ?? 0) ratings")
                    .font(.footnote)
                    .alert(isPresented: $showingNotEnoughCreditsAlert) {
                        Alert(title: Text("Not Enough Credits"), message: Text("You don't have enough credits. Give up your spot to earn a credit or purchase a credit in the Credits page under the menu."), dismissButton: .default(Text("Okay")))
                    }
            }
            Spacer()
            HStack {
                Button(action: {
                    gGRequestConfirm.showGetRequestView = false
                }) {
                    Text("close")
                        .padding(10)
                }.alert(isPresented: $showingSameUserReserveAlert) {
                    Alert(title: Text("You Can't Reserve Your Own Spot"), dismissButton: .default(Text("Okay")))
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
            }.padding(.bottom, 25)
        }.frame(width: 320, height: 280)
        .background(Color("white1"))
        .foregroundColor(Color("black1"))
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.bottom)
        .padding(.horizontal, 50)
    }
    private func separateHoursAndMinutes() {
        mins = depart % 60
        hours = (depart - mins)/60
    }
    private func reserveSpot() {
        if userInfo.isUserAuthenticated == .signedIn {
            if locationTransfer.seller?.uid != Auth.auth().currentUser?.uid {
                if userInfo.user.credits > 0 {
                    userInfo.addCredits(numberOfCredits: -1) { result in
                        switch result {
                        case .success(_):
                            print("Credit subtracted")
                            viewModel.createChatroom(sellerID: locationTransfer.gettingPin?.seller ?? "")
                            completeTransaction()
                        case .failure(_):
                            print("Error updating credits")
                        }
                    }
                } else {
                    showingNotEnoughCreditsAlert = true
                }
            } else {
                showingSameUserReserveAlert = true
            }
        } else {
            showingReserveSetupAlert = true
        }
    }
    private func completeTransaction() {
        Analytics.logEvent("reserve_spot", parameters: nil)
        gGRequestConfirm.showGetRequestView = false
        gGRequestConfirm.showGetConfirmView = true
        let data = [C_BUYER:userInfo.user.uid, C_STATUS: pinStatus.reserved.rawValue]
        locationTransfer.updateGettingPin(data: data)
        if let id = locationTransfer.gettingPin?.id {
            locationTransfer.fetchGettingPin(id: id)
        }
        if let seller = locationTransfer.seller {
            NotificationsService.shared.sendN(uid: seller.uid, message: "Your spot was reserved")
        }
        if let location = locationTransfer.gettingPin?.location {
            let annotation = CustomMKPointAnnotation()
            annotation.coordinate = location
            annotation.id = locationTransfer.gettingPin?.id
            annotation.type = .reserved
            locationTransfer.gettingAnnotation = annotation
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
    }
}
