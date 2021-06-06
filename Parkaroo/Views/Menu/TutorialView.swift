//
//  TutorialView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI

struct TutorialView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Get Set Up")
                    .bold()
                    .font(.title)
                    .padding(.vertical)
                Text("Step 1: Go to Sign Up under the menu.\n")
                Text("Step 2: Enter information.\n")
                Text("Step 3: Start using Parkaroo!")
                Text("How To Get A Spot")
                    .bold()
                    .font(.title)
                    .padding(.vertical)
                Group {
                    Text("Step 1: Go to the Get Spot tab and click on a pin at your desired parking location.\n")
                    Text("Step 2: If the seller's departure time and rating are to your liking, click Reserve. You will receive the vehicle's brand and color, making it easy for you to find its location.\n")
                    Text("Step 3: Once you are in the spot click Complete Transfer. Finally, rate the seller.")
                    Text("How To Get A Credit")
                        .bold()
                        .font(.title)
                        .padding(.vertical)
                    Text("Step 1: Go to the Give Spot tab and move the pin over your car's location and click it.\n")
                    Text("Step 2: Enter your departure time and click Make Avaliable. Enable notifications to be alerted when someone has reserved your spot.\n")
                    Text("Step 3: After the buyer clicks Complete Transfer, rate the buyer and you will receive a credit.")
                    Spacer()
                }
            }.padding(.horizontal)
            .navigationBarTitle("Tutorial", displayMode: .inline)
        }
    }
}
struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
