//
//  GiveView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//
import SwiftUI
import MapKit
import Firebase

struct GiveView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @State private var showingMakeAvaliableSetUpAlert = false
    var body: some View {
        ZStack {
            MapGiveView(annotations: locationTransfer.locations)
                .edgesIgnoringSafeArea(.horizontal)
                .disabled(gGRequestConfirm.showGiveRequestView)
            if locationTransfer.givingPin == nil && !gGRequestConfirm.showBuyerRatingView && !gGRequestConfirm.showGiveRequestView {
                Image(systemName: "mappin.and.ellipse")
                    .font(.title)
                    .frame(width: 32.0, height: 32.0)
                    .foregroundColor(Color("orange1"))
                    .padding()
                    .padding(.bottom)
                VStack {
                    Spacer()
                    Button(action: {
                        if locationTransfer.locations.count > 0 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                locationTransfer.locations.removeFirst()
                            }
                        }
                        locationTransfer.parkPress = false
                        gGRequestConfirm.showGiveRequestView = false
                        locationTransfer.minute = ""
                        locationTransfer.giveStreetInfoSelection = "Edit"
                        Analytics.logEvent("give_spot", parameters: nil)
                        if userInfo.isUserAuthenticated == .signedIn {
                            gGRequestConfirm.showGiveRequestView = true
                            locationTransfer.addRefencePin()
                        } else {
                            showingMakeAvaliableSetUpAlert = true
                        }
                    }) {
                        Text("Give Spot")
                            .bold()
                            .font(.title)
                            .frame(width: 300, height: 50)
                            .background(Color("white1"))
                            .foregroundColor(Color("orange1"))
                            .cornerRadius(30)
                            .shadow(radius: 5)
                            .padding(.bottom)
                            .padding(.horizontal, 50)
                    }
                }.disabled(userInfo.isUserAuthenticated == .signedIn && gGRequestConfirm.showGiveRequestView)
                    .alert(isPresented: $showingMakeAvaliableSetUpAlert) {
                        Alert(title: Text("Get Set Up"), message: Text("To give a spot you must have an account. Go to Sign Up or Login under the menu."), dismissButton: .default(Text("Okay")))
                    }
            }
            VStack {
                Spacer()
                GiveRequestView()
                    .offset(y: gGRequestConfirm.showGiveRequestView ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
            VStack {
                Spacer()
                GiveConfirmView()
                    .offset(y: gGRequestConfirm.showGiveConfirmView ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
            VStack {
                Spacer()
                RateBuyerView()
                    .offset(y: gGRequestConfirm.showBuyerRatingView ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
        }.onAppear() {
            if userInfo.isUserAuthenticated == .signedIn && locationTransfer.givingPin == nil && !gGRequestConfirm.showBuyerRatingView && !gGRequestConfirm.showGiveRequestView && locationTransfer.firstTime == true {
                locationTransfer.parkPress = true
                locationTransfer.readSaveLocation()
                locationTransfer.firstTime = false
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            FBFirestore.retrieveFBUser(uid: uid) { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let user):
                    userInfo.user = user
                }
            }
        }
    }
}
struct GiveView_Previews: PreviewProvider {
    static var previews: some View {
        GiveView()
            .environmentObject(UserInfo())
            .environmentObject(LocationTransfer())
            .environmentObject(GGRequestConfirm())
    }
}
