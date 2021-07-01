//
//  CreditsView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI
import StoreKit

struct CreditsView: View {
    @EnvironmentObject var userInfo: UserInfo
    @State private var showSignInAlert = false
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("Your Credits")
                    .bold()
                    .padding()
                Text("\(String(self.userInfo.user.credits))")
                    .bold()
                    .padding()
                Spacer()
                Text("Buy 1 Credit")
                    .bold()
                    .padding()
                Button(action: {
                    if userInfo.isUserAuthenticated == .signedIn {
                        
                        //ADD PAYMENT METHODS HERE
                        
                    } else {
                        self.showSignInAlert = true
                    }
                }) {
                    Text("$9.99")
                        .bold()
                        .font(.title2)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color("orange1"))
                        .cornerRadius(50)
                        .padding()
                }.alert(isPresented: $showSignInAlert, content: {
                    Alert(title: Text("Get Set Up"), message: Text("To buy a credit you must have an account. Go to Sign Up or Login under the menu."), dismissButton: Alert.Button.default(Text("Okay")))
                })
                Spacer()
            }.font(.title)
            .foregroundColor(Color("black1"))
            .navigationBarTitle("Credits", displayMode: .inline)
        }
    }
}
struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
            .environmentObject(UserInfo())
            .environmentObject(IAPManager())
    }
}
