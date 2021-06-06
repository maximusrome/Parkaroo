//
//  Board3View.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI

struct Board3View: View {
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
                Image("onboard3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 100)
                    .padding(.bottom, 50)
                Text("Tutorial")
                    .bold()
                    .font(.title)
                    .padding(.bottom)
                Text("We recommend looking through our tutorial for the best experience. Go to Tutorial under menu.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Spacer()
            }
        }
    }
}
struct Board3View_Previews: PreviewProvider {
    static var previews: some View {
        Board3View()
    }
}
