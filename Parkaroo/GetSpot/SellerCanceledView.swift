//
//  SellerCanceledView.swift
//  Parkaroo
//
//  Created by max rome on 5/27/21.
//

import SwiftUI

struct SellerCanceledView: View {
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @EnvironmentObject var locationTransfer: LocationTransfer
    var body: some View {
        VStack {
            Text("Seller Canceled")
                .bold()
                .font(.title)
                .padding(.top, 25)
            Spacer()
            Text("Your credit has been refunded")
            Spacer()
            HStack {
                Button(action: {
                    self.locationTransfer.gettingPin = nil
                    self.locationTransfer.showSellerCanceledView = false
                    self.gGRequestConfirm.showSellerRatingView = false
                }) {
                    Text("close")
                        .padding(10)
                }
                Button(action: {
                    self.locationTransfer.gettingPin = nil
                    self.locationTransfer.showSellerCanceledView = false
                    self.gGRequestConfirm.showSellerRatingView = true
                }) {
                    Text("Rate Seller")
                        .bold()
                        .padding(10)
                        .background(Color("orange1"))
                        .cornerRadius(50)
                }
            }.padding(.bottom, 25)
        }.frame(width: 320, height: 200)
        .background(Color("white1"))
        .foregroundColor(Color("black1"))
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.bottom)
        .padding(.horizontal, 50)
    }
}
struct SellerCanceledView_Previews: PreviewProvider {
    static var previews: some View {
        SellerCanceledView()
            .environmentObject(LocationTransfer())
            .environmentObject(GGRequestConfirm())
    }
}
