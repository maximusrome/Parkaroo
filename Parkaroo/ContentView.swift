//
//  ContentView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//
import MapKit
import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @ObservedObject var monitor = NetworkMonitor()
    @State private var showMenu = false
    @State private var showNotifications = false
    @State private var showSetUpNotifications = false
    @State var offset : CGFloat = UIScreen.main.bounds.height
    @AppStorage("OboardBeenViewed") var hasOnboarded = false
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < 250 {
                    withAnimation {
                        showMenu = false
                    }
                }
            }
        NavigationView {
            ZStack {
                TabView {
                    GetView()
                        .tabItem {
                            Image(systemName: "car.fill")
                            Text("Get Spot")
                        }
                    GiveView()
                        .tabItem {
                            Image(systemName: "p.square.fill")
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
                            .gesture(drag)
                    }
                }
                if locationTransfer.showOnBoarding && locationTransfer.isPresented {
                    FirstLaunchView()
                        .navigationBarHidden(true)
                }
                if !monitor.isConnected {
                    WifiView()
                }
                if locationTransfer.forceUpdate {
                    ForceUpdateView()
                        .navigationBarHidden(true)
                        .edgesIgnoringSafeArea(.all)
                }
                if (!locationTransfer.showOnBoarding || !locationTransfer.isPresented) && !showMenu {
                    if LocationService.shared.locationAuthorized {
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    LocationService.shared.manager?.startUpdatingLocation()
                                    LocationService1.shared.manager?.startUpdatingLocation()
                                }) {
                                    Image(systemName: "location")
                                        .imageScale(.large)
                                        .padding(10)
                                        .foregroundColor(Color("orange1"))
                                        .background(Color("white1"))
                                        .cornerRadius(50)
                                        .shadow(radius: 5)
                                        .padding(10)
                                }
                            }
                            Spacer()
                        }
                    }
                }
                VStack {
                    Spacer()
                    if offset < 100 {
                        NotificationsSheet()
                            .offset(y: offset)
                            .transition(AnyTransition.move(edge: .bottom))
                            .gesture(DragGesture()
                                        .onChanged({ (value) in
                                            if value.translation.height > 0 {
                                                offset = value.location.y
                                            }
                                        })
                                        .onEnded({ (value) in
                                            if offset > 100 {
                                                offset = UIScreen.main.bounds.height
                                            } else {
                                                offset = 0
                                            }
                                        })
                            )
                    }
                }.animation(.default)
                .background((offset <= 100 ? Color(UIColor.label).opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    offset = UIScreen.main.bounds.height
                                }).edgesIgnoringSafeArea(.bottom)
                .background((showMenu ? Color(UIColor.label).opacity(0.001) : Color.clear)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                .offset(x: -UIScreen.main.bounds.width/2)
                                .onTapGesture {
                                    withAnimation {
                                        showMenu = false
                                    }
                                })
            }.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                }
            }.navigationBarItems(leading:
                                    Button(action: {
                                        if Auth.auth().currentUser?.uid != nil {
                                            if offset == UIScreen.main.bounds.height {
                                                showNotifications = true
                                            } else {
                                                showNotifications = false
                                            }
                                            if showNotifications {
                                                offset = 0
                                            } else {
                                                offset = UIScreen.main.bounds.height
                                            }
                                        } else {
                                            showSetUpNotifications.toggle()
                                        }
                                    }) {
                                        Image(systemName: "bell")
                                            .imageScale(.large)
                                            .frame(width: 50, height: 50, alignment: .leading)
                                    }, trailing:
                                        Button(action: {
                                            withAnimation {
                                                showMenu.toggle()
                                            }
                                        }) {
                                            Image(systemName: showMenu ? "xmark" : "line.horizontal.3")
                                                .imageScale(.large)
                                                .frame(width: 50, height: 50, alignment: .trailing)
                                        })
        }.accentColor(Color("orange1"))
        .alert(isPresented: $showSetUpNotifications, content: {
            Alert(title: Text("Get Set Up"), message: Text("To adjust your notifications you must have an account. Go to Sign Up or Login under the menu."), dismissButton: Alert.Button.default(Text("Okay")))
        })
        .onAppear {
            locationTransfer.checkLastCompatibleVersion()
            if !hasOnboarded {
                locationTransfer.showOnBoarding.toggle()
                hasOnboarded = true
            }
            userInfo.configureFirebaseStateDidChange()
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LocationTransfer())
            .environmentObject(UserInfo())
            .environmentObject(GGRequestConfirm())
            .environmentObject(NetworkMonitor())
    }
}
