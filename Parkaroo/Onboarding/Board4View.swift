//
//  Board4View.swift
//  Parkaroo
//
//  Created by max rome on 7/25/21.
//

import SwiftUI
import Firebase

struct Board4View: View {
    @EnvironmentObject var locationTransfer: LocationTransfer
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Rectangle()
                    .foregroundColor(Color("white1"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
            }
            VStack {
                ZStack {
                    HStack {
                        Text("Sign Up")
                            .bold()
                            .font(.title)
                            .padding()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            self.locationTransfer.isPresented = false
                            Analytics.logEvent("next", parameters: nil)
                            LocationService.shared.checkLocationAuthStatus()
                        }) {
                            Text("Next")
                                .foregroundColor(Color("orange1"))
                                .padding()
                        }
                    }
                }
                SignUpView()
            }
        }
    }
}
struct Board4View_Previews: PreviewProvider {
    static var previews: some View {
        Board4View()
            .environmentObject(LocationTransfer())
    }
}
