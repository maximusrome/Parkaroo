//
//  TutorialView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI
import AVKit

struct TutorialView: View {
    @State var showingVideoSheetTutorial = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Button(action: {
                    self.showingVideoSheetTutorial.toggle()
                    self.vid()
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "play.fill")
                        Text("Watch Video Tutorial")
                        Spacer()
                    }.padding(10)
                    .background(Color("orange1"))
                    .foregroundColor(Color("black1"))
                    .cornerRadius(50)
                    .padding(.top, 40)
                    .fullScreenCover(isPresented: $showingVideoSheetTutorial) {
                        VideoTutorialView()
                    }
                }
                Group {
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
                    Text("Step 1: Go to the Get Spot tab and click on a pin at your desired parking location.\n")
                    Text("Step 2: If the departure time, street information, and seller rating are to your liking, click Reserve.\n")
                    Text("Step 3: To reserve a spot you will need one credit. In return, you will be the only one to receive the vehicle's color and brand. The vehicle location will now only be visible to you.\n")
                    Text("Step 4: Once you are in the spot, click Complete Transfer. Finally, rate the seller.")
                }
                Group {
                    Text("How To Get A Credit")
                        .bold()
                        .font(.title)
                        .padding(.vertical)
                    Text("Option 1: The best way to get a credit is to give up a spot.\n")
                    Text("Option 2: Go to the Credits page under the menu and purchase a credit.")
                    Text("How To Give A Spot")
                        .bold()
                        .font(.title)
                        .padding(.vertical)
                    Text("Step 1: Go to the Give Spot tab and move the pin over your car's location and click Give Spot.\n")
                    Text("Step 2: Once you enter your departure time and street information, click Make Available.\n")
                    Text("Step 3: After the buyer clicks Complete Transfer, rate the buyer and you will receive a credit.")
                    Spacer()
                }
            }.padding(.horizontal)
            .navigationBarTitle("Tutorial", displayMode: .inline)
        }
    }
    private func vid() {
        try! AVAudioSession.sharedInstance().setCategory(.playback)
    }
}
struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
