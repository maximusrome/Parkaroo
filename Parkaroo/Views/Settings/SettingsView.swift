//
//  SettingsView.swift
//  Parkaroo
//
//  Created by max rome on 5/15/21.
//
import SwiftUI
import UIKit
import MessageUI
import Firebase

struct SettingsView: View {
    @State private var showReportProblem = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    var body: some View {
        List {
            Section {
                NavigationLink(destination: CharityView()) {
                    SettingsCell(title: "Charity", imgName: "heart")
                }
                Button(action: {
                    self.inviteFriends()
                }) {
                    SettingsCell(title: "Invite Friends", imgName: "person.2")
                }
            }
            Section {
                NavigationLink(destination: TutorialView()) {
                    SettingsCell(title: "Tutorial", imgName: "book")
                }
                NavigationLink(destination: FAQSView()) {
                    SettingsCell(title: "Frequently Asked Questions", imgName: "info.circle")
                }
            }
            Section {
                Link(destination: URL(string: "https://parkaroo.org/privacy-policy")!) {
                    SettingsCell(title: "Privacy Policy", imgName: "doc.text")
                }
                Link(destination: URL(string: "https://parkaroo.org/terms-%26-conditions")!) {
                    SettingsCell(title: "Terms and Conditions", imgName: "doc.text")
                }
                Button(action: {
                    self.reportProblem()
                }) {
                    SettingsCell(title: "Report Problem", imgName: "exclamationmark.triangle")
                }.sheet(isPresented: $showReportProblem) {
                    MailView(result: self.$result, newSubject: "Report Problem", newMsgBody: "")
                }
            }
        }.listStyle(GroupedListStyle())
        .navigationBarTitle("Settings", displayMode: .inline)
    }
    func inviteFriends() {
        Analytics.logEvent("invite_friends", parameters: nil)
        let url = URL(string: "https://apps.apple.com/us/app/parkaroo/id1560506911")
        let activityView = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityView, animated: true, completion: nil)
    }
    func reportProblem() {
        print("pressed report problem")
        if MFMailComposeViewController.canSendMail() {
            self.showReportProblem = true
        } else {
            print("Error sending mail")
        }
    }
}
struct SettingsCell: View {
    var title : String
    var imgName : String
    var body: some View {
        HStack {
            Image(systemName: imgName)
                .font(.headline)
                .foregroundColor(Color("black1"))
            Text(title)
                .font(.headline)
                .foregroundColor(Color("black1"))
                .padding(.leading, 10)
            Spacer()
        }
    }
}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
