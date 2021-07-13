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
    init() {
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
        UITableView.appearance().tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
    }
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @EnvironmentObject var userInfo: UserInfo
    @State var rating = 5
    @State private var showingInvalidDepartureAlert = false
    @State private var showingInvalidStreetInfoAlert = false
    func abc() -> Bool {
        if Int(locationTransfer.minute) != 0 {
            let minuteTest = NSPredicate(format: "SELF MATCHES %@",
                                         "^[0-9]+$")
            return minuteTest.evaluate(with: locationTransfer.minute)
        } else {
            return false
        }
    }
    let streetOptions: [String] = [
        "N/A", "Meter Side", "Friday Side", "Thursday Side"
    ]
    var body: some View {
        VStack {
            HStack {
                Text("Departing in:")
                    .bold()
                TextField("10     ", text: $locationTransfer.minute)
                    .onChange(of: self.locationTransfer.minute, perform: { value in
                        if value.count > 3 {
                            self.locationTransfer.minute = String(value.prefix(3))
                        }
                    })
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fixedSize()
                Text("minutes")
            }.padding(.top, 25)
            Spacer()
            Picker(selection: $locationTransfer.giveStreetInfoSelection,
                   label:
                    HStack {
                        Text("Street Info: ")
                            .bold()
                        Text("\(self.locationTransfer.giveStreetInfoSelection)")
                            .bold()
                            .foregroundColor(Color("orange1"))
                    }, content: {
                        ForEach(streetOptions, id: \.self) { option in
                            Text(option)
                                .tag(option)
                        }
                    })
                .pickerStyle(MenuPickerStyle())
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            Spacer()
            HStack {
                Text("Your Rating: \(self.userInfo.user.numberOfRatings > 0 ? String(format: "%.2f", self.userInfo.user.rating) : "N/A")")
                    .bold()
                Text("\(self.userInfo.user.numberOfRatings > 0 ? String(self.userInfo.user.numberOfRatings) : "0") ratings")
                    .font(.footnote)
            }
            Spacer()
            HStack {
                Button(action: {
                    UIApplication.shared.endEditing()
                    self.gGRequestConfirm.showGiveRequestView = false
                    self.locationTransfer.minute = ""
                    self.locationTransfer.locations.removeAll()
                }){
                    Text("close")
                        .padding(10)
                }.alert(isPresented: $showingInvalidStreetInfoAlert) {
                    return Alert(title: Text("Add Street Info"), dismissButton: .default(Text("Okay")))
                }
                Button(action: {
                    if abc() {
                        if self.locationTransfer.giveStreetInfoSelection != "Edit" {
                            UIApplication.shared.endEditing()
                            self.locationTransfer.locations.removeFirst()
                            self.locationTransfer.createPin()
                            self.showingInvalidDepartureAlert = false
                            self.showingInvalidStreetInfoAlert = false
                            self.gGRequestConfirm.showGiveRequestView = false
                            self.gGRequestConfirm.showGiveConfirmView = true
                            Analytics.logEvent("make_available", parameters: nil)
                        } else {
                            self.showingInvalidStreetInfoAlert = true
                        }
                    } else {
                        self.showingInvalidDepartureAlert = true
                    }
                }) {
                    Text("Make Available")
                        .bold()
                        .padding(10)
                        .background(Color("orange1"))
                        .cornerRadius(50)
                }.alert(isPresented: $showingInvalidDepartureAlert) {
                    return Alert(title: Text("Add Departure Time"), dismissButton: .default(Text("Okay")))
                }
            }.padding(.bottom, 25)
        }.frame(width: 300, height: 280)
        .background(Color("white1"))
        .foregroundColor(Color("black1"))
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.bottom)
        .padding(.horizontal, 50)
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
