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
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 60) {
            NavigationLink(destination: CreditsView()) {
                HStack {
                    Image(systemName: "dollarsign.circle")
                        .imageScale(.large)
                    Text("Credits")
                }.padding(.top, 125)
            }
            //            NavigationLink(destination: NotificationsView()) {
            //                HStack {
            //                    Image(systemName: "bell")
            //                        .imageScale(.large)
            //                    Text("Notifications")
            //                }
            //            }
            NavigationLink(destination: CharityView()) {
                HStack {
                    Image(systemName: "heart")
                        .imageScale(.large)
                    Text("Charity")
                }
            }
            NavigationLink(destination: TutorialView()) {
                HStack {
                    Image(systemName: "book")
                        .imageScale(.large)
                    Text("Tutorial")
                }
            }
            NavigationLink(destination: HelpView()) {
                HStack {
                    Image(systemName: "questionmark.circle")
                        .imageScale(.large)
                    Text("Help")
                }
            }
            if Auth.auth().currentUser?.uid != nil {
                Button(action: {
                    self.locationTransfer.deletePin()
                    self.locationTransfer.locations.removeAll()
                    self.locationTransfer.locations1.removeAll()
                    self.gGRequestConfirm.moveBox = false
                    self.gGRequestConfirm.moveBox1 = false
                    self.gGRequestConfirm.showBox1 = false
                    self.gGRequestConfirm.showBox2 = false
                    self.gGRequestConfirm.showBox3 = false
                    self.gGRequestConfirm.showBox4 = false
                    self.locationTransfer.credits = 0
                    FBAuth.logOut { (result) in
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    HStack {
                        Image(systemName: "person")
                            .imageScale(.large)
                        Text("Log Out")
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
