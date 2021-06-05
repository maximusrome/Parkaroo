//
//  GiveRequestView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI
import Firebase
import MapKit

struct GiveRequestView: View {
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @EnvironmentObject var userInfo: UserInfo
    @State var rating = 5
    @State private var showingOffMarketAlert = false
    @State private var showingMinuteAlert = false
    func abc() -> Bool {
        if Int(locationTransfer.minute) != 0 {
            let minuteTest = NSPredicate(format: "SELF MATCHES %@",
                                         "^[0-9]+$")
            return minuteTest.evaluate(with: locationTransfer.minute)
        } else {
            return false
        }
    }
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                HStack {
                    Text("Departing in:")
                        .bold()
                    TextField("e.g. 5", text: $locationTransfer.minute)
                        .onChange(of: self.locationTransfer.minute, perform: { value in
                            if value.count > 3 {
                                self.locationTransfer.minute = String(value.prefix(3))
                            }
                        })
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .fixedSize()
                    Text("Minutes")
                        .bold()
                }.padding()
                .padding(.top, 5)
                Spacer()
                HStack {
                    Text("Your Rating: \(self.userInfo.user.numberOfRatings > 0 ? String(format: "%.2f", self.userInfo.user.rating) : "N/A")")
                        .bold()
                    Image(systemName: "star.fill")
                        .foregroundColor(Color("orange1"))
                    Text("\(self.userInfo.user.numberOfRatings > 0 ? String(self.userInfo.user.numberOfRatings) : "0") ratings")
                        .font(.footnote)
                }
                Spacer()
                HStack {
                    Button(action: {
                        UIApplication.shared.endEditing()
                        self.gGRequestConfirm.showBox1 = false
                        self.locationTransfer.minute = ""
                    }){
                        Text("Close")
                            .padding(10)
                    }
                    Button(action: {
                        if abc() {
                            UIApplication.shared.endEditing()
                            self.locationTransfer.createPin()
                            self.showingMinuteAlert = false
                            self.gGRequestConfirm.showBox1 = false
                            self.gGRequestConfirm.showGiveConfirmView = true
                        } else {
                            self.showingMinuteAlert = true
                        }
                    }) {
                        Text("Make Avaliable")
                            .bold()
                            .padding(10)
                            .background(Color("orange1"))
                            .cornerRadius(50)
                    }.alert(isPresented: $showingMinuteAlert) {
                        return Alert(title: Text("Invalid Departure Time"), message: Text(""), dismissButton: .default(Text("Okay")))
                    }
                }.padding()
                .padding(.bottom, 10)
            }.frame(width: 300, height: 200)
            .background(Color("white1"))
            .foregroundColor(Color("black1"))
            .cornerRadius(30)
            .shadow(radius: 5)
            .padding(.bottom)
            .padding(.horizontal, 50)
            .padding(.bottom, gGRequestConfirm.moveBox1 ? 170 : 0)
        }
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
struct GiveRequestView_Previews: PreviewProvider {
    static var previews: some View {
        GiveRequestView()
            .environmentObject(LocationTransfer())
            .environmentObject(GGRequestConfirm())
            .environmentObject(UserInfo())
    }
}
