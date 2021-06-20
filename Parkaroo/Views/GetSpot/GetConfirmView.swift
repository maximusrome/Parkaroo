//
//  GetConfirmView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI
import Firebase

struct GetConfirmView: View {
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @EnvironmentObject var userInfo: UserInfo
    @State var rating = 5
    @State private var showingRefundAlert = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var depart = Int()
    var body: some View {
            VStack {
                Text("Spot Reserved")
                    .bold()
                    .font(.title)
                    .padding()
                Text("Departing in: \(depart >= 0 ? String(depart) : "0") minutes")
                    .bold()
                    .padding(.bottom, 10)
                    .onReceive(timer, perform: { input in
                        let diff = Date().distance(to: self.locationTransfer.gettingPin?.departure.dateValue() ?? Date())
                        depart = Int(diff / 60)
                    })
                VStack {
                    Text("Seller: \(self.locationTransfer.seller?.vehicle ?? "")")
                        .padding(.bottom, 10)
                    HStack {
                        Text("Rating: \(String(format: "%.2f", self.locationTransfer.seller?.rating ?? 0))")
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("orange1"))
                        Text("\(self.locationTransfer.seller?.numberOfRatings ?? 0) ratings")
                            .font(.footnote)
                    }
                }.padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(Color.gray, lineWidth: 2)
                )
                Spacer()
                HStack {
                    Button(action: {
                        self.showingRefundAlert = true
                    }) {
                        Text("cancel")
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                    }.alert(isPresented: $showingRefundAlert) {
                        Alert(title: Text("Are you sure?"), message: Text("By canceling this spot your credit will be refunded but in order to refund your $0.99 service fee you must contact Apple."), primaryButton: Alert.Button.default(Text("No")), secondaryButton: Alert.Button.default(Text("Yes"), action: {
                            requestRefund()
                            self.gGRequestConfirm.showGetRequestView = false
                            self.gGRequestConfirm.showGetConfirmView = false
                        }))
                    }
                    Button(action: {
                        self.gGRequestConfirm.showGetRequestView = false
                        self.gGRequestConfirm.showGetConfirmView = false
                        self.gGRequestConfirm.showSellerRatingView = true
                        self.locationTransfer.gettingAnnotation = nil
                    }) {
                        Text("Complete Transfer")
                            .bold()
                            .padding(10)
                            .background(Color("orange1"))
                            .cornerRadius(50)
                    }
                }.padding(.top)
                .padding(.horizontal)
                HStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    Text("when parked in spot")
                        .font(.footnote)
                    Spacer()
                }.padding(.bottom, 25)
            }.frame(width: 300, height: 300)
            .background(Color("white1"))
            .foregroundColor(Color("black1"))
            .cornerRadius(30)
            .shadow(radius: 5)
            .padding(.bottom)
            .padding(.horizontal, 50)
    }
    private func requestRefund() {
        let credits = self.userInfo.user.credits + 1
        FBFirestore.mergeFBUser([C_CREDITS:credits], uid: self.userInfo.user.uid) { result in
            switch result {
            case .success(_):
                self.locationTransfer.gettingAnnotation = nil
                if let seller = locationTransfer.seller {
                    NotificationsService.shared.sendNotification(uid: seller.uid, message: "The buyer has canceled their reservation.")
                }
                let data = [C_BUYER:"", C_STATUS: pinStatus.available.rawValue]
                self.locationTransfer.updateGettingPin(data: data)
                self.locationTransfer.cleanUpGettingPin()
                self.userInfo.user.credits = credits
            case .failure(_):
                print("Error Refunding")
            }
        }
    }
}
struct GetConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        GetConfirmView()
            .environmentObject(LocationTransfer())
            .environmentObject(GGRequestConfirm())
            .environmentObject(UserInfo())
            .previewLayout(.sizeThatFits)
    }
}
//                Text("")
//                    .alert(isPresented: $showingTwoReservedAlert) {
//                        Alert(title: Text("Error"), message: Text("Another person reserved this spot a little bit before you. Your credit was refunded."), dismissButton: .default(Text("Okay")))
//                    }
//            }.onAppear() {
//                if self.locationTransfer.buyer?.uid != nil && Auth.auth().currentUser?.uid != self.locationTransfer.buyer?.uid {
//                    self.showingTwoReservedAlert = true
//                }
