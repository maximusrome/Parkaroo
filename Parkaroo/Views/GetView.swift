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
    
    @State var presentRatingView = false
    
    var body: some View {
        ZStack {
            MapGetView(annotations1: locationTransfer.locations1)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                GetRequestView()
                    .offset(y: self.gGRequestConfirm.showBox3 ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
            VStack {
                Spacer()
                GetConfirmView(presentRatingView: $presentRatingView)
                    .offset(y: self.gGRequestConfirm.showBox4 ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
            VStack {
                Spacer()
                RateSellerView(presentView: $presentRatingView)
                    .offset(y: self.presentRatingView ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
        }.onAppear() {
            self.locationTransfer.fetchLocations()
//            let db = Firestore.firestore()
//            db.collection("pins").getDocuments() { (querySnapshot, err) in
//                if err != nil {
//                    print("There was an error")
//                } else {
//                    for document in querySnapshot!.documents {
//                        self.locationTransfer.centerCoordinate1.latitude = document["latitude"] as! Double
//                        self.locationTransfer.centerCoordinate1.longitude = document["longitude"] as! Double
//                        print("coordinates read")
//                        let newLocation = MKPointAnnotation()
//                        newLocation.coordinate = self.locationTransfer.centerCoordinate1
//                        self.locationTransfer.locations1.append(newLocation)
//                        print("done")
//                    }
//                }
//            }
        }
    }
}
struct GetView_Previews: PreviewProvider {
    static var previews: some View {
        GetView()
            .environmentObject(LocationTransfer())
            .environmentObject(GGRequestConfirm())
    }
}
