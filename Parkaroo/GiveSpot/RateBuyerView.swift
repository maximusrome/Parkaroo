//
//  RateBuyerView.swift
//  Parkaroo
//
//  Created by max rome on 5/12/21.
//

import SwiftUI
import Firebase

struct RateBuyerView: View {
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @State var rating: Int = 0
    @State var showAlertMessage = false
    var body: some View {
        VStack {
            Text("Rate Buyer")
                .bold()
                .font(.system(size: 34))
                .padding(.top, 25)
            Spacer()
            RatingView(rating: $rating)
            Spacer()
            Button(action: {
                gGRequestConfirm.showBuyerRatingView = false
                updateRating()
                cleanUp()
                Analytics.logEvent("seller_rating_submitted", parameters: nil)
            }) {
                Text("Submit")
                    .bold()
                    .padding(10)
                    .background(rating > 0 ? Color("orange1") : Color(white: 0.7))
                    .cornerRadius(50)
                    .padding(.bottom, 25)
            }.disabled(rating <= 0)
        }.font(.system(size: 17))
            .frame(width: 320, height: 200)
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
                showAlertMessage = true
            case .failure(_):
                print("Error")
            }
        }
    }
    private func cleanUp() {
        locationTransfer.deletePin()
        locationTransfer.givingPinListener?.remove()
        rating = 0
        if !gGRequestConfirm.showGetRequestView && !gGRequestConfirm.showGetConfirmView && !gGRequestConfirm.showGiveRequestView && !gGRequestConfirm.showGetConfirmView {
            locationTransfer.minute = ""
        }
    }
}
struct RateBuyerView_Previews: PreviewProvider {
    static var previews: some View {
        RateBuyerView()
            .environmentObject(LocationTransfer())
            .environmentObject(GGRequestConfirm())
    }
}
