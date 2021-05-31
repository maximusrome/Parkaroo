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
    @State private var showRefundCompletedAlert = false
    @Binding var presentRatingView: Bool
    @Binding var gettingPinAnnotation: CustomMKPointAnnotation?
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var depart = Int()
    
    var body: some View {
        
        let refundAlert = Alert(title: Text("Are you sure?"), message: Text("Refunding your spot will give you back one credit, your transactional fee is not refundable. Refunding will also send a notification to the seller asking him/her to rate this interaction."), primaryButton: Alert.Button.default(Text("Yes"), action: {
            requestRefund()
            self.gGRequestConfirm.showBox3 = false
            self.gGRequestConfirm.showBox4 = false

        }), secondaryButton: Alert.Button.default(Text("No")))
        
        let refundCompletedAlert = Alert(title: Text("Refund Processed"), message: nil, dismissButton: Alert.Button.default(Text("Okay"), action: {
            self.showRefundCompletedAlert = false
        }))
        
        VStack {
            Spacer()
            VStack(alignment: .center) {
                Text("Spot Reserved")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                Text("Look for a \(self.locationTransfer.seller?.vehicle ?? "")")
                    .bold()
                    .padding(.top)
                Text("Departing in: \(depart >= 0 ? String(depart) : "0")  Minutes")
                    .padding(.vertical)
                    .onReceive(timer, perform: { input in
                        let diff = Date().distance(to: self.locationTransfer.gettingPin?.departure.dateValue() ?? Date())
                        depart = Int(diff / 60)
                    })
                
                HStack {
                    Text("Rating: \(String(format: "%.2f", self.locationTransfer.seller?.rating ?? 0))")
                        .bold()
                    Image(systemName: "star.fill")
                        .foregroundColor(Color("orange1"))
                    Text("\(self.locationTransfer.seller?.numberOfRatings ?? 0) ratings")
                        .font(.footnote)
                }
                Spacer()
                HStack {
                    Button(action: {
                        self.showingRefundAlert = true
                    }) {
                        Text("Cancel")
                            .font(.system(size: 12))
                    }
                    .alert(isPresented: $showingRefundAlert) {
                        showRefundCompletedAlert ? refundCompletedAlert : refundAlert
                    }
                   
                    
                    Button(action: {
                        self.gGRequestConfirm.showBox3 = false
                        self.gGRequestConfirm.showBox4 = false
                        self.gGRequestConfirm.moveBox = false
                        self.gGRequestConfirm.showingYouGotCreditAlert.toggle()
                        self.presentRatingView = true
                        self.gettingPinAnnotation = nil
                    }) {
                        Text("Complete Transfer")
                            .bold()
                            .padding(10)
                            .background(Color("orange1"))
                            .cornerRadius(50)
                    }
                }.padding(.bottom)
                
            }
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 270)
            .padding(.horizontal)
            .background(Color("white1"))
            .foregroundColor(Color("black1"))
            .cornerRadius(30)
            .shadow(radius: 5)
            .padding(.bottom)
            .padding(.horizontal, 36)
            
        }
        
    }
    
    private func requestRefund() {
        let credits = self.userInfo.user.credits + 1
        FBFirestore.mergeFBUser([C_CREDITS:credits], uid: self.userInfo.user.uid) { result in
            switch result {
            case .success(_):
                self.gettingPinAnnotation = nil
                if let seller = locationTransfer.seller {
                    NotificationsService.shared.sendNotification(uid: seller.uid, message: "The buyer has canceled his reservation.")
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
