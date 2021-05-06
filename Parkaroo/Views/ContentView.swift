//
//  ContentView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//
import MapKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var userInfo: UserInfo
    @State private var showMenu = false
    @State private var showOnBoarding = false
    @AppStorage("OboardBeenViewed") private var hasOnboarded = false
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < 250 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }
        NavigationView {
            ZStack(alignment: .leading) {
                TabView {
                    GetView()
                        .tabItem {
                            Image(systemName: "car.fill")
                            Text("Get Spot")
                        }
                    GiveView()
                        .tabItem {
                            Image(systemName: "rectangle.fill")
                            Text("Give Spot")
                        }
                }
                GeometryReader { geometry in
                    if !showMenu {
                        MenuView()
                            .frame(width: geometry.size.width/2)
                            .transition(.slide)
                            .offset(x: geometry.size.width, y: 0)
                    }
                    if showMenu {
                        MenuView()
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .trailing))
                            .offset(x: geometry.size.width/2, y: 0)
                    }
                }
                if showOnBoarding {
                    FirstLaunchView(isPresenting: $showOnBoarding)
                        .navigationBarHidden(true)
                }
            }.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button(action: {
                        if !self.locationTransfer.logoTap {
                            self.locationTransfer.logoTap = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                self.locationTransfer.logoTap = false
                            }
                        }
                        if !self.locationTransfer.logoTap1 {
                            self.locationTransfer.logoTap1 = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                self.locationTransfer.logoTap1 = false
                            }
                        }
                    }) {
                        Image("Logo")
                            .resizable()
                            .frame(width: 196, height: 32)
                    }
                }
            }.navigationBarItems(trailing:
                                    Button(action: {
                                        withAnimation {
                                            self.showMenu.toggle()
                                        }
                                    }) {
                                        Image(systemName: self.showMenu ? "xmark" : "line.horizontal.3")
                                            .imageScale(.large)
                                    })
        }.accentColor(Color("orange1"))
        .onAppear {
            if !hasOnboarded {
                showOnBoarding.toggle()
                hasOnboarded = true
            }
            self.userInfo.configureFirebaseStateDidChange()
        }.gesture(drag)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LocationTransfer())
            .environmentObject(UserInfo())
            .environmentObject(GGRequestConfirm())
    }
}
