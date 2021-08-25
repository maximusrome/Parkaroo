//
//  RateSellerView.swift
//  Parkaroo
//
//  Created by max rome on 5/10/21.
//

import SwiftUI
import Firebase

struct RateSellerView: View {
    @ObservedObject var viewModel = ChatroomsViewModel()
    init() {
        viewModel.fetchData()
    }
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @State var rating: Int = 0
    @State var showAlertMessage = false
    var body: some View {
        VStack {
            Text("Rate Seller")
                .bold()
                .font(.title)
                .padding(.top, 25)
            Spacer()
            RatingView(rating: $rating)
            Spacer()
            Button(action: {
                viewModel.deleteChatroom()
                gGRequestConfirm.showSellerRatingView = false
                updateRating()
                locationTransfer.updateGettingPin(data: [C_RATINGSUBMITTED:true])
                cleanUp()
                Analytics.logEvent("buyer_rating_submited", parameters: nil)
                if let seller = locationTransfer.seller {
                    NotificationsService.shared.sendN(uid: seller.uid, message: "The buyer completed the transfer. Rate the buyer to earn your credit.")
                }
            }) {
                Text("Submit")
                    .bold()
                    .padding(10)
                    .background(rating > 0 ? Color("orange1") : Color(white: 0.7))
                    .cornerRadius(50)
                    .padding(.bottom, 25)
            }.disabled(rating <= 0)
        }.frame(width: 320, height: 200)
        .background(Color("white1"))
        .foregroundColor(Color("black1"))
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.bottom)
        .padding(.horizontal, 50)
        .alert(isPresented: $showAlertMessage, content: {
            Alert(title: Text("Rating Submitted"), message: Text("Thanks for using Parkaroo."), dismissButton: .default(Text("Done"), action: {
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
                showAlertMessage = true
            case .failure(_):
                print("Error")
            }
        }
    }
    private func cleanUp() {
        locationTransfer.cleanUpGettingPin()
        rating = 0
        if !gGRequestConfirm.showGetRequestView && !gGRequestConfirm.showGetConfirmView && !gGRequestConfirm.showGiveRequestView && !gGRequestConfirm.showGetConfirmView {
            locationTransfer.minute = ""
        }
    }
}
struct RateSellerView_Previews: PreviewProvider {
    static var previews: some View {
        RateSellerView()
            .environmentObject(LocationTransfer())
            .environmentObject(GGRequestConfirm())
    }
}
