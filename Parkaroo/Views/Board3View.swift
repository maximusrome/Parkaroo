//
//  Board3View.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI

struct Board3View: View {
    var body: some View {
        VStack {
            Text("Tutorial")
                .bold()
                .font(.title)
                .padding(.bottom)
            Text("We recommend spending a few minutes reading our tutorial for the best experience. Go to menu and click Tutorial.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
struct Board3View_Previews: PreviewProvider {
    static var previews: some View {
        Board3View()
    }
}
