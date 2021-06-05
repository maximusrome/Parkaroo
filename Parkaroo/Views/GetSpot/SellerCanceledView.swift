//
//  SellerCanceledView.swift
//  Parkaroo
//
//  Created by Bernie Cartin on 5/27/21.
//

import SwiftUI

struct SellerCanceledView: View {
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @EnvironmentObject var locationTransfer: LocationTransfer
    @Binding var presentRatingView: Bool
    var body: some View {
        VStack {
            Text("Seller Canceled")
                .bold()
                .font(.title)
                .padding()
            Spacer()
            Text("Your credit has been refunded")
            Spacer()
            HStack {
                Button(action: {
                    self.locationTransfer.gettingPin = nil
                    self.locationTransfer.sellerCanceled = false
                }) {
                    Text("Close")
                        .padding()
                        .cornerRadius(50)
                }
                Button(action: {
                    self.locationTransfer.gettingPin = nil
                    self.locationTransfer.sellerCanceled = false
                    self.presentRatingView = true
                }) {
                    Text("Rate Seller")
                        .bold()
                        .padding(10)
                        .background(Color("orange1"))
                        .cornerRadius(50)
                }
            }.padding()
            .padding(.bottom, 10)
        }.frame(width: 300, height: 200, alignment: .center)
        .padding(.horizontal)
        .background(Color("white1"))
        .foregroundColor(Color("black1"))
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.bottom)
        .padding(.horizontal, 50)
    }
}
struct SellerCanceledView_Previews: PreviewProvider {
    @State static var presentView: Bool = false
    static var previews: some View {
        SellerCanceledView(presentRatingView: $presentView)
            .environmentObject(LocationTransfer())
            .environmentObject(GGRequestConfirm())
            .previewLayout(.sizeThatFits)
    }
}
