//
//  Board3View.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI
import AVKit

struct Board3View: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Rectangle()
                    .foregroundColor(Color("white1"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
            }
            VStack {
                Spacer()
                Spacer()
                Image("onboard3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 100)
                    .padding(.bottom, 50)
                Text("Tutorial")
                    .bold()
                    .font(.title)
                    .padding(.bottom)
                Text("Watch our 60 second tutorial for the best experience.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Spacer()
            }
        }
    }
}
struct Board3View_Previews: PreviewProvider {
    static var previews: some View {
        Board3View()
    }
}
struct VideoView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var locationTransfer: LocationTransfer
    let player = AVPlayer(url: Bundle.main.url(forResource: "IMG_3841", withExtension: "MOV")!)
    var body: some View {
        VStack {
            VideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    self.locationTransfer.isPresented.toggle()
                    LocationService.shared.checkLocationAuthStatus()
                }) {
                    Text("Get Parking!")
                        .padding(10)
                        .background(Color("orange1"))
                        .foregroundColor(Color("black1"))
                        .cornerRadius(50)
                        .padding()
                }
            }
        }.onAppear() {
            player.play()
        }
    }
}
struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView()
            .environmentObject(LocationTransfer())
    }
}
struct VideoTutorialView: View {
    @Environment(\.presentationMode) var presentationMode
    let player = AVPlayer(url: Bundle.main.url(forResource: "IMG_3841", withExtension: "MOV")!)
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .imageScale(.large)
                        .foregroundColor(Color("orange1"))
                        .padding()
                }
            }
            VideoPlayer(player: player).edgesIgnoringSafeArea(.all)
        }.onAppear() {
            player.play()
        }
    }
}
struct VideoTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        VideoTutorialView()
    }
}

