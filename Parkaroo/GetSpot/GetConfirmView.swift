//
//  GetConfirmView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI
import Firebase

struct GetConfirmView: View {
    @ObservedObject var viewModel = ChatroomsViewModel()
    init() {
        viewModel.fetchData()
    }
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @EnvironmentObject var userInfo: UserInfo
    @State var rating = 5
    @State private var showingRefundAlert = false
    @State private var showingCancelOptionAlert = false
    @State private var showingConfirmAlert = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var depart = Int()
    @State private var hours = Int()
    @State private var mins = Int()
    @State private var messageClicked = false
    var body: some View {
        VStack {
            Text("Spot Reserved")
                .bold()
                .font(.title)
                .padding(.top, 25)
            Spacer()
            Text("Departing in: \(hours > 0 ? String(hours) + " hr" : "") \(mins > 0 ? String(mins) + " min" : hours > 0 ? "" : "0 min")")
                .bold()
                .onReceive(timer, perform: { input in
                    let diff = Date().distance(to: locationTransfer.gettingPin?.departure.dateValue() ?? Date())
                    depart = Int(diff / 60)
                    separateHoursAndMinutes()
                    if (locationTransfer.gettingPin?.buyer == nil || locationTransfer.gettingPin?.buyer == "") && (hours <= 0 && mins < 0) {
                        locationTransfer.deleteSellerPin()
                        locationTransfer.cleanUpGettingPin()
                        locationTransfer.minute = ""
                        gGRequestConfirm.showGetRequestView = false
                    }
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
            VStack {
                HStack {
                    Text("Seller:")
                    Text("\(locationTransfer.seller?.vehicle ?? "")")
                        .autocapitalization(.words)
                        .multilineTextAlignment(.center)
                }.padding(.bottom)
                HStack {
                    Text("Rating: \(locationTransfer.seller?.numberOfRatings ?? 0 > 0 ? (String(format: "%.2f", locationTransfer.seller?.rating ?? 0)) : "N/A")")
                    Text("\(locationTransfer.seller?.numberOfRatings ?? 0) ratings")
                        .font(.footnote)
                }.padding(.bottom)
                NavigationLink(destination: Messages(chatroom: Chatroom(id: viewModel.docID, sellerID: locationTransfer.gettingPin?.seller ?? ""))) {
                    Text("Message Driver")
                        .bold()
                        .foregroundColor(Color("orange1"))
                }.alert(isPresented: $showingCancelOptionAlert) {
                    Alert(title: Text("Tell Us Why"), primaryButton: Alert.Button.default(Text("Seller did not show up"), action: {
                        requestRefund()
                        viewModel.deleteChatroom()
                        gGRequestConfirm.showGetRequestView = false
                        gGRequestConfirm.showGetConfirmView = false
                    }), secondaryButton: Alert.Button.default(Text("I changed my mind"), action: {
                        cancelNoRefund()
                        viewModel.deleteChatroom()
                        gGRequestConfirm.showGetRequestView = false
                        gGRequestConfirm.showGetConfirmView = false
                    }))
                }
            }.padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .padding(.horizontal)
            Spacer()
            HStack {
                Button(action: {
                    showingRefundAlert = true
                }) {
                    Text("cancel")
                        .padding(10)
                }.alert(isPresented: $showingRefundAlert) {
                    Alert(title: Text("Are You Sure?"), message: Text("Canceling may result in credit loss"), primaryButton: Alert.Button.default(Text("No")), secondaryButton: Alert.Button.default(Text("Yes"), action: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showingCancelOptionAlert = true
                        }
                    }))
                }
                Button(action: {
                    showingConfirmAlert = true
                }) {
                    Text("Complete Transfer")
                        .bold()
                        .padding(10)
                        .background(Color("orange1"))
                        .cornerRadius(50)
                        .multilineTextAlignment(.center)
                }.alert(isPresented: $showingConfirmAlert) {
                    Alert(title: Text("Are You Parked?"), message: Text("Complete this transfer when you are successfully parked in the spot."), primaryButton: Alert.Button.default(Text("No")), secondaryButton: Alert.Button.default(Text("Yes"), action: {
                        Analytics.logEvent("buyer_complete_transfer", parameters: nil)
                        gGRequestConfirm.showGetRequestView = false
                        gGRequestConfirm.showGetConfirmView = false
                        gGRequestConfirm.showSellerRatingView = true
                        locationTransfer.gettingAnnotation = nil
                    }))
                }
            }.padding(.bottom, 25)
        }.frame(width: 320, height: 400)
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
    private func requestRefund() {
        let credits = userInfo.user.credits + 1
        FBFirestore.mergeFBUser([C_CREDITS:credits], uid: userInfo.user.uid) { result in
            switch result {
            case .success(_):
                locationTransfer.gettingAnnotation = nil
                if let seller = locationTransfer.seller {
                    NotificationsService.shared.sendN(uid: seller.uid, message: "The buyer has canceled their reservation.")
                }
                let data = [C_BUYER:"", C_STATUS: pinStatus.available.rawValue]
                locationTransfer.updateGettingPin(data: data)
                locationTransfer.cleanUpGettingPin()
                userInfo.user.credits = credits
                Analytics.logEvent("buyer_canceled", parameters: nil)
            case .failure(_):
                print("Error Refunding")
            }
        }
    }
    private func cancelNoRefund() {
        locationTransfer.gettingAnnotation = nil
        if let seller = locationTransfer.seller {
            NotificationsService.shared.sendN(uid: seller.uid, message: "The buyer has canceled their reservation.")
        }
        let data = [C_BUYER:"", C_STATUS: pinStatus.available.rawValue]
        locationTransfer.updateGettingPin(data: data)
        locationTransfer.cleanUpGettingPin()
        Analytics.logEvent("buyer_canceled", parameters: nil)
    }
}
struct GetConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GetConfirmView()
                .environmentObject(LocationTransfer())
                .environmentObject(GGRequestConfirm())
                .environmentObject(UserInfo())
                .previewLayout(.sizeThatFits)
        }
    }
}
