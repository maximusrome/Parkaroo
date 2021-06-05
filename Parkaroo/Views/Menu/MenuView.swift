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
    @State private var logOutClicked = false
    var body: some View {
        VStack(alignment: .leading, spacing: 60) {
            NavigationLink(destination: CreditsView()) {
                HStack {
                    Image(systemName: "dollarsign.circle")
                        .imageScale(.large)
                    Text("Credits")
                }.padding(.top, 125)
            }
            NavigationLink(destination: TutorialView()) {
                HStack {
                    Image(systemName: "book")
                        .imageScale(.large)
                    Text("Tutorial")
                }
            }
            NavigationLink(destination: SettingsView()) {
                HStack {
                    Image(systemName: "gear")
                        .imageScale(.large)
                    Text("Settings")
                }
            }
            if Auth.auth().currentUser?.uid != nil {
                Button(action: {
                    self.logOutClicked.toggle()
                }) {
                    HStack {
                        Image(systemName: "person")
                            .imageScale(.large)
                        Text("Log Out")
                    }.alert(isPresented: $logOutClicked) {
                        Alert(title: Text("Are you sure?"), message: Text("If you are currently giving or getting a spot, the spot will be automatically be cancelled by logging out."), primaryButton: Alert.Button.default(Text("No")), secondaryButton: Alert.Button.default(Text("Yes"), action: {
                            self.locationTransfer.fullCleanUp {
                                FBAuth.logOut { (_) in }
                            }
                            self.locationTransfer.credits = 0
                            self.gGRequestConfirm.moveBox = false
                            self.gGRequestConfirm.moveBox1 = false
                            self.gGRequestConfirm.showBox1 = false
                            self.gGRequestConfirm.showBox2 = false
                            self.gGRequestConfirm.showBox3 = false
                            self.gGRequestConfirm.showBox4 = false
                            self.gGRequestConfirm.showGiveConfirmView = false
                            self.presentationMode.wrappedValue.dismiss()
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
                NavigationLink(destination: LoginView()) {
                    HStack {
                        Image(systemName: "person")
                            .imageScale(.large)
                        Text("Login")
                    }
                }
            }
            Spacer()
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
    }
}
