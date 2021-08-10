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
                Text("Vehicle Color Make/Model")
                    .bold()
                    .font(.title)
                    .padding(.top, 50)
                TextField("e.g. Gray Toyota Camry", text: $user.vehicle)
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
                    if visable {
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
                            visable.toggle()
                        }) {
                            Image(systemName: visable ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(Color(.gray))
                                .font(.title2)
                                .padding(.trailing, 10)
                        }
                    }
                }.padding(.bottom, 100)
                Button(action: {
                    if user.isSignUpComplete {
                        FBAuth.createUser(withEmail: user.email, vehicle: user.vehicle, password: user.password) { (result) in
                            switch result {
                            case .failure(let error):
                                errorString = error.localizedDescription
                                showError = true
                            case .success( _):
                                presentationMode.wrappedValue.dismiss()
                                Analytics.logEvent("successful_sign_up", parameters: nil)
                                if locationTransfer.showOnBoarding && locationTransfer.isPresented {
                                    locationTransfer.isPresented = false
                                    LocationService.shared.checkLocationAuthStatus()
                                }
                            }
                        }
                        signUpClicked = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            signUpClicked = false
                        }
                    } else {
                        Analytics.logEvent("unsuccessful_sign_up", parameters: nil)
                        if !user.isVehicleValid() {
                            errorString = "Please enter a valid vehicle under 35 characters."
                        } else if user.containsProfanity() {
                            errorString = "Please enter a valid vehicle without any inappropriate language."
                        } else if !user.isEmailValid() {
                            if !user.isEmailNotContainingSpace() && !user.isEmailNotContainingUppercase() {
                                errorString = "Please enter a valid email without any spaces or uppercases."
                            } else if !user.isEmailNotContainingSpace() && user.isEmailNotContainingUppercase() {
                                errorString = "Please enter a valid email without any spaces."
                            } else if user.isEmailNotContainingSpace() && !user.isEmailNotContainingUppercase() {
                                errorString = "Please enter a valid email without any uppercases."
                            } else if user.isEmailNotContainingSpace() && user.isEmailNotContainingUppercase() {
                                errorString = "Please enter a valid email."
                            }
                        } else if !user.isPasswordValid() {
                            errorString = "Please enter a valid password with 6 or more characters containing at least one number."
                        }
                        showError = true
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
                }.disabled(signUpClicked)
                .alert(isPresented: $showError) {
                    Alert(title: Text("Error"), message: Text(errorString), dismissButton: .default(Text("Okay")))
                }
                if locationTransfer.showOnBoarding && locationTransfer.isPresented {
                    HStack {
                        Spacer()
                        Text("Already have an account?")
                        Button(action: {
                            showingLoginView = true
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
