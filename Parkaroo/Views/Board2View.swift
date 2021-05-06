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
                Text("What is Parkaroo?")
                    .bold()
                    .font(.title)
                    .padding(.bottom)
                Text("Parkaroo connects you to a network of people in your city who all want to quickly find free street parking. We enable you to trade your spot for a credit which is used to reserve a spot in the future.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}

struct Board2View_Previews: PreviewProvider {
    static var previews: some View {
        Board2View()
    }
}
