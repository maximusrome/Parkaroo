//
//  RateSellerView.swift
//  Parkaroo
//
//  Created by max rome on 5/10/21.
//

import SwiftUI

struct RateSellerView: View {
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @State var rating: Int = 0
    @State var showAlertMessage = false
    var body: some View {
        VStack {
            Text("Rate Seller")
                .bold()
                .font(.title)
                .padding()
            Spacer()
            RatingView(rating: $rating)
            Spacer()
            Button(action: {
                self.gGRequestConfirm.showSellerRatingView = false
                updateRating()
                locationTransfer.updateGettingPin(data: [C_RATINGSUBMITTED:true])
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
            Alert(title: Text("Rating Submitted"), message: Text("Thanks for using Parkaroo."), dismissButton: .default(Text("Done"), action: {
                self.showAlertMessage = false
                AppReviewRequest.requestreviewIfNeeded()
            }))
        })
    }
    private func updateRating() {
        guard let overallRating = locationTransfer.seller?.rating else {return}
        guard let totalRatings = locationTransfer.seller?.numberOfRatings else {return}
        let newTotalRatings = totalRatings + 1
        let newRating = Float(rating)
        let updatedRating: Float = ((overallRating * Float(totalRatings)) + newRating) / Float(newTotalRatings)
        let data = [C_RATING:updatedRating, C_NUMBEROFRATINGS:newTotalRatings] as [String : Any]
        guard let uid = locationTransfer.seller?.uid else {return}
        FBFirestore.mergeFBUser(data, uid: uid) { result in
            switch result {
            case .success(_):
                self.showAlertMessage = true
            case .failure(_):
                print("Error")
            }
        }
    }
    private func cleanUp() {
        self.locationTransfer.cleanUpGettingPin()
        self.rating = 0
    }
}
struct RateSellerView_Previews: PreviewProvider {
    static var previews: some View {
        RateSellerView()
            .environmentObject(LocationTransfer())
            .environmentObject(GGRequestConfirm())
    }
}
