//
//  RateBuyerView.swift
//  Parkaroo
//
//  Created by Bernie Cartin on 5/12/21.
//

import SwiftUI

struct RateBuyerView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var locationTransfer: LocationTransfer
    @Binding var presentView: Bool
    @State var rating: Int = 0
    @State var showAlertMessage = false
    
    var body: some View {
        VStack {
            Text("Rate Buyer")
                .font(.title3)
                .bold()
                .padding()
            
            RatingView(rating: $rating)
            
            
            Button(action: {
                presentView = false
                updateRating()
                addCredit()
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
            Alert(title: Text("Rating Submitted"), message: Text("You've earned a free credit. Thanks for using Parkaroo."), dismissButton: .default(Text("Done")))
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
    @State static var presentView: Bool = false
    static var previews: some View {
        RateBuyerView(presentView: $presentView)
            .environmentObject(LocationTransfer())
            .environmentObject(UserInfo())
    }
}
