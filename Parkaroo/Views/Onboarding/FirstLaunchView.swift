//
//  FirstLaunchView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI
import AVKit

struct FirstLaunchView: View {
    @State private var SlideGesture = CGSize.zero
    @State private var SlideOne = false
    @State private var SlideOnePrevious = false
    @State private var SlideTwo = false
    @State private var SlideTwoPrevious = false
    @State private var Dots = false
    @State private var showingVideoSheet = false
    var body: some View {
        ZStack {
            Color("white1").edgesIgnoringSafeArea(.all)
            Board1View()
                .offset(x: SlideGesture.width)
                .offset(x: SlideOne ? -500 : 0)
                .animation(.spring())
                .gesture(
                    DragGesture().onChanged { value in
                        self.SlideGesture = value.translation
                    }
                    .onEnded { value in
                        if self.SlideGesture.width < -5 {
                            self.SlideOne = true
                            self.Dots = true
                            self.SlideOnePrevious = false
                        }
                        self.SlideGesture = .zero
                    })
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "circle.fill")
                        Image(systemName: "circle")
                        Image(systemName: "circle")
                    }.padding(30)
                    .font(.system(size: 12))
                    .foregroundColor(Color("orange1"))
                }
            }.offset(x: SlideOne ? 500 : 0)
            Board2View()
                .offset(x: SlideGesture.width)
                .offset(x: SlideOne ? 0 : 500)
                .offset(x: SlideOnePrevious ? 500 : 0)
                .offset(x: SlideTwo ? -500 : 0)
                .animation(.spring())
                .gesture(
                    DragGesture().onChanged { value in
                        self.SlideGesture = value.translation
                    }
                    .onEnded { value in
                        if self.SlideGesture.width < -5 {
                            self.SlideOne = true
                            self.SlideTwo = true
                            self.Dots = false
                        }
                        if self.SlideGesture.width > 5 {
                            self.SlideOnePrevious = true
                            self.SlideOne = false
                            self.Dots = false
                        }
                        self.SlideGesture = .zero
                    })
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "circle")
                        Image(systemName: "circle.fill")
                        Image(systemName: "circle")
                    }.padding(30)
                    .font(.system(size: 12))
                    .foregroundColor(Color("orange1"))
                }
            }.offset(x: Dots ? 0 : 500)
            Board3View()
                .offset(x: SlideGesture.width)
                .offset(x: SlideTwo ? 0 : 500)
                .animation(.spring())
                .gesture(
                    DragGesture().onChanged { value in
                        self.SlideGesture = value.translation
                    }
                    .onEnded { value in
                        if self.SlideGesture.width > 5 {
                            self.SlideTwo = false
                            self.SlideTwoPrevious = true
                            self.Dots = true
                        }
                        self.SlideGesture = .zero
                    })
            ZStack {
                VStack {
                    Spacer()
                    Button(action: {
                        self.showingVideoSheet.toggle()
                        self.vid()
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Watch Video")
                        }.padding(10)
                        .background(Color("orange1"))
                        .foregroundColor(Color("black1"))
                        .cornerRadius(50)
                        .padding(.bottom)
                    }.sheet(isPresented: $showingVideoSheet) {
                        VideoView()
                    }
                }.animation(.spring())
                .offset(x: SlideTwo ? 0 : 500)
            }
        }
    }
    private func vid() {
        try! AVAudioSession.sharedInstance().setCategory(.playback)
    }
}
struct FirstLaunchView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchView()
    }
}
