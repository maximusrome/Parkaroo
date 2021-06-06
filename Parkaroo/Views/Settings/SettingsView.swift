//
//  SettingsView.swift
//  Parkaroo
//
//  Created by max rome on 5/15/21.
//
import SwiftUI
import UIKit
import MessageUI

struct SettingsView: View {
    @State private var showContactUs = false
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
            }
            Section {
                Button(action: {
                    self.contactUs()
                }) {
                    SettingsCell(title: "Contact Us", imgName: "envelope")
                }.sheet(isPresented: $showContactUs) {
                    MailView(result: self.$result, newSubject: "Contact Us", newMsgBody: "")
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
        print("pressed invite friends")
        let url = URL(string: "https://apps.apple.com/us/app/parkaroo/id1560506911")
        let activityView = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityView, animated: true, completion: nil)
    }
    func contactUs() {
        print("pressed contact us")
        if MFMailComposeViewController.canSendMail() {
            self.showContactUs = true
        } else {
            print("Error sending mail")
        }
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
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
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
struct SettingsCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCell(title: "Features", imgName: "sparks")
    }
}
