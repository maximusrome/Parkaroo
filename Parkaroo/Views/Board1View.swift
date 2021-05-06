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
                Text("Parkaroo")
                    .bold()
                    .font(.title)
                    .padding(.bottom)
                Text("The Guru of Parking!\nSolving your street parking problems\nwhile helping your community.\n")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}

struct Board1View_Previews: PreviewProvider {
    static var previews: some View {
        Board1View()
    }
}
