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
    var loginButtonColor: Color {
        return user.isLoginComplete && !self.loginClicked ? Color("orange1") : .gray
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Email")
                    .bold()
                    .padding(.top, 40)
                    .font(.title)
                TextField("e.g. johnsmith@gmail.com", text: $user.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                Text(user.emailPrompt)
                    .foregroundColor(Color("orange1"))
                    .fixedSize(horizontal: false, vertical: true)
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
                Text(user.passwordPrompt)
                    .foregroundColor(Color("orange1"))
                    .fixedSize(horizontal: false, vertical: true)
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
                            .padding(.bottom, 50)
                    }.alert(isPresented: $showPasswordResetAlert) {
                        Alert(title: Text("Password Reset"), message: Text(self.errString ?? "Password reset email sent successfully. Check your email."), dismissButton: .default(Text("Okay")))
                    }
                }
            }.font(.body)
            .padding()
            VStack(alignment: .center) {
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
                    Text("Log In")
                        .bold()
                        .font(.title)
                        .padding(.bottom, 5)
                        .foregroundColor(loginButtonColor)
                }.disabled(!user.isLoginComplete || self.loginClicked)
                .alert(isPresented: $showLoginAlert) {
                    Alert(title: Text("Login Error"), message: Text(self.authError?.localizedDescription ?? "Unknown error"), dismissButton: .default(Text("Okay")))
                }
            }
        }.navigationBarTitle("Login", displayMode: .inline)
    }
}
struct loginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(GGRequestConfirm())
            .environmentObject(LocationTransfer())
    }
}
