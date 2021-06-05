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
    @EnvironmentObject var iapManager: IAPManager
    @State var presentRatingView = false
    @State var gettingAnnotation: CustomMKPointAnnotation?
    var body: some View {
        ZStack {
            MapGetView(gettingPinAnnotation: $gettingAnnotation, annotations1: locationTransfer.locations1)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                GetRequestView(gettingPinAnnotation: $gettingAnnotation)
                    .offset(y: self.gGRequestConfirm.showBox3 ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
            VStack {
                Spacer()
                GetConfirmView(presentRatingView: $presentRatingView, gettingPinAnnotation: $gettingAnnotation)
                    .offset(y: self.gGRequestConfirm.showBox4 ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
            VStack {
                Spacer()
                RateSellerView(presentView: $presentRatingView)
                    .offset(y: self.presentRatingView ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
            VStack {
                Spacer()
                SellerCanceledView(presentRatingView: $presentRatingView)
                    .offset(y: self.locationTransfer.sellerCanceled ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
            if iapManager.showActivityIndicator {
                ActivityIndicatorView()
            }
        }.onAppear() {
            self.locationTransfer.fetchLocations()
        }
        .onReceive(locationTransfer.updatePublisher, perform: { _ in
            if locationTransfer.sellerCanceled {
                self.gGRequestConfirm.showBox3 = false
                self.gGRequestConfirm.showBox4 = false
                self.gGRequestConfirm.moveBox = false
                self.gettingAnnotation = nil
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
            .environmentObject(IAPManager())
    }
}
