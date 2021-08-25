//
//  GiveConfirmView.swift
//  Parkaroo
//
//  Created by max rome on 5/8/21.
//

import SwiftUI
import Firebase

struct GiveConfirmView: View {
    @ObservedObject var viewModel = ChatroomsViewModel()
    init() {
        viewModel.fetchData()
    }
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var userInfo: UserInfo
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var depart = Int()
    @State private var hours = Int()
    @State private var mins = Int()
    @State private var showingSellerCancelAlert = false
    @State private var messageClicked = false
    var body: some View {
        VStack {
            Text("Spot \(locationTransfer.givingPin?.status.capitalized ?? "")")
                .bold()
                .font(.title)
                .padding(.top, 25)
            Spacer()
            Text("Departing in: \(hours > 0 ? String(hours) + " hr" : "") \(mins > 0 ? String(mins) + " min" : hours > 0 ? "" : "0 min")")
                .bold()
                .onReceive(timer, perform: { input in
                    let diff = Date().distance(to: locationTransfer.givingPin?.departure.dateValue() ?? Date())
                    depart = Int(diff / 60)
                    separateHoursAndMinutes()
                    if (locationTransfer.givingPin?.buyer == nil || locationTransfer.givingPin?.buyer == "") && (hours <= 0 && mins < 0) {
                        locationTransfer.deletePin()
                        locationTransfer.minute = ""
                        locationTransfer.givingPin = nil
                        gGRequestConfirm.showGiveConfirmView = false
                    }
                })
            Spacer()
            HStack {
                Text("Street Info:")
                    .bold()
                Text("\(locationTransfer.giveStreetInfoSelection)")
                    .bold()
                    .multilineTextAlignment(.center)
            }
            Spacer()
            if let buyer = locationTransfer.buyer {
                VStack {
                    HStack {
                        Text("Buyer:")
                        Text("\(buyer.vehicle)")
                            .autocapitalization(.words)
                            .multilineTextAlignment(.center)
                    }.padding(.bottom)
                    HStack {
                        Text("Rating: \(locationTransfer.buyer?.numberOfRatings ?? 0 > 0 ? (String(format: "%.2f", locationTransfer.buyer?.rating ?? 0)) : "N/A")")
                        Text("\(locationTransfer.buyer?.numberOfRatings ?? 0) ratings")
                            .font(.footnote)
                    }.padding(.bottom)
                    NavigationLink(destination: Messages(chatroom: Chatroom(id: viewModel.docID, sellerID: locationTransfer.givingPin?.seller ?? ""))) {
                        Text("Message Driver")
                            .bold()
                            .foregroundColor(Color("orange1"))
                    }
                }.padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(Color.gray, lineWidth: 2)
                )
                Spacer()
                HStack {
                    Button(action: {
                        showingSellerCancelAlert = true
                    }) {
                        Text("cancel")
                            .padding(10)
                    }.alert(isPresented: $showingSellerCancelAlert, content: {
                        Alert(title: Text("Are you sure?"), message: Text("Friendly reminder: Someone has reserved your spot and may be asked to rate you."), primaryButton: .cancel(Text("No")), secondaryButton: .default(Text("Yes"), action: {
                            viewModel.deleteChatroom()
                            locationTransfer.deletePin()
                            locationTransfer.minute = ""
                            gGRequestConfirm.showGiveConfirmView = false
                            Analytics.logEvent("seller_canceled", parameters: nil)
                            if let buyer = locationTransfer.buyer {
                                NotificationsService.shared.sendN(uid: buyer.uid, message: "The seller has canceled their spot")
                            }
                        }))
                    })
                    Text("Awaiting Car Arrival")
                        .bold()
                        .padding(10)
                        .background(Color(white: 0.7))
                        .cornerRadius(50)
                }.padding(.bottom, 25)
            } else {
                VStack {
                    Text("Awaiting Buyer")
                        .padding(.bottom)
                    Text("You will soon earn a credit")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }.padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(Color.gray, lineWidth: 2)
                )
                Spacer()
                Button(action: {
                    locationTransfer.deletePin()
                    locationTransfer.minute = ""
                    gGRequestConfirm.showGiveConfirmView = false
                }) {
                    Text("cancel")
                        .padding(10)
                        .background(Color(white: 0.7))
                        .cornerRadius(50)
                        .padding(.bottom, 25)
                }
            }
        }.frame(width: 320, height: 400)
        .background(Color("white1"))
        .foregroundColor(Color("black1"))
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.bottom)
        .padding(.horizontal, 50)
        .onChange(of: locationTransfer.givingPin?.ratingSubmitted ?? false, perform: { _ in
            if gGRequestConfirm.showGiveConfirmView && (locationTransfer.givingPin?.ratingSubmitted ?? false) {
                gGRequestConfirm.showGiveConfirmView = false
                gGRequestConfirm.showBuyerRatingView = true
                locationTransfer.givingPin = nil
                locationTransfer.locations.removeAll()
                addCredit()
                Analytics.logEvent("seller_complete_transfer", parameters: nil)
            }
        })
    }
    private func separateHoursAndMinutes() {
        mins = depart % 60
        hours = (depart - mins)/60
    }
    private func addCredit() {
        let updateCredits = userInfo.user.credits + 1
        FBFirestore.mergeFBUser([C_CREDITS:updateCredits], uid: userInfo.user.uid) { result in
            switch result {
            case .success(_):
                print("Credit Added")
                userInfo.user.credits += 1
            case .failure(_):
                print("Error")
            }
        }
    }
}
struct GiveConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        GiveConfirmView()
            .previewLayout(.sizeThatFits)
            .environmentObject(GGRequestConfirm())
            .environmentObject(LocationTransfer())
            .environmentObject(UserInfo())
    }
}
