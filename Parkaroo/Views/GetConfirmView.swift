//
//  GetConfirmView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI

struct GetConfirmView: View {
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @State var rating = 5
    @State private var showingRefundAlert = false
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .center) {
                Text("Look for a \(self.locationTransfer.vehicle)")
                    .bold()
                    .padding(.top)
                Spacer()
                HStack {
                    Text("Rate Seller:")
                        .bold()
                    RatingView(rating: $rating)
                }
                Spacer()
                HStack {
                    Button(action: {
                        self.showingRefundAlert.toggle()
                    }) {
                        Text("Refund")
                            .font(.system(size: 12))
                    }
                    .alert(isPresented: $showingRefundAlert) {
                        Alert(title: Text("Are you sure?"), message: Text("Runding your spot will give you one credit and your transactional fee. Refunding will also send a notification to the seller asking him/her to rate this interaction."), primaryButton: Alert.Button.default(Text("Yes"), action: {
                        }), secondaryButton: Alert.Button.default(Text("No")))
                    }
                    Button(action: {
                        self.gGRequestConfirm.showBox3 = false
                        self.gGRequestConfirm.showBox4 = false
                        self.gGRequestConfirm.moveBox = false
                        self.gGRequestConfirm.showingYouGotCreditAlert.toggle()
                        self.locationTransfer.locations.removeLast()
                        self.locationTransfer.locations1.removeLast()
                        self.locationTransfer.deletePin()
                    }) {
                        Text("Complete Transfer")
                            .bold()
                            .padding(10)
                            .background(Color("orange1"))
                            .cornerRadius(50)
                    }
                }.padding(.bottom)
            }.frame(width: 250, height: 150)
            .background(Color("white1"))
            .foregroundColor(Color("black1"))
            .cornerRadius(30)
            .shadow(radius: 5)
            .padding(.bottom)
        }
    }
}
struct GetConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        GetConfirmView()
            .environmentObject(LocationTransfer())
            .environmentObject(GGRequestConfirm())
    }
}
