//
//  Board2View.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI

struct Board2View: View {
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
                Spacer()
                Spacer()
                Image("onboard2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 50)
                    .padding(.bottom, 50)
                Text("What is Parkaroo?")
                    .bold()
                    .font(.title)
                    .padding(.bottom)
                Text("Parkaroo connects you to a network of people in your city who give and get on-street parking spots.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Spacer()
            }
        }
    }
}
struct Board2View_Previews: PreviewProvider {
    static var previews: some View {
        Board2View()
    }
}
