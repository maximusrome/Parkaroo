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
    @State private var showNotificationsSettings = false
    @State private var showLocationSettings = false
    @State private var showingParkSetUpAlert = false
    @State private var showingSaveSuccessAlert = false
    @State var offset : CGFloat = UIScreen.main.bounds.height
    @AppStorage("OboardBeenViewed") var hasOnboarded = false
    init() {
        let navigationBarAppearance = UINavigationBarAppearance()
        if #available(iOS 15.0, *) {
            navigationBarAppearance.backgroundColor = UIColor(Color("white1"))
            navigationBarAppearance.shadowColor = .clear
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            UITabBar.appearance().backgroundColor = UIColor(Color("white1"))
        } else {
            navigationBarAppearance.configureWithTransparentBackground()
            navigationBarAppearance.backgroundColor = UIColor(Color("white1"))
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UITabBar.appearance().barTintColor = UIColor(Color("white1"))
        }
    }
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
                TabView(selection: $locationTransfer.rightTab) {
                    GetView()
                        .tabItem {
                            Image(systemName: "car.fill")
                            Text("Get Spot")
                        }.tag(false)
                    GiveView()
                        .tabItem {
                            Image(systemName: "p.square.fill")
                            Text("Give Spot")
                        }.tag(true)
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
                    HStack {
                        Text("")
                            .alert(isPresented: $showingSaveSuccessAlert) {
                                Alert(title: Text("Spot Saved"), dismissButton: .default(Text("Done")))
                            }
                        Spacer()
                        VStack {
                            Button(action: {
                                if LocationService.shared.locationAuthorized {
                                    LocationService.shared.manager?.startUpdatingLocation()
                                    LocationService1.shared.manager?.startUpdatingLocation()
                                } else {
                                    showLocationSettings.toggle()
                                }
                            }) {
                                Image(systemName: "location")
                                    .imageScale(.large)
                                    .padding(10)
                                    .foregroundColor(Color("orange1"))
                                    .background(Color("white1"))
                                    .cornerRadius(50)
                                    .shadow(radius: 5)
                                    .padding(10)
                            }.alert(isPresented: $showLocationSettings, content: {
                                Alert(title: Text("Enable Current Location"), message: Text("To see your current location you must enable location services in your settings app."), primaryButton: Alert.Button.default(Text("cancel")), secondaryButton: Alert.Button.default(Text("Okay"), action: {
                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                }))
                            })
                            if (locationTransfer.givingPin == nil && !gGRequestConfirm.showBuyerRatingView && !gGRequestConfirm.showGiveRequestView) && locationTransfer.rightTab == true {
                                Text("P")
                                    .font(.title2)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .foregroundColor(Color("orange1"))
                                    .background(Color("white1"))
                                    .cornerRadius(50)
                                    .shadow(radius: 5)
                                    .onTapGesture() {
                                        Analytics.logEvent("save_spot", parameters: nil)
                                        if userInfo.isUserAuthenticated == .signedIn {
                                            if locationTransfer.locations.count > 0 {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                                    locationTransfer.locations.removeFirst()
                                                }
                                            }
                                            locationTransfer.parkPress = true
                                            userInfo.SaveLocation(SLongitude: Float(locationTransfer.centerCoordinate.longitude), SLatitude: Float(locationTransfer.centerCoordinate.latitude))
                                            locationTransfer.addRefencePin()
                                            showingSaveSuccessAlert = true
                                        } else {
                                            showingParkSetUpAlert = true
                                        }
                                    }.onLongPressGesture(minimumDuration: 0.1) {
                                        locationTransfer.locations.removeAll()
                                    }.alert(isPresented: $showingParkSetUpAlert) {
                                        Alert(title: Text("Get Set Up"), message: Text("In order to save the location of your current parking spot you must have an account. Go to Sign up or Login under the meanu."), dismissButton: .default(Text("Okay")))
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
                    .alert(isPresented: $showNotificationsSettings, content: {
                        Alert(title: Text("Enable Notifications"), message: Text("To adjust your notifications you must enable them in your settings app."), primaryButton: Alert.Button.default(Text("cancel")), secondaryButton: Alert.Button.default(Text("Okay"), action: {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }))
                    })
            }.navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        if !locationTransfer.showOnBoarding || !locationTransfer.isPresented {
                            Image("Logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200)
                        }
                    }
                }.navigationBarItems(leading:
                                        Button(action: {
                    if Auth.auth().currentUser?.uid != nil {
                        NotificationsService.shared.getNotificationStatus {
                            if NotificationsService.shared.notificationStatusAuthorized {
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
                                showNotificationsSettings.toggle()
                            }
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
        }.accentColor(locationTransfer.showOnBoarding && locationTransfer.isPresented ? Color("white1") : Color("orange1"))
            .alert(isPresented: $showSetUpNotifications, content: {
                Alert(title: Text("Get Set Up"), message: Text("To adjust your notifications you must have an account. Go to Sign Up or Login under the menu."), dismissButton: Alert.Button.default(Text("Okay")))
            })
            .onAppear() {
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
