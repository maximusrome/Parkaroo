//
//  ForceUpdateView.swift
//  Parkaroo
//
//  Created by max rome on 8/9/21.
//

import SwiftUI

struct ForceUpdateView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Update Parkaroo")
                    .bold()
                    .font(.title)
                    .padding(.top)
                Text("For the best experience and awesome new features update Parkaroo")
                    .padding(.vertical)
                    .multilineTextAlignment(.center)
                Divider()
                Link(destination: URL(string: "https://apps.apple.com/us/app/parkaroo/id1560506911")!) {
                    Text("Update")
                        .bold()
                        .padding(10)
                        .foregroundColor(Color("orange1"))
                }
            }.padding()
                .foregroundColor(Color("white2"))
                .background(Color("gray1"))
                .cornerRadius(15)
                .padding(.horizontal, 50)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("white1"))
        
    }
}

struct ForceUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        ForceUpdateView()
    }
}
