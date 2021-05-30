//
//  GiveConfirmView.swift
//  Parkaroo
//
//  Created by Bernie Cartin on 5/8/21.
//

import SwiftUI

struct GiveConfirmView: View {
    // MARK: PROPERTIES
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    @EnvironmentObject var locationTransfer: LocationTransfer
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var departureMinutes = Int()
    @Binding var presentRatingView: Bool
    @Binding var showConfirmView: Bool?
    @State var showCancelAlert = false
    
    // MARK: BODY
    
    var body: some View {
        VStack(alignment: .center){
            Text("Spot \(self.locationTransfer.givingPin?.status.capitalized ?? "")")
                .font(.title2)
                .bold()
                .padding(.top)
                .padding(.bottom, 8)
            
            Text("Departure in: \(departureMinutes >= 0 ? String(departureMinutes) + " Minutes" : "" )")
                .bold()
                .padding(.bottom, 8)
                .onReceive(timer, perform: { input in
                    let diff = Date().distance(to: self.locationTransfer.givingPin?.departure.dateValue() ?? Date())
                    departureMinutes = Int(diff / 60)
                    if departureMinutes < 0 {
                        if locationTransfer.buyer == nil {
                            locationTransfer.deletePin()
                            locationTransfer.minute = ""
                            locationTransfer.givingPin = nil
                            self.showConfirmView = false
                        }
                    }
                })
            
            if let buyer = locationTransfer.buyer {
                VStack {
                    Text("Buyer: \(buyer.vehicle)")
                        .padding(.bottom, 8)
                    
                    HStack {
                        Text("Rating: \(self.locationTransfer.buyer?.numberOfRatings ?? 0 > 0 ? (String(format: "%.2f", self.locationTransfer.buyer?.rating ?? 0)) : "N/A")")
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("orange1"))
                        Text("\(self.locationTransfer.buyer?.numberOfRatings ?? 0) ratings")
                            .font(.footnote)
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(Color.gray, lineWidth: 2)
                )
                
                Spacer()
                
                Button(action: {
                    self.showConfirmView = false
                    self.presentRatingView = true
                    self.locationTransfer.givingPin = nil
                    self.locationTransfer.locations.removeAll()
                }) {
                    Text("\(locationTransfer.givingPin?.ratingSubmitted ?? false ? "Complete Transfer" : "Waiting on Buyer")")
                        .bold()
                        .padding(10)
                        .background(locationTransfer.givingPin?.ratingSubmitted ?? false ? Color("orange1") : Color(white: 0.8))
                        .cornerRadius(50)
                        .padding(.top)
                }
                .padding(.bottom)
                .disabled(!(locationTransfer.givingPin?.ratingSubmitted ?? false))
                
                if !(locationTransfer.givingPin?.ratingSubmitted ?? false) {
                    Button(action: {
                        self.showCancelAlert = true
                    }) {
                        Text("Cancel")
                    }
                    .padding(.bottom)
                }
                
            }
            else {
                VStack {
                    Text("No Buyer")
                        .padding(.bottom, 8)
                    
                    Text("Wait for a buyer to earn a free credit")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(Color.gray, lineWidth: 2)
                )
                
                Spacer()
                
                Button(action: {
                    self.showCancelAlert = true
                }) {
                    Text("Cancel")
                        .bold()
                        .padding(10)
                        .background(Color(white: 0.8))
                        .cornerRadius(50)
                        .padding(.vertical)
                }
            }
            
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, minHeight: 250, maxHeight: 320)
        .padding(.horizontal)
        .background(Color("white1"))
        .foregroundColor(Color("black1"))
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.bottom)
        .padding(.horizontal, 48)
        .alert(isPresented: $locationTransfer.ratingSubmitted, content: {
            Alert(title: Text("Buyer Input Received"), message: Text("Complete the transfer to receive a free credit"), dismissButton: .default(Text("Ok")))
        })
        .alert(isPresented: $showCancelAlert, content: {
            Alert(title: Text("Are you sure?"), message: Text("The Buyer will be asked to rate you."), primaryButton: .default(Text("Yes"), action: {
                locationTransfer.deletePin()
                locationTransfer.minute = ""
                if let buyer = locationTransfer.buyer {
                    NotificationsService.shared.sendNotification(uid: buyer.uid, message: "The seller has canceled his spot")
                }
                self.showConfirmView = false
            }), secondaryButton: .cancel(Text("No")))
        })
        
    }
}

struct GiveConfirmView_Previews: PreviewProvider {
    @State static var presentView: Bool = false
    @State static var showConfirmView: Bool?
    static var previews: some View {
        GiveConfirmView(presentRatingView: $presentView, showConfirmView: $showConfirmView)
            .previewLayout(.sizeThatFits)
            .environmentObject(GGRequestConfirm())
            .environmentObject(LocationTransfer())
    }
}
