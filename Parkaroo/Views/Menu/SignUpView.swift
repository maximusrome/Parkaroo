//
//  SignUpView.swift
//  Parkaroo
//
//  Created by max rome on 11/26/20.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var locationTransfer : LocationTransfer
    @EnvironmentObject var gGRequestConfirm : GGRequestConfirm
    @State var user: UserViewModel = UserViewModel()
    @State private var showError = false
    @State private var errorString = ""
    @State private var visable = false
    @State private var signUpClicked = false
    @State private var showingLoginView = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Vehicle Color and Brand")
                    .bold()
                    .font(.title)
                    .padding(.top, 50)
                TextField("e.g. Red Honda", text: $user.vehicle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.words)
                    .padding(.bottom, 50)
                Text("Email")
                    .bold()
                    .font(.title)
                TextField("e.g. johnsmith@gmail.com", text: $user.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.bottom, 50)
                Text("Password")
                    .bold()
                    .font(.title)
                ZStack {
                    if self.visable {
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
                            self.visable.toggle()
                        }) {
                            Image(systemName: self.visable ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(Color(.gray))
                                .font(.title2)
                                .padding(.trailing, 10)
                        }
                    }
                }.padding(.bottom, 100)
                Button(action: {
                    if user.isSignUpComplete {
                        FBAuth.createUser(withEmail: self.user.email, vehicle: self.user.vehicle, password: self.user.password) { (result) in
                            switch result {
                            case .failure(let error):
                                self.errorString = error.localizedDescription
                                self.showError = true
                            case .success( _):
                                self.presentationMode.wrappedValue.dismiss()
                                Analytics.logEvent("successful_sign_up", parameters: nil)
                                if self.locationTransfer.showOnBoarding && self.locationTransfer.isPresented {
                                    self.locationTransfer.isPresented = false
                                    LocationService.shared.checkLocationAuthStatus()
                                }
                            }
                        }
                        self.signUpClicked = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.signUpClicked = false
                        }
                    } else {
                        Analytics.logEvent("unsuccessful_sign_up", parameters: nil)
                        if !user.isVehicleValid() {
                            self.errorString = "Please enter a valid vehicle color and brand under 25 characters."
                        } else if user.containsProfanity() {
                            self.errorString = "Please enter a valid vehicle color and brand without any inappropriate language."
                        } else if !user.isEmailValid() {
                            if !user.isEmailNotContainingSpace() && !user.isEmailNotContainingUppercase() {
                                self.errorString = "Please enter a valid email without any spaces or uppercases."
                            } else if !user.isEmailNotContainingSpace() && user.isEmailNotContainingUppercase() {
                                self.errorString = "Please enter a valid email without any spaces."
                            } else if user.isEmailNotContainingSpace() && !user.isEmailNotContainingUppercase() {
                                self.errorString = "Please enter a valid email without any uppercases."
                            } else if user.isEmailNotContainingSpace() && user.isEmailNotContainingUppercase() {
                                self.errorString = "Please enter a valid email."
                            }
                        } else if !user.isPasswordValid() {
                            self.errorString = "Please enter a valid password with 6 or more characters containing at least one number."
                        }
                        self.showError = true
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Sign Up")
                            .bold()
                            .font(.title2)
                            .padding(10)
                            .padding(.horizontal)
                            .foregroundColor(Color("black1"))
                            .background(Color("orange1"))
                            .cornerRadius(50)
                        Spacer()
                    }
                }.disabled(self.signUpClicked)
                .alert(isPresented: $showError) {
                    Alert(title: Text("Error"), message: Text(self.errorString), dismissButton: .default(Text("Okay")))
                }
                if self.locationTransfer.showOnBoarding && self.locationTransfer.isPresented {
                    HStack {
                        Spacer()
                        Text("Already have an account?")
                        Button(action: {
                            self.showingLoginView = true
                        }) {
                            Text("Login")
                        }.sheet(isPresented: $showingLoginView) {
                            LoginView()
                        }
                        Spacer()
                    }.padding()
                }
            }
        }.padding()
        .navigationBarTitle("Sign Up", displayMode: .inline)
    }
}
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(GGRequestConfirm())
            .environmentObject(LocationTransfer())
    }
}
