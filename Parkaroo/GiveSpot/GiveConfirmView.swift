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
            Text("Spot \(self.locationTransfer.givingPin?.status.capitalized ?? "")")
                .bold()
                .font(.title)
                .padding(.top, 25)
            Spacer()
            Text("Departing in: \(hours > 0 ? String(hours) + " hr" : "") \(mins > 0 ? String(mins) + " min" : hours != 0 ? "" : "0 min")")
                .bold()
                .onReceive(timer, perform: { input in
                    let diff = Date().distance(to: self.locationTransfer.givingPin?.departure.dateValue() ?? Date())
                    depart = Int(diff / 60)
                    separateHoursAndMinutes()
                    if (locationTransfer.givingPin?.buyer == nil || locationTransfer.givingPin?.buyer == "") && (hours == 0 && mins < 0) {
                        locationTransfer.deletePin()
                        locationTransfer.minute = ""
                        locationTransfer.givingPin = nil
                        self.gGRequestConfirm.showGiveConfirmView = false
                    }
                })
            Spacer()
            Text("Street Info: \(self.locationTransfer.giveStreetInfoSelection)")
                .bold()
            Spacer()
            if let buyer = locationTransfer.buyer {
                VStack {
                    HStack {
                        Text("Buyer: ")
                        Text("\(buyer.vehicle)")
                            .autocapitalization(.words)
                            .multilineTextAlignment(.center)
                    }.padding(.bottom)
                    HStack {
                        Text("Rating: \(self.locationTransfer.buyer?.numberOfRatings ?? 0 > 0 ? (String(format: "%.2f", self.locationTransfer.buyer?.rating ?? 0)) : "N/A")")
                        Text("\(self.locationTransfer.buyer?.numberOfRatings ?? 0) ratings")
                            .font(.footnote)
                    }.padding(.bottom)
                    Button(action: {
                        self.messageClicked.toggle()
                    }) {
                        Text("Message Driver")
                            .bold()
                            .foregroundColor(Color("orange1"))
                    }.fullScreenCover(isPresented: $messageClicked) {
                        NavigationView {
                            ForEach(viewModel.chatrooms) { chatroom in
                                Messages(chatroom: chatroom)
                            }
                        }
                    }
                }.padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(Color.gray, lineWidth: 2)
                )
                Spacer()
                HStack {
                    if !(locationTransfer.givingPin?.ratingSubmitted ?? false) {
                        Button(action: {
                            self.showingSellerCancelAlert = true
                        }) {
                            Text("cancel")
                                .padding(10)
                        }.alert(isPresented: $showingSellerCancelAlert, content: {
                            Alert(title: Text("Are you sure?"), message: Text("Friendly reminder: Someone has reserved your spot and may be asked to rate you."), primaryButton: .cancel(Text("No")), secondaryButton: .default(Text("Yes"), action: {
                                viewModel.deleteChatroom()
                                locationTransfer.deletePin()
                                locationTransfer.minute = ""
                                self.gGRequestConfirm.showGiveConfirmView = false
                                Analytics.logEvent("seller_canceled", parameters: nil)
                                if let buyer = locationTransfer.buyer {
                                    NotificationsService.shared.sendN(uid: buyer.uid, message: "The seller has canceled their spot")
                                }
                            }))
                        })
                    }
                    Button(action: {
                        self.gGRequestConfirm.showGiveConfirmView = false
                        self.gGRequestConfirm.showBuyerRatingView = true
                        self.locationTransfer.givingPin = nil
                        self.locationTransfer.locations.removeAll()
                        addCredit()
                        Analytics.logEvent("seller_complete_transfer", parameters: nil)
                    }) {
                        Text("\(locationTransfer.givingPin?.ratingSubmitted ?? false ? "Complete Transfer" : "Awaiting Car Arrival")")
                            .bold()
                            .padding(10)
                            .background(locationTransfer.givingPin?.ratingSubmitted ?? false ? Color("orange1") : Color(white: 0.7))
                            .cornerRadius(50)
                    }.disabled(!(locationTransfer.givingPin?.ratingSubmitted ?? false))
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
                    self.gGRequestConfirm.showGiveConfirmView = false
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
