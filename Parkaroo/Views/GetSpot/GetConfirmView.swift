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
    @EnvironmentObject var userInfo: UserInfo
    @State var rating = 5
    @State private var showingRefundAlert = false
    @Binding var presentRatingView: Bool
    @Binding var gettingPinAnnotation: CustomMKPointAnnotation?
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var depart = Int()
    var body: some View {
        VStack {
            Spacer()
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
                        Alert(title: Text("Are you sure?"), message: Text("By cancelling this spot your credit will be refunded but in order to refund your $0.99 service fee you must contact apple."), primaryButton: Alert.Button.default(Text("No")), secondaryButton: Alert.Button.default(Text("Yes"), action: {
                            requestRefund()
                            self.gGRequestConfirm.showBox3 = false
                            self.gGRequestConfirm.showBox4 = false
                        }))
                    }
                    Button(action: {
                        self.gGRequestConfirm.showBox3 = false
                        self.gGRequestConfirm.showBox4 = false
                        self.gGRequestConfirm.moveBox = false
                        self.gGRequestConfirm.showingYouGotCreditAlert.toggle()
                        self.gGRequestConfirm.showSellerRatingView = true
                        self.gettingPinAnnotation = nil
                    }) {
                        Text("Complete Transfer")
                            .bold()
                            .padding(10)
                            .background(Color("orange1"))
                            .cornerRadius(50)
                    }
                }.padding()
                .padding(.bottom, 10)
            }.frame(width: 300, height: 300)
            .background(Color("white1"))
            .foregroundColor(Color("black1"))
            .cornerRadius(30)
            .shadow(radius: 5)
            .padding(.bottom)
            .padding(.horizontal, 50)
        }
    }
    private func requestRefund() {
        let credits = self.userInfo.user.credits + 1
        FBFirestore.mergeFBUser([C_CREDITS:credits], uid: self.userInfo.user.uid) { result in
            switch result {
            case .success(_):
                self.gettingPinAnnotation = nil
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
    @State static var presentView: Bool = false
    @State static var annotation: CustomMKPointAnnotation? = CustomMKPointAnnotation()
    static var previews: some View {
        GetConfirmView(presentRatingView: $presentView, gettingPinAnnotation: $annotation)
            .environmentObject(LocationTransfer())
            .environmentObject(GGRequestConfirm())
            .environmentObject(UserInfo())
            .previewLayout(.sizeThatFits)
    }
}
