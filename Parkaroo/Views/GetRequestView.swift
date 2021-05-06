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
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .center) {
                Text("Deparature: \(self.locationTransfer.minute1) minutes")
                    .bold()
                    .padding(.top)
                Spacer()
                HStack {
                    Text("Seller:")
                        .bold()
                    RatingView(rating: $rating)
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
                        Alert(title: Text("Cancel your Reservation?"), message: Text("You will recieve your one credit back but will not get the transactional fee."), primaryButton: Alert.Button.default(Text("Yes"), action: {
                            self.gGRequestConfirm.moveBox = false
                            self.gGRequestConfirm.moveBox1 = false
                            self.gGRequestConfirm.showBox2 = false
                            self.gGRequestConfirm.showBox3 = false
                            self.gGRequestConfirm.showBox4 = false
                        }), secondaryButton: Alert.Button.default(Text("No")))
                    }
                    Button(action: {
                        if self.userInfo.isUserAuthenticated == .signedIn {
                            self.gGRequestConfirm.moveBox = true
                            self.gGRequestConfirm.showBox4 = true
                            self.gGRequestConfirm.moveBox1 = true
                            self.gGRequestConfirm.showBox2 = true
                            self.locationTransfer.readVehicle()
                        } else {
                            self.showingReserveSetupAlert = true
                        }
                    }) {
                        Text("Reserve Spot")
                            .bold()
                            .padding(10)
                            .background(Color("orange1"))
                            .cornerRadius(50)
                    }.alert(isPresented: $showingReserveSetupAlert) {
                        Alert(title: Text("Get Set Up"), message: Text("To reserve a spot you must have an account. Go to Sign Up or Login under menu."), dismissButton: .default(Text("Okay")))
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
}
struct GetRequestView_Previews: PreviewProvider {
    static var previews: some View {
        GetRequestView()
            .environmentObject(GGRequestConfirm())
            .environmentObject(LocationTransfer())
            .environmentObject(UserInfo())
    }
}
