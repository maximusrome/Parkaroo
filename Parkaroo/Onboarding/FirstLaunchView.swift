//
//  FirstLaunchView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI
import AVKit

struct FirstLaunchView: View {
    @EnvironmentObject var locationTransfer: LocationTransfer
    @State private var SlideGesture = CGSize.zero
    @State private var SlideOne = false
    @State private var SlideOnePrevious = false
    @State private var SlideTwo = false
    @State private var SlideTwoPrevious = false
    @State private var Dots = false
    @State private var SlideThree = false
    @State private var SlideThreePrevious = false
    var body: some View {
        ZStack {
            Color("white1").edgesIgnoringSafeArea(.all)
            Board1View()
                .offset(x: SlideGesture.width)
                .offset(x: SlideOne ? -500 : 0)
                .animation(.spring())
                .gesture(
                    DragGesture().onChanged { value in
                        SlideGesture = value.translation
                    }
                    .onEnded { value in
                        if SlideGesture.width < -5 {
                            SlideOne = true
                            Dots = true
                            SlideOnePrevious = false
                        }
                        SlideGesture = .zero
                    })
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "circle.fill")
                        Image(systemName: "circle")
                        Image(systemName: "circle")
                        Image(systemName: "circle")
                    }.padding(30)
                    .font(.system(size: 12))
                    .foregroundColor(Color("orange1"))
                }
            }.offset(x: SlideOne ? 2000 : 0)
            Board2View()
                .offset(x: SlideGesture.width)
                .offset(x: SlideOne ? 0 : 500)
                .offset(x: SlideOnePrevious ? 500 : 0)
                .offset(x: SlideTwo ? -500 : 0)
                .animation(.spring())
                .gesture(
                    DragGesture().onChanged { value in
                        SlideGesture = value.translation
                    }
                    .onEnded { value in
                        if SlideGesture.width < -5 {
                            SlideOne = true
                            SlideTwo = true
                            Dots = false
                        }
                        if SlideGesture.width > 5 {
                            SlideOnePrevious = true
                            SlideOne = false
                            Dots = false
                        }
                        SlideGesture = .zero
                    })
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "circle")
                        Image(systemName: "circle.fill")
                        Image(systemName: "circle")
                        Image(systemName: "circle")
                    }.padding(30)
                    .font(.system(size: 12))
                    .foregroundColor(Color("orange1"))
                }
            }.offset(x: Dots ? 0 : 2000)
            Board3View()
                .offset(x: SlideGesture.width)
                .offset(x: SlideTwo ? 0 : 500)
                .offset(x: SlideThree ? -500 : 0)
                .animation(.spring())
                .gesture(
                    DragGesture().onChanged { value in
                        SlideGesture = value.translation
                    }
                    .onEnded { value in
                        if SlideGesture.width < -5 {
                            SlideOne = true
                            SlideTwo = true
                            SlideThree = true
                            Dots = false
                        }
                        if SlideGesture.width > 5 {
                            SlideTwo = false
                            SlideTwoPrevious = true
                            Dots = true
                        }
                        SlideGesture = .zero
                    })
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "circle")
                        Image(systemName: "circle")
                        Image(systemName: "circle.fill")
                        Image(systemName: "circle")
                    }.padding(30)
                    .font(.system(size: 12))
                    .foregroundColor(Color("orange1"))
                }
            }.offset(x: SlideTwo ? 0 : 2000)
            Board4View()
                .offset(x: SlideGesture.width)
                .offset(x: SlideThree ? 0 : 500)
                .animation(.spring())
                .gesture(
                    DragGesture().onChanged { value in
                        SlideGesture = value.translation
                    }
                    .onEnded { value in
                        if SlideGesture.width > 5 {
                            SlideThree = false
                            SlideThreePrevious = true
                            Dots = true
                        }
                        SlideGesture = .zero
                    })
        }.onAppear() {
            try! AVAudioSession.sharedInstance().setCategory(.playback)
        }
    }
}
struct FirstLaunchView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchView()
    }
}
