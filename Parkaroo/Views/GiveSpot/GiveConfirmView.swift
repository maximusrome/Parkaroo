//
//  GiveConfirmView.swift
//  Parkaroo
//
//  Created by max rome on 5/8/21.
//

import SwiftUI

struct GiveConfirmView: View {
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @EnvironmentObject var locationTransfer: LocationTransfer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var departureMinutes = Int()
    @State var showingSellerCancelAlert = false
    var body: some View {
        VStack {
            Text("Spot \(self.locationTransfer.givingPin?.status.capitalized ?? "")")
                .bold()
                .font(.title)
                .padding(.top, 25)
            Spacer()
            Text("Departing in: \(departureMinutes >= 0 ? String(departureMinutes) : "0") minutes")
                .bold()
                .onReceive(timer, perform: { input in
                    let diff = Date().distance(to: self.locationTransfer.givingPin?.departure.dateValue() ?? Date())
                    departureMinutes = Int(diff / 60)
                    if locationTransfer.buyer == nil && departureMinutes < 0 {
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
                    Text("Buyer: \(buyer.vehicle)")
                        .padding(.bottom)
                    HStack {
                        Text("Rating: \(self.locationTransfer.buyer?.numberOfRatings ?? 0 > 0 ? (String(format: "%.2f", self.locationTransfer.buyer?.rating ?? 0)) : "N/A")")
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("orange1"))
                        Text("\(self.locationTransfer.buyer?.numberOfRatings ?? 0) ratings")
                            .font(.footnote)
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
                            Alert(title: Text("Are you sure?"), message: Text("Friendly reminder: If someone has reserved your spot they will be asked to rate you."), primaryButton: .cancel(Text("No")), secondaryButton: .default(Text("Yes"), action: {
                                locationTransfer.deletePin()
                                locationTransfer.minute = ""
                                self.gGRequestConfirm.showGiveConfirmView = false
                                if let buyer = locationTransfer.buyer {
                                    NotificationsService.shared.sendNotification(uid: buyer.uid, message: "The seller has canceled their spot")
                                }
                            }))
                        })
                    }
                    Button(action: {
                        self.gGRequestConfirm.showGiveConfirmView = false
                        self.gGRequestConfirm.showBuyerRatingView = true
                        self.locationTransfer.givingPin = nil
                        self.locationTransfer.locations.removeAll()
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
                    self.showingSellerCancelAlert = true
                }) {
                    Text("cancel")
                        .padding(10)
                        .background(Color(white: 0.7))
                        .cornerRadius(50)
                        .padding(.bottom, 25)
                }.alert(isPresented: $showingSellerCancelAlert, content: {
                    Alert(title: Text("Are you sure?"), message: Text("Friendly reminder: If someone has reserved your spot they will be asked to rate you."), primaryButton: .cancel(Text("No")), secondaryButton: .default(Text("Yes"), action: {
                        locationTransfer.deletePin()
                        locationTransfer.minute = ""
                        self.gGRequestConfirm.showGiveConfirmView = false
                        if let buyer = locationTransfer.buyer {
                            NotificationsService.shared.sendNotification(uid: buyer.uid, message: "The seller has canceled their spot")
                        }
                    }))
                })
            }
        }.frame(width: 300, height: 380)
        .background(Color("white1"))
        .foregroundColor(Color("black1"))
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.bottom)
        .padding(.horizontal, 50)
    }
}
struct GiveConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        GiveConfirmView()
            .previewLayout(.sizeThatFits)
            .environmentObject(GGRequestConfirm())
            .environmentObject(LocationTransfer())
    }
}
