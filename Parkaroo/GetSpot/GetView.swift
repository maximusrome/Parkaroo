//
//  GetView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//
import SwiftUI
import MapKit
import Firebase

struct GetView: View {
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @EnvironmentObject var userInfo: UserInfo
    var body: some View {
        ZStack {
            MapGetView(annotations1: locationTransfer.locations1)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                GetRequestView()
                    .offset(y: self.gGRequestConfirm.showGetRequestView ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
            VStack {
                Spacer()
                GetConfirmView()
                    .offset(y: self.gGRequestConfirm.showGetConfirmView ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
            VStack {
                Spacer()
                RateSellerView()
                    .offset(y: self.gGRequestConfirm.showSellerRatingView && !self.locationTransfer.showSellerCanceledView ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
            VStack {
                Spacer()
                SellerCanceledView()
                    .offset(y: self.locationTransfer.showSellerCanceledView ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
        }.onAppear() {
            self.locationTransfer.fetchLocations()
        }
        .onReceive(locationTransfer.updatePublisher, perform: { _ in
            if locationTransfer.showSellerCanceledView {
                self.gGRequestConfirm.showGetRequestView = false
                self.gGRequestConfirm.showGetConfirmView = false
                self.locationTransfer.gettingAnnotation = nil
                self.userInfo.AddOneCredit()
            }
        })
    }
}
struct GetView_Previews: PreviewProvider {
    static var previews: some View {
        GetView()
            .environmentObject(LocationTransfer())
            .environmentObject(GGRequestConfirm())
            .environmentObject(UserInfo())
    }
}
