//
//  AccountView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gGRequestConfirm : GGRequestConfirm
    @EnvironmentObject var locationTransfer : LocationTransfer
    @State private var user: UserViewModel = UserViewModel()
    @State private var showLoginAlert = false
    @State private var authError: EmailAuthError?
    @State private var showPasswordResetAlert = false
    @State private var errString: String?
    @State private var visable1 = false
    @State private var loginClicked = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Email")
                    .bold()
                    .font(.title)
                    .padding(.top, 50)
                TextField("e.g. johnsmith@gmail.com", text: $user.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.bottom, 50)
                Text("Password")
                    .bold()
                    .font(.title)
                ZStack {
                    if visable1 {
                        TextField("e.g. Parkaroo21", text: $user.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                    } else {
                        SecureField("e.g. Parkaroo21", text: $user.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            visable1.toggle()
                        }) {
                            Image(systemName: visable1 ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(Color(.gray))
                                .font(.title2)
                                .padding(.trailing, 5)
                        }
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        FBAuth.resetPassword(email: user.email) { (result) in
                            switch result {
                            case .failure(let error):
                                errString = error.localizedDescription
                            case .success( _):
                                break
                            }
                            showPasswordResetAlert = true
                        }
                    }) {
                        Text("Reset Password")
                            .bold()
                            .underline()
                            .padding(.top, 10)
                            .foregroundColor(Color("orange1"))
                            .padding(.bottom, 100)
                    }.alert(isPresented: $showPasswordResetAlert) {
                        Alert(title: Text("Password Reset"), message: Text(errString ?? "Password reset email sent successfully. Check your email."), dismissButton: .default(Text("Okay")))
                    }
                }
                Button(action: {
                    FBAuth.authenticate(withEmail: user.email, password: user.password) { (result) in
                        switch result {
                        case .failure(let error):
                            authError = error
                            showLoginAlert = true
                            Analytics.logEvent("unsuccessful_login", parameters: nil)
                        case .success( _):
                            presentationMode.wrappedValue.dismiss()
                            Analytics.logEvent("successful_login", parameters: nil)
                            if locationTransfer.showOnBoarding && locationTransfer.isPresented {
                                presentationMode.wrappedValue.dismiss()
                                locationTransfer.isPresented = false
                                LocationService.shared.checkLocationAuthStatus()
                            }
                        }
                    }
                    loginClicked = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        loginClicked = false
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Login")
                            .bold()
                            .font(.title2)
                            .padding(10)
                            .padding(.horizontal)
                            .foregroundColor(Color("black1"))
                            .background(Color("orange1"))
                            .cornerRadius(50)
                        Spacer()
                    }
                }.disabled(loginClicked)
                .alert(isPresented: $showLoginAlert) {
                    Alert(title: Text("Error"), message: Text(authError?.localizedDescription ?? "Unknown error"), dismissButton: .default(Text("Okay")))
                }
            }
        }.padding()
        .navigationBarTitle("Login", displayMode: .inline)
    }
}
struct loginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(GGRequestConfirm())
            .environmentObject(LocationTransfer())
    }
}
