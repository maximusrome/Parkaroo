//
//  AccountView.swift
//  Parkaroo
//
//  Created by max rome on 8/4/21.
//

import SwiftUI
import Firebase

struct AccountView: View {
    @EnvironmentObject var userInfo: UserInfo
    @State var user: UserViewModel = UserViewModel()
    @State private var showingSetUpAlert = false
    @State private var showingSavedAlert = false
    @State private var showError = false
    @State private var errorString = ""
    @State private var testVehicle = ""
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 80) {
                Text("Credits: \(userInfo.user.credits)")
                    .bold()
                    .padding(.top)
                    .alert(isPresented: $showingSavedAlert) {
                        Alert(title: Text("Saved"), dismissButton: .default(Text("Done")))
                    }
                Text("Rating: \(userInfo.user.numberOfRatings > 0 ? String(format: "%.2f", userInfo.user.rating) : "N/A")")
                    .bold()
                Text("Number of Ratings: \(userInfo.user.numberOfRatings > 0 ? String(userInfo.user.numberOfRatings) : "0")")
                    .bold()
                VStack(alignment: .leading) {
                    Text("Vehicle:")
                        .bold()
                        .alert(isPresented: $showingSetUpAlert) {
                            Alert(title: Text("Get Set Up"), message: Text("To save your vehicle you must have an account. Go to Sign Up or Login under the menu."), dismissButton: .default(Text("Okay")))
                        }
                    HStack {
                        TextField(Auth.auth().currentUser?.uid != nil ? userInfo.user.vehicle : "e.g. Gray Toyota Camry", text: $testVehicle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                            .font(.body)
                        Button(action: {
                            if Auth.auth().currentUser?.uid != nil {
                                if isVehicleComplete1 {
                                    saveVehicle()
                                } else {
                                    if !isVehicleValid1() {
                                        errorString = "Please enter a valid vehicle between 7 and 35 characters."
                                    } else if containsProfanity1() {
                                        errorString = "Please enter a valid vehicle without any inappropriate language."
                                    }
                                    showError.toggle()
                                }
                            } else {
                                showingSetUpAlert.toggle()
                            }
                        }) {
                            Text("Save")
                                .padding(.horizontal)
                                .alert(isPresented: $showError) {
                                    Alert(title: Text("Error"), message: Text(errorString), dismissButton: .default(Text("Okay")))
                                }
                        }
                    }
                }
                Text("App Version: \(appVersion)")
                    .bold()
                Spacer()
            }.font(.title)
                .padding()
                .navigationBarTitle("Account", displayMode: .inline)
        }
    }
    private func saveVehicle() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid ?? ""
        userInfo.user.vehicle = testVehicle
        db.collection("users").document(userID).updateData(["vehicle": userInfo.user.vehicle])
        showingSavedAlert.toggle()
        Analytics.logEvent("update_vehicle", parameters: nil)
    }
    private func isVehicleValid1() -> Bool {
        let vehicleTest = NSPredicate(format: "SELF MATCHES %@",
                                      "^([a-zA-Z0-9 /-]{7,35})$")
        return vehicleTest.evaluate(with: testVehicle)
    }
    private func containsProfanity1() -> Bool {
        return profanity.contains(where: testVehicle.contains)
    }
    var isVehicleComplete1: Bool {
        if  !isVehicleValid1() || containsProfanity1() {
            return false
        }
        return true
    }
    let profanity = ["shit","fuck","poop","ass","cunt","testicle","wanker","pussy","dick","twat","penis","vagina","bitch","bastard","damn","piss","hoser","slut","whore","fag","homo","shag","cock","crap","douche","bollocks","sod","arse","tits","boob","prick","pecker","bomb","anus","jizz","cum","fanny","tranny","anal","ballsack","blowjob","boner","butt","dildo","dyke","jerk","nigger","nigga","pube","scrotum","sex","spunk","bimbo","breast","hooker","horny","pedophile","lesbo","molest","moron","idiot","pimp","queer","wtf","turd","retard","rape","porn","pee","nazi","kkk","klan","honkey","kooch","kike","drugs","Shit","Fuck","Poop","Ass","Cunt","Testicle","Wanker","Pussy","Dick","Twat","Penis","Vagina","Bitch","Bastard","Damn","Piss","Hoser","Slut","Whore","Fag","Homo","Shag","Cock","Crap","Douche","Bollocks","Sod","Arse","Tits","Boob","Prick","Pecker","Bomb","Anus","Jizz","Cum","Fanny","Tranny","Anal","Ballsack","Blowjob","Boner","Butt","Dildo","Dyke","Jerk","Nigger","Nigga","Pube","Scrotum","Sex","Spunk","Bimbo","Breast","Hooker","Horny","Pedophile","Lesbo","Molest","Moron","Idiot","Pimp","Queer","Wtf","Turd","Retard","Rape","Porn","Pee","Nazi","Kkk","Klan","Honkey","Kooch","Kike","Drugs"]
}
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(UserInfo())
    }
}
