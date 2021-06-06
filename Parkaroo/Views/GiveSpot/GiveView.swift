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
    @State private var showingMakeAvaliableSetupAlert = false
    @State var presentRatingView = false
    var body: some View {
        ZStack {
            MapGiveView(annotations: locationTransfer.locations)
                .edgesIgnoringSafeArea(.all)
            if locationTransfer.givingPin == nil {
                Button(action: {
                    self.gGRequestConfirm.showBox1 = false
                    if self.userInfo.isUserAuthenticated == .signedIn {
                        self.gGRequestConfirm.showBox1 = true
                    } else {
                        self.showingMakeAvaliableSetupAlert.toggle()
                    }
                }) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.title)
                        .frame(width: 32.0, height: 32.0)
                        .foregroundColor(Color("orange1"))
                        .padding()
                }.disabled(userInfo.isUserAuthenticated == .signedIn && gGRequestConfirm.showBox1)
                .alert(isPresented: $showingMakeAvaliableSetupAlert) {
                    Alert(title: Text("Get Set Up"), message: Text("To give a spot you must have an account. Go to Sign Up or Login under menu."), dismissButton: .default(Text("Okay")))
                }
            }
            VStack {
                Spacer()
                GiveRequestView()
                    .offset(y: self.gGRequestConfirm.showBox1 ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
            VStack {
                Spacer()
                GiveConfirmView(presentRatingView: $presentRatingView)
                    .offset(y: self.gGRequestConfirm.showGiveConfirmView ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
            VStack {
                Spacer()
                RateBuyerView(presentView: $presentRatingView)
                    .offset(y: self.presentRatingView ? 0 : UIScreen.main.bounds.height)
                    .animation(.default)
            }
        }.onAppear() {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            FBFirestore.retrieveFBUser(uid: uid) { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let user):
                    self.userInfo.user = user
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
