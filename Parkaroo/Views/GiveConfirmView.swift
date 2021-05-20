//
//  GiveConfirmView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI

//struct GiveConfirmView: View {
//    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
//    @EnvironmentObject var locationTransfer: LocationTransfer
//    @State var rating = 5
//    var body: some View {
//        VStack {
//            Spacer()
//            VStack(alignment: .center) {
//                Text("Look for a \(self.locationTransfer.vehicle1)")
//                    .bold()
//                    .padding(.top)
//                Spacer()
//                HStack {
//                    Text("Rate Buyer:")
//                        .bold()
//                    RatingView(rating: $rating)
//                }
//                Spacer()
//                Text("Wait to recieve a credit\nYou will recieve an alert")
//                    .multilineTextAlignment(.center)
//                    .padding(.bottom)
//            }.frame(width: 250, height: 150)
//            .background(Color("white1"))
//            .foregroundColor(Color("black1"))
//            .cornerRadius(30)
//            .shadow(radius: 5)
//            .padding(.bottom)
//        }.onAppear() {
//        }.alert(isPresented: $gGRequestConfirm.showingYouGotCreditAlert) {
//            return Alert(title: Text("You got a Credit!"), message: Text("You recieved one credit for giving your spot. Congrats! Check your credits detail page to see your credits."), dismissButton: .default(Text("Okay"), action: {
//                self.gGRequestConfirm.showBox1 = false
//                self.gGRequestConfirm.showBox2 = false
//                self.gGRequestConfirm.moveBox1 = false
//            }))
//        }
//    }
//}
//struct GiveConfirmView_Previews: PreviewProvider {
//    static var previews: some View {
//        GiveConfirmView()
//            .environmentObject(GGRequestConfirm())
//            .environmentObject(LocationTransfer())
//    }
//}


struct RatingView: View {
    @Binding var rating: Int
    var label = ""
    var maximumRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color("orange1")
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            ForEach(1..<maximumRating + 1) { number in
                self.image(for: number)
                    .font(.title)
                    .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                    .onTapGesture {
                        self.rating = number
                    }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}
struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(5))
            .previewLayout(.sizeThatFits)
    }
}
