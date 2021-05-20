//
//  RateSellerView.swift
//  Parkaroo
//
//  Created by Bernie Cartin on 5/10/21.
//

import SwiftUI

struct RateSellerView: View {
    
    @EnvironmentObject var locationTransfer: LocationTransfer
    @Binding var presentView: Bool
    @State var rating: Int = 0
    @State var showAlertMessage = false
    
    var body: some View {
        VStack {
            Text("Rate Seller")
                .font(.title3)
                .bold()
                .padding()
            
            RatingView(rating: $rating)
            
            
            Button(action: {
                presentView = false
                updateRating()
                locationTransfer.updateGettingPin(data: [C_RATINGSUBMITTED:true])
                cleanUp()
            }) {
                Text("Submit")
                    .foregroundColor(.black)
                    .bold()
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(Color("orange1"))
                    .cornerRadius(50)
                    .padding(.top)
            }
            .padding(.bottom)
            
        }
        .frame(width: 300, height: 200)
        .padding(.horizontal)
        .background(Color("white1"))
        .foregroundColor(Color("black1"))
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.bottom)
        .alert(isPresented: $showAlertMessage, content: {
            Alert(title: Text("Rating Submitted"), message: Text("Thanks for using Parkaroo."), dismissButton: .default(Text("Done")))
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
        locationTransfer.buyer = nil
        locationTransfer.seller = nil
        locationTransfer.givingPin = nil
        locationTransfer.gettingPin = nil
        locationTransfer.minute = ""
        self.rating = 0
    }
}

struct RateSellerView_Previews: PreviewProvider {
    @State static var presentView: Bool = false
    static var previews: some View {
        RateSellerView(presentView: $presentView)
            .environmentObject(LocationTransfer())
    }
}
