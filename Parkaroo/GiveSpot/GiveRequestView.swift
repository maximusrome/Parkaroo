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
    @State private var showingShortTimeAlert = false
    @State private var firstMakeAvailableClicked = true
    @State private var mins = ""
    @State private var hours = ""
    func atLeastOneTimeValidation() -> Bool {
        var atLeastOne: Bool = false
        if hours == "" {
            if departureMinuteValidation() {
                atLeastOne = true
            }
        } else if mins == "" {
            if departureHourValidation() {
                atLeastOne = true
            }
        } else if (hours == "" && mins == "") || (hours != "" && mins != "") {
            if departureMinuteValidation() && departureHourValidation() {
                atLeastOne = true
            }
        } else {
            atLeastOne = false
        }
        if atLeastOne == true {
            return true
        } else {
            return false
        }
    }
    func departureHourValidation() -> Bool {
        let hourTest = NSPredicate(format: "SELF MATCHES %@",
                                   "^[0-9]+$")
        return hourTest.evaluate(with: hours)
    }
    func departureMinuteValidation() -> Bool {
        let minuteTest = NSPredicate(format: "SELF MATCHES %@",
                                     "^[0-9]+$")
        return minuteTest.evaluate(with: mins)
    }
    let streetOptions: [String] = [
        "N/A", "Meter Side", "Friday Side", "Thursday Side"
    ]
    var body: some View {
        VStack {
            HStack {
                Text("Departing in:")
                    .bold()
                TextField("0", text: $hours)
                    .onChange(of: hours, perform: { value in
                        if value.count > 2 {
                            hours = String(value.prefix(2))
                        }
                    })
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fixedSize()
                Text("hr")
                TextField("30", text: $mins)
                    .onChange(of: mins, perform: { value in
                        if value.count > 2 {
                            mins = String(value.prefix(2))
                        }
                    })
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fixedSize()
                Text("min")
            }.padding(.top, 25)
            Spacer()
            Picker(selection: $locationTransfer.giveStreetInfoSelection,
                   label:
                    HStack {
                        Text("Street Info:")
                            .bold()
                        Text("\(locationTransfer.giveStreetInfoSelection)")
                            .bold()
                            .foregroundColor(Color("orange1"))
                            .multilineTextAlignment(.center)
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
                Text("Your Rating: \(userInfo.user.numberOfRatings > 0 ? String(format: "%.2f", userInfo.user.rating) : "N/A")")
                    .bold()
                Text("\(userInfo.user.numberOfRatings > 0 ? String(userInfo.user.numberOfRatings) : "0") ratings")
                    .font(.footnote)
            }.alert(isPresented: $showingShortTimeAlert) {
                return Alert(title: Text("Friendly Reminder"), message: Text("We recommend leaving a bit more time so your neighbors can get to your spot."), dismissButton: .default(Text("Okay")))
            }
            Spacer()
            HStack {
                Button(action: {
                    UIApplication.shared.endEditing()
                    gGRequestConfirm.showGiveRequestView = false
                    locationTransfer.minute = ""
                    mins = ""
                    hours = ""
                    locationTransfer.locations.removeAll()
                    firstMakeAvailableClicked = true
                }){
                    Text("close")
                        .padding(10)
                }.alert(isPresented: $showingInvalidStreetInfoAlert) {
                    return Alert(title: Text("Add Street Info"), dismissButton: .default(Text("Okay")))
                }
                Button(action: {
                    if atLeastOneTimeValidation() {
                        addMinutesAndHours()
                        if locationTransfer.giveStreetInfoSelection != "Edit" {
                            if (hours == "" || Int(hours) == 0) && (mins == "" || Int(mins)! < 10) && firstMakeAvailableClicked {
                                showingShortTimeAlert = true
                                firstMakeAvailableClicked = false
                            } else {
                                UIApplication.shared.endEditing()
                                locationTransfer.locations.removeFirst()
                                locationTransfer.createPin()
                                showingInvalidDepartureAlert = false
                                showingInvalidStreetInfoAlert = false
                                gGRequestConfirm.showGiveRequestView = false
                                gGRequestConfirm.showGiveConfirmView = true
                                firstMakeAvailableClicked = true
                                mins = ""
                                hours = ""
                                Analytics.logEvent("make_available", parameters: nil)
                            }
                        } else {
                            showingInvalidStreetInfoAlert = true
                        }
                    } else {
                        showingInvalidDepartureAlert = true
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
        }.frame(width: 320, height: 280)
        .background(Color("white1"))
        .foregroundColor(Color("black1"))
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.bottom)
        .padding(.horizontal, 50)
    }
    private func addMinutesAndHours() {
        var totalMinutes: Int
        totalMinutes = ((Int(hours) ?? 0) * 60) + (Int(mins) ?? 0)
        locationTransfer.minute = String(totalMinutes)
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
