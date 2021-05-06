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
    @State var rating = 5
    @State private var showingOffMarketAlert = false
    @State private var showingMinuteOrDoneAlert = false
    @State private var showingMinuteAlert = false
    func abc() -> Bool {
        let minuteTest = NSPredicate(format: "SELF MATCHES %@",
                                     "^[0-9]+$")
        return minuteTest.evaluate(with: locationTransfer.minute)
    }
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .center) {
                HStack {
                    Text("Departure:")
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
                    Text("minutes")
                        .bold()
                }.padding(.top)
                Spacer()
                HStack {
                    Text("Your Rating:")
                        .bold()
                    RatingView(rating: $rating)
                }
                Spacer()
                HStack {
                    Button(action: {
                        self.showingOffMarketAlert = true
                    }){
                        Image(systemName: "trash")
                            .padding(.trailing, 15)
                    }.alert(isPresented: $showingOffMarketAlert) {
                        Alert(title: Text("Are you sure?"), message: Text("Delete your spot"), primaryButton: Alert.Button.default(Text("Yes"), action: {
                            UIApplication.shared.endEditing()
                            self.locationTransfer.locations.removeLast()
                            self.locationTransfer.locations1.removeLast()
                            self.gGRequestConfirm.moveBox = false
                            self.gGRequestConfirm.moveBox1 = false
                            self.gGRequestConfirm.showBox1 = false
                            self.gGRequestConfirm.showBox2 = false
                            self.gGRequestConfirm.showBox3 = false
                            self.gGRequestConfirm.showBox4 = false
                            self.locationTransfer.deletePin()
                        }), secondaryButton: Alert.Button.default(Text("No")))
                    }
                    Button(action: {
                        if abc() {
                            UIApplication.shared.endEditing()
                            self.locationTransfer.createMinute()
                            self.showingMinuteAlert = false
                            let db = Firestore.firestore()
                            db.collection("pins").getDocuments() { (querySnapshot, err) in
                                if err != nil {
                                    print("There was an error")
                                } else {
                                    for document in querySnapshot!.documents {
                                        self.locationTransfer.centerCoordinate1.latitude = document["latitude"] as! Double
                                        self.locationTransfer.centerCoordinate1.longitude = document["longitude"] as! Double
                                        print("coordinates read")
                                        let newLocation = MKPointAnnotation()
                                        newLocation.coordinate = self.locationTransfer.centerCoordinate1
                                        self.locationTransfer.locations1.append(newLocation)
                                        print("done")
                                    }
                                }
                            }
                        } else {
                            self.showingMinuteAlert = true
                        }
                        self.showingMinuteOrDoneAlert.toggle()
                    }) {
                        Text("Make Avaliable")
                            .bold()
                            .padding(10)
                            .background(Color("orange1"))
                            .cornerRadius(50)
                    }.alert(isPresented: $showingMinuteOrDoneAlert) {
                        if self.showingMinuteAlert {
                            return Alert(title: Text("Invalid Departure Time"), message: Text(""), dismissButton: .default(Text("Okay")))
                        } else {
                            return Alert(title: Text("Done"), message: Text("Now, wait for someone to reserve your spot. This screen will update when someone has reserved it."), dismissButton: .default(Text("Okay")))
                        }
                    }
                }.padding(.bottom)
            }.frame(width: 250, height: 150)
            .background(Color("white1"))
            .foregroundColor(Color("black1"))
            .cornerRadius(30)
            .shadow(radius: 5)
            .padding(.bottom)
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
    }
}
