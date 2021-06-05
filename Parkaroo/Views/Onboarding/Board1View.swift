//
//  Board1View.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI

struct Board1View: View {
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
                Image("onboard1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 50)
                    .padding(.bottom, 50)
                Text("Parkaroo")
                    .bold()
                    .font(.title)
                    .padding(.bottom)
                Text("Solving your street parking problems\nwhile helping your community.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Spacer()
            }
        }
    }
}
struct Board1View_Previews: PreviewProvider {
    static var previews: some View {
        Board1View()
    }
}
