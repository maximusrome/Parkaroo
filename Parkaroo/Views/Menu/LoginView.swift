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
                    if self.visable1 {
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
                            self.visable1.toggle()
                        }) {
                            Image(systemName: self.visable1 ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(Color(.gray))
                                .font(.title2)
                                .padding(.trailing, 5)
                        }
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        FBAuth.resetPassword(email: self.user.email) { (result) in
                            switch result {
                            case .failure(let error):
                                self.errString = error.localizedDescription
                            case .success( _):
                                break
                            }
                            self.showPasswordResetAlert = true
                        }
                    }) {
                        Text("Reset Password")
                            .bold()
                            .underline()
                            .padding(.top, 10)
                            .foregroundColor(Color("orange1"))
                            .padding(.bottom, 100)
                    }.alert(isPresented: $showPasswordResetAlert) {
                        Alert(title: Text("Password Reset"), message: Text(self.errString ?? "Password reset email sent successfully. Check your email."), dismissButton: .default(Text("Okay")))
                    }
                }
                Button(action: {
                    FBAuth.authenticate(withEmail: self.user.email, password: self.user.password) { (result) in
                        switch result {
                        case .failure(let error):
                            self.authError = error
                            self.showLoginAlert = true
                        case .success( _):
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    self.loginClicked = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.loginClicked = false
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
                }.disabled(self.loginClicked)
                .alert(isPresented: $showLoginAlert) {
                    Alert(title: Text("Error"), message: Text(self.authError?.localizedDescription ?? "Unknown error"), dismissButton: .default(Text("Okay")))
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
