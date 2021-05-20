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
    var signUpButtonColor: Color {
        return user.isSignUpComplete && !self.signUpClicked ? Color("orange1") : .gray
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Vehicle Color and Brand")
                    .bold()
                    .font(.title)
                    .padding(.top, 40)
                TextField("e.g. Red Honda", text: $user.vehicle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.words)
                Text(user.vehiclePrompt)
                    .foregroundColor(Color("orange1"))
                    .padding(.bottom, 50)
                Text("Email")
                    .bold()
                    .font(.title)
                TextField("e.g. johnsmith@gmail.com", text: $user.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .textCase(.lowercase)
                Text(user.emailPrompt)
                    .foregroundColor(Color("orange1"))
                    .fixedSize(horizontal: false, vertical: true)
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
                }
                Text(user.passwordPrompt)
                    .foregroundColor(Color("orange1"))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 50)
                Button(action: {
                    FBAuth.createUser(withEmail: self.user.email, vehicle: self.user.vehicle, password: self.user.password) { (result) in
                        switch result {
                        case .failure(let error):
                            self.errorString = error.localizedDescription
                            self.showError = true
                        case .success( _):
                            NotificationsService.shared.authorize()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    self.signUpClicked = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.signUpClicked = false
                    }
                }) {
                    Text("Sign Up")
                        .bold()
                        .font(.title)
                        .foregroundColor(signUpButtonColor)
                        .frame(maxWidth: .infinity, alignment: .center)
                }.disabled(!user.isSignUpComplete || self.signUpClicked)
                .alert(isPresented: $showError) {
                    Alert(title: Text("Error"), message: Text(self.errorString), dismissButton: .default(Text("Okay")))
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
