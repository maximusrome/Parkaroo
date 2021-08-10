//
//  CreditsView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import Stripe
import SwiftUI
import StoreKit
import Firebase

struct CreditsView: View {
    @EnvironmentObject var userInfo: UserInfo
    @StateObject var viewModel = CreditsViewModel()
    @State private var showSignInAlert = false
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("Your Credits")
                    .bold()
                    .padding()
                Text("\(userInfo.user.credits)")
                    .bold()
                    .padding()
                Spacer()
                Text("Buy 1 Credit")
                    .bold()
                    .padding()
                if let paymentSheet = viewModel.paymentSheet {
                    PaymentSheet.PaymentButton(
                        paymentSheet: paymentSheet,
                        onCompletion: viewModel.onPaymentCompletion
                    ) {
                        Text("$8.99")
                            .bold()
                            .font(.title2)
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(Color("orange1"))
                            .cornerRadius(50)
                            .padding()
                    }
                } else {
                    Button(action: {
                        if Auth.auth().currentUser?.uid == nil {
                            showSignInAlert = true
                        }
                    }) {
                        Text("$8.99")
                            .bold()
                            .font(.title2)
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(Color("orange1"))
                            .cornerRadius(50)
                            .padding()
                    }
                }
                Spacer()
                Text("Or give a spot\nto earn a credit")
                    .bold()
                    .font(.title)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .onAppear {
                viewModel.preparePaymentSheet()
            }
            .onReceive(viewModel.$paymentResult) { result in
                guard let paymentStatus = result.map({ $0 }) else { return }
                switch paymentStatus {
                case .completed:
                    userInfo.AddOneCredit()
                case .canceled:
                    print("Payment was canceled")
                case .failed(error: let error):
                    print("Payment failed, reason: \(error)")
                }
            }
            .font(.title)
            .foregroundColor(Color("black1"))
            .navigationBarTitle("Credits", displayMode: .inline)
            .alert(isPresented: $showSignInAlert, content: {
                Alert(title: Text("Get Set Up"), message: Text("To buy a credit you must have an account. Go to Sign Up or Login under the menu."), dismissButton: Alert.Button.default(Text("Okay")))
            })
        }
    }
}
struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
            .environmentObject(UserInfo())
    }
}
