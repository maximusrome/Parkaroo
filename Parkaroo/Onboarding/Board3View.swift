//
//  Board3View.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI
import AVKit

struct Board3View: View {
    let player = AVPlayer(url: Bundle.main.url(forResource: "IMG_3841", withExtension: "MOV")!)
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
                Text("Watch Tutorial")
                    .bold()
                    .font(.title)
                    .padding()
                VideoPlayer(player: player)
                    .edgesIgnoringSafeArea(.all)
                    .padding(.bottom, 100)
            }
        }
    }
}
struct Board3View_Previews: PreviewProvider {
    static var previews: some View {
        Board3View()
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
                    presentationMode.wrappedValue.dismiss()
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

