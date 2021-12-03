//
//  GoodStuffView.swift
//  Parkaroo
//
//  Created by max rome on 5/15/21.
//
import SwiftUI
import UIKit
import MessageUI
import Firebase

struct GoodStuffView: View {
    @EnvironmentObject var gGRequestConfirm : GGRequestConfirm
    @EnvironmentObject var locationTransfer : LocationTransfer
    @EnvironmentObject var userInfo : UserInfo
    @State private var showReportProblem = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State private var logOutClicked = false
    var body: some View {
        List {
            if #available(iOS 15.0, *) {
                Section {
                    NavigationLink(destination: AccountView()) {
                        GoodStuffCell(title: "Account", imgName: "person")
                    }
                    NavigationLink(destination: CharityView()) {
                        GoodStuffCell(title: "Charity", imgName: "heart")
                    }
                }
            } else {
                NavigationLink(destination: AccountView()) {
                    GoodStuffCell(title: "Account", imgName: "person")
                }
                NavigationLink(destination: CharityView()) {
                    GoodStuffCell(title: "Charity", imgName: "heart")
                }
            }
            Section {
                NavigationLink(destination: TutorialView()) {
                    GoodStuffCell(title: "Tutorial", imgName: "book")
                }
                NavigationLink(destination: FAQSView()) {
                    GoodStuffCell(title: "Frequently Asked Questions", imgName: "info.circle")
                }
            }
            Section {
                Link(destination: URL(string: "https://parkaroo.org/privacy-policy")!) {
                    GoodStuffCell(title: "Privacy Policy", imgName: "doc.text")
                }
                Link(destination: URL(string: "https://parkaroo.org/terms-%26-conditions")!) {
                    GoodStuffCell(title: "Terms and Conditions", imgName: "doc.text")
                }
            }
            Section {
                Button(action: {
                    reportProblem()
                }) {
                    GoodStuffCell(title: "Report Problem", imgName: "exclamationmark.triangle")
                }.sheet(isPresented: $showReportProblem) {
                    MailView(result: $result, newSubject: "Report Problem", newMsgBody: "")
                }
                if Auth.auth().currentUser?.uid != nil {
                    Section {
                        Button(action: {
                            logOutClicked.toggle()
                        }) {
                            GoodStuffCell(title: "Log Out", imgName: "arrow.right.circle")
                        }.alert(isPresented: $logOutClicked) {
                            Alert(title: Text("Are you sure?"), message: Text("If you are currently giving or getting a spot, the spot will automatically be canceled by logging out."), primaryButton: Alert.Button.default(Text("No")), secondaryButton: Alert.Button.default(Text("Yes"), action: {
                                locationTransfer.fullCleanUp {
                                    FBAuth.logOut { (_) in }
                                }
                                userInfo.user.credits = 2
                                userInfo.user.rating = 0
                                userInfo.user.numberOfRatings = 0
                                userInfo.user.vehicle = ""
                                gGRequestConfirm.showGiveRequestView = false
                                gGRequestConfirm.showGiveConfirmView = false
                                gGRequestConfirm.showGetRequestView = false
                                gGRequestConfirm.showGetConfirmView = false
                                UIApplication.shared.endEditing()
                                Analytics.logEvent("log_out", parameters: nil)
                            }))
                        }
                    }
                }
            }
        }.listStyle(GroupedListStyle())
            .navigationBarTitle("Good Stuff", displayMode: .inline)
    }
    func reportProblem() {
        print("pressed report problem")
        if MFMailComposeViewController.canSendMail() {
            showReportProblem = true
        } else {
            print("Error sending mail")
        }
    }
}
struct GoodStuffCell: View {
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
struct GoodStuffView_Previews: PreviewProvider {
    static var previews: some View {
        GoodStuffView()
    }
}
