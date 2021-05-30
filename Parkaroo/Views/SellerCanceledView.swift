//
//  SellerCanceledView.swift
//  Parkaroo
//
//  Created by Bernie Cartin on 5/27/21.
//

import SwiftUI

struct SellerCanceledView: View {
    // MARK: PROPERTIES
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @EnvironmentObject var locationTransfer: LocationTransfer
    @Binding var presentRatingView: Bool
    
    // MARK: BODY
    var body: some View {
        VStack {
            Text("Seller Canceled")
                .font(.title)
                .fontWeight(.bold)
            Text("Your credit has been refunded")
                .padding(.top, 4)
            
            Button(action: {
                self.locationTransfer.gettingPin = nil
                self.locationTransfer.sellerCanceled = false
                self.presentRatingView = true
            }, label: {
                Text("Rate Seller")
                    .bold()
                    .padding(10)
                    .background(Color("orange1"))
                    .cornerRadius(50)
            })
            .padding()
            
            Button(action: {
                self.locationTransfer.gettingPin = nil
                self.locationTransfer.sellerCanceled = false
            }, label: {
                Text("Close")
                    .bold()
                    .padding(10)
                    .cornerRadius(50)
            })
        }
        .frame(width: 300, height: 270, alignment: .center)
        .padding(.horizontal)
        .background(Color("white1"))
        .foregroundColor(Color("black1"))
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.bottom)
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
