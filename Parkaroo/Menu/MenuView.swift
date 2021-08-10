//
//  MenuView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//
import SwiftUI
import Firebase
import UIKit
import MessageUI

struct MenuView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State private var showContactUs = false
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Spacer()
            NavigationLink(destination: CreditsView()) {
                HStack {
                    Image(systemName: "dollarsign.circle")
                        .imageScale(.large)
                    Text("Credits")
                }
            }
            Spacer()
            Button(action: {
                contactUs()
            }) {
                HStack {
                    Image(systemName: "envelope")
                        .imageScale(.large)
                    Text("Contact Us")
                }.sheet(isPresented: $showContactUs) {
                    MailView(result: $result, newSubject: "Contact Us", newMsgBody: "")
                }
            }
            Spacer()
            Button(action: {
                inviteFriends()
            }) {
                Image(systemName: "person.2")
                    .imageScale(.large)
                Text("Invite Friends")
            }
            Spacer()
            NavigationLink(destination: GoodStuffView()) {
                HStack {
                    Image(systemName: "gift")
                        .imageScale(.large)
                    Text("Good Stuff")
                }
            }
            Group {
                Spacer()
                if Auth.auth().currentUser?.uid == nil {
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
                            Image(systemName: "arrow.right.circle")
                                .imageScale(.large)
                            Text("Login")
                        }
                    }
                }
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
    func contactUs() {
        print("pressed contact us")
        if MFMailComposeViewController.canSendMail() {
            showContactUs = true
        } else {
            print("Error sending mail")
        }
    }
    func inviteFriends() {
        Analytics.logEvent("invite_friends", parameters: nil)
        let url = URL(string: "https://apps.apple.com/us/app/parkaroo/id1560506911")
        let activityView = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityView, animated: true, completion: nil)
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
