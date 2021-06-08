//
//  RateBuyerView.swift
//  Parkaroo
//
//  Created by max rome on 5/12/21.
//

import SwiftUI

struct RateBuyerView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @State var rating: Int = 0
    @State var showAlertMessage = false
    var body: some View {
        VStack {
            Text("Rate Buyer")
                .bold()
                .font(.title)
                .padding()
            RatingView(rating: $rating)
            Button(action: {
                self.gGRequestConfirm.showBuyerRatingView = false
                updateRating()
                addCredit()
                cleanUp()
            }) {
                Text("Submit")
                    .bold()
                    .padding(10)
                    .background(rating > 0 ? Color("orange1") : Color(white: 0.7))
                    .cornerRadius(50)
                    .padding()
                    .padding(.bottom, 10)
            }.disabled(rating <= 0)
        }.frame(width: 300, height: 200, alignment: .center)
        .background(Color("white1"))
        .foregroundColor(Color("black1"))
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.bottom)
        .padding(.horizontal, 50)
        .alert(isPresented: $showAlertMessage, content: {
            Alert(title: Text("Rating Submitted"), message: Text("You have earned a credit. Thanks for using Parkaroo."), dismissButton: .default(Text("Done")))
        })
    }
    private func updateRating() {
        guard let overallRating = locationTransfer.buyer?.rating else {return}
        guard let totalRatings = locationTransfer.buyer?.numberOfRatings else {return}
        let newTotalRatings = totalRatings + 1
        let newRating = Float(rating)
        let updatedRating: Float = ((overallRating * Float(totalRatings)) + newRating) / Float(newTotalRatings)
        let data = [C_RATING:updatedRating, C_NUMBEROFRATINGS:newTotalRatings] as [String : Any]
        guard let uid = locationTransfer.buyer?.uid else {return}
        FBFirestore.mergeFBUser(data, uid: uid) { result in
            switch result {
            case .success(_):
                self.showAlertMessage = true
            case .failure(_):
                print("Error")
            }
        }
    }
    private func addCredit() {
        let updateCredits = userInfo.user.credits + 1
        FBFirestore.mergeFBUser([C_CREDITS:updateCredits], uid: userInfo.user.uid) { result in
            switch result {
            case .success(_):
                print("Credit Added")
                userInfo.user.credits += 1
            case .failure(_):
                print("Error")
            }
        }
    }
    private func cleanUp() {
        locationTransfer.deletePin()
        locationTransfer.buyer = nil
        locationTransfer.seller = nil
        locationTransfer.givingPin = nil
        locationTransfer.gettingPin = nil
        locationTransfer.minute = ""
        locationTransfer.givingPinListener?.remove()
        self.rating = 0
    }
}
struct RateBuyerView_Previews: PreviewProvider {
    static var previews: some View {
        RateBuyerView()
            .environmentObject(LocationTransfer())
            .environmentObject(UserInfo())
            .environmentObject(GGRequestConfirm())
    }
}
