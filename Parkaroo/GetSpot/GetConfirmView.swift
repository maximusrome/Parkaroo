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
            Text("Departing in: \(hours > 0 ? String(hours) + " hr" : "") \(mins > 0 ? String(mins) + " min" : hours != 0 ? "" : "0 min")")
                .bold()
                .onReceive(timer, perform: { input in
                    let diff = Date().distance(to: self.locationTransfer.gettingPin?.departure.dateValue() ?? Date())
                    depart = Int(diff / 60)
                    separateHoursAndMinutes()
                    if (locationTransfer.gettingPin?.buyer == nil || locationTransfer.gettingPin?.buyer == "") && (hours == 0 && mins < 0) {
                        locationTransfer.deleteSellerPin()
                        locationTransfer.minute = ""
                        locationTransfer.gettingPin = nil
                        self.gGRequestConfirm.showGetRequestView = false
                    }
                })
            Spacer()
            Text("Street Info: \(self.locationTransfer.getStreetInfoSelection)")
                .bold()
            Spacer()
            VStack {
                HStack {
                    Text("Seller: ")
                    Text("\(self.locationTransfer.seller?.vehicle ?? "")")
                        .autocapitalization(.words)
                        .multilineTextAlignment(.center)
                }.padding(.bottom)
                HStack {
                    Text("Rating: \(self.locationTransfer.seller?.numberOfRatings ?? 0 > 0 ? (String(format: "%.2f", self.locationTransfer.seller?.rating ?? 0)) : "N/A")")
                    Text("\(self.locationTransfer.seller?.numberOfRatings ?? 0) ratings")
                        .font(.footnote)
                }.padding(.bottom)
                NavigationLink(destination: Messages(chatroom: Chatroom(id: self.viewModel.docID, sellerID: self.locationTransfer.gettingPin?.seller ?? ""))) {
                    Text("Message Driver")
                        .bold()
                        .foregroundColor(Color("orange1"))
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
                    self.showingRefundAlert = true
                }) {
                    Text("cancel")
                        .padding(10)
                }.alert(isPresented: $showingRefundAlert) {
                    Alert(title: Text("Are you sure?"), primaryButton: Alert.Button.default(Text("No")), secondaryButton: Alert.Button.default(Text("Yes"), action: {
                        requestRefund()
                        viewModel.deleteChatroom()
                        self.gGRequestConfirm.showGetRequestView = false
                        self.gGRequestConfirm.showGetConfirmView = false
                    }))
                }
                Button(action: {
                    self.showingConfirmAlert = true
                }) {
                    Text("Complete Transfer")
                        .bold()
                        .padding(10)
                        .background(Color("orange1"))
                        .cornerRadius(50)
                }.alert(isPresented: $showingConfirmAlert) {
                    Alert(title: Text("Are You Parked?"), message: Text("Complete this transfer when you are successfully parked in the spot."), primaryButton: Alert.Button.default(Text("No")), secondaryButton: Alert.Button.default(Text("Yes"), action: {
                        Analytics.logEvent("buyer_complete_transfer", parameters: nil)
                        self.gGRequestConfirm.showGetRequestView = false
                        self.gGRequestConfirm.showGetConfirmView = false
                        self.gGRequestConfirm.showSellerRatingView = true
                        self.locationTransfer.gettingAnnotation = nil
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
        let credits = self.userInfo.user.credits + 1
        FBFirestore.mergeFBUser([C_CREDITS:credits], uid: self.userInfo.user.uid) { result in
            switch result {
            case .success(_):
                self.locationTransfer.gettingAnnotation = nil
                if let seller = locationTransfer.seller {
                    NotificationsService.shared.sendN(uid: seller.uid, message: "The buyer has canceled their reservation.")
                }
                let data = [C_BUYER:"", C_STATUS: pinStatus.available.rawValue]
                self.locationTransfer.updateGettingPin(data: data)
                self.locationTransfer.cleanUpGettingPin()
                self.userInfo.user.credits = credits
                Analytics.logEvent("buyer_canceled", parameters: nil)
            case .failure(_):
                print("Error Refunding")
            }
        }
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
