//
//  GetRequestView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI

struct GetRequestView: View {
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var userInfo: UserInfo
    @State var rating = 5
    @State private var showingCancelReserveAlert = false
    @State private var showingReserveSetupAlert = false
    @State private var showingNotEnoughCreditsAlert = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var depart = Int()
    
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .center) {
                Text("Deparature: \(depart) minutes")
                    .bold()
                    .padding(.top)
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
                        self.showingCancelReserveAlert = true
                    }) {
                        Image(systemName: "trash")
                            .padding(.trailing, 15)
                    }
                    .alert(isPresented: $showingCancelReserveAlert) {
                        Alert(title: Text("Cancel"), message: Text("Are you sure?"), primaryButton: Alert.Button.default(Text("Yes"), action: {
                            self.gGRequestConfirm.showBox3 = false
                        }), secondaryButton: Alert.Button.default(Text("No")))
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
                        Alert(title: Text("Get Set Up"), message: Text("To reserve a spot you must have an account. Go to Sign Up or Login under menu."), dismissButton: .default(Text("Okay")))
                    }
                    .alert(isPresented: $showingNotEnoughCreditsAlert) {
                        Alert(title: Text("Not enough credits"), message: Text("You don't have enough credits. You can purchase credits in the credits menu."), dismissButton: .default(Text("Okay")))
                    }
                }.padding(.bottom)
            }.frame(width: 250, height: 150)
            .background(Color("white1"))
            .foregroundColor(Color("black1"))
            .cornerRadius(30)
            .shadow(radius: 5)
            .padding(.bottom)
            .padding(.bottom, gGRequestConfirm.moveBox ? 170 : 0)
        }
    }
    
    
    private func reserveSpot() {
        if self.userInfo.isUserAuthenticated == .signedIn {
            if self.userInfo.user.credits > 0 {
                let credits = self.userInfo.user.credits
                FBFirestore.mergeFBUser([C_CREDITS:credits - 1], uid: self.userInfo.user.uid) { result in
                    switch result {
                    case .success(_):
                        self.gGRequestConfirm.showBox3 = false
                        self.gGRequestConfirm.showBox4 = true
                        let data = [C_BUYER:userInfo.user.uid, C_STATUS: pinStatus.reserved.rawValue]
                        self.locationTransfer.updateGettingPin(data: data)
                        if let id = self.locationTransfer.gettingPin?.id {
                            self.locationTransfer.fetchGettingPin(id: id)
                        }
                        self.userInfo.user.credits -= 1
                        if let seller = locationTransfer.seller {
                            NotificationsService.shared.sendSpotReservedNotification(uid: seller.uid)
                        }
                    case .failure(_):
                        print("Error requesting spot")
                    }
                }
            }
            else {
                self.showingNotEnoughCreditsAlert = true
            }
            
        } else {
            self.showingReserveSetupAlert = true
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
