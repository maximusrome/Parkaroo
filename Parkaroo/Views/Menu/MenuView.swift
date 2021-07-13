//
//  MenuView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//
import SwiftUI
import Firebase

struct MenuView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gGRequestConfirm : GGRequestConfirm
    @EnvironmentObject var locationTransfer : LocationTransfer
    @EnvironmentObject var userInfo : UserInfo
    @State private var logOutClicked = false
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Spacer()
                Spacer()
            }
            NavigationLink(destination: CreditsView()) {
                HStack {
                    Image(systemName: "dollarsign.circle")
                        .imageScale(.large)
                    Text("Credits")
                }
            }
            Spacer()
            NavigationLink(destination: TutorialView()) {
                HStack {
                    Image(systemName: "book")
                        .imageScale(.large)
                    Text("Tutorial")
                }
            }
            Spacer()
            NavigationLink(destination: SettingsView()) {
                HStack {
                    Image(systemName: "gear")
                        .imageScale(.large)
                    Text("Settings")
                }
            }
            Spacer()
            if Auth.auth().currentUser?.uid != nil {
                Button(action: {
                    self.logOutClicked.toggle()
                }) {
                    HStack {
                        Image(systemName: "person")
                            .imageScale(.large)
                        Text("Log Out")
                    }.alert(isPresented: $logOutClicked) {
                        Alert(title: Text("Are you sure?"), message: Text("If you are currently giving or getting a spot, the spot will automatically be canceled by logging out."), primaryButton: Alert.Button.default(Text("No")), secondaryButton: Alert.Button.default(Text("Yes"), action: {
                            self.locationTransfer.fullCleanUp {
                                FBAuth.logOut { (_) in }
                            }
                            self.userInfo.user.credits = 0
                            self.gGRequestConfirm.showGiveRequestView = false
                            self.gGRequestConfirm.showGiveConfirmView = false
                            self.gGRequestConfirm.showGetRequestView = false
                            self.gGRequestConfirm.showGetConfirmView = false
                            UIApplication.shared.endEditing()
                            Analytics.logEvent("log_out", parameters: nil)
                        }))
                    }
                }
            } else {
                NavigationLink(destination: SignUpView()) {
                    HStack {
                        Image(systemName: "square.and.pencil")
                            .imageScale(.large)
                        Text("Sign Up")
                    }
                }
                Spacer()
                NavigationLink(destination: LoginView()) {
                    HStack {
                        Image(systemName: "person")
                            .imageScale(.large)
                        Text("Login")
                    }
                }
            }
            Group {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
        }.font(.headline)
        .padding(.leading, 30)
        .foregroundColor(Color("black1"))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("white1"))
        .edgesIgnoringSafeArea(.all)
    }
}
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(GGRequestConfirm())
            .environmentObject(LocationTransfer())
            .environmentObject(UserInfo())
    }
}
