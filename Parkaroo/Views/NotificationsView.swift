//
//  NotificationsView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
            ScrollView {
            VStack {
                Text("Notifications History")
                }
            }.navigationBarTitle("Notifications", displayMode: .inline)
    }
}
 /*   @State private var address = ""
    @State private var showAddressRadius = true
    @State private var showTimeFrame = true
    @State private var showCreditRecieved = true
    @State private var showReserveSpot = true
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Notify me when a spot is within a...")
                        .bold()
                        .padding(.top, 50)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .padding(.bottom, 30)
                        .font(.title)
                    HStack {
                        Text("Address Radius of")
                            .bold()
                            .padding(.leading, 20)
                            .font(.title3)
                        Toggle(isOn: $showAddressRadius) {
                        }
                        .padding(.trailing, 20)
                    }
                    TextField("e.g. 76th W 86th St", text: $address)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    HStack {
                        Text("Time Frame of")
                            .bold()
                            .padding(.leading, 20)
                            .font(.title3)
                        Toggle(isOn: $showTimeFrame) {
                        }
                        .padding(.trailing, 20)
                    }
                    .padding(.bottom, 30)
                    Text("When Credit is Received")
                        .bold()
                        .padding(.top, 50)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .font(.title)
                    Toggle(isOn: $showCreditRecieved) {
                    }
                    .padding(.trailing, 20)
                    Text("When Someone Reserves your Spot")
                        .bold()
                        .padding(.top, 50)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .font(.title)
                    Toggle(isOn: $showReserveSpot) {
                    }
                    .padding(.trailing, 20)
                    Spacer()
                }
                .navigationBarTitle("Notifications", displayMode: .inline)
            }
        }
    }
}*/
struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
