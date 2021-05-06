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
                Text("Step 1: Click Sign Up under the Menu.\n")
                Text("Step 2: Enter information and click Sign Up.\n")
                Text("Step 3: Start using Parkaroo!")
                Text("How To Get A Spot")
                    .bold()
                    .font(.title)
                    .padding(.vertical)
                Group {
                    Text("Step 1: Go to the Get Spot tab and click on a pin on the map at the desired location of your parking spot.\n")
                    Text("Step 2: Click Reserve Spot. You will recieve the vehicle's brand and color, making it easy for you to find it's location.\n")
                    Text("Step 3: Once you are in the spot click Complete Transfer. Finally, rate the seller.")
                    Text("How To Give A Spot")
                        .bold()
                        .font(.title)
                        .padding(.vertical)
                    Text("Step 1: Go to the Give Spot tab and move the pin over your car's location and click on it.\n")
                    Text("Step 2: Enter departure time and click Make Avaliable. You will be alerted when someone has reserved your spot.\n")
                    Text("Step 3: You will recieve a credit when the buyer clicks Complete Transfer once in the spot. Finally, rate the buyer.")
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
