//
//  CharityView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//

import SwiftUI

struct CharityView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Charity")
                    .bold()
                    .font(.title)
                    .padding(.vertical)
                Text("Here at Parkaroo we are dedicated to improving your community, in addition to reducing traffic in your area. We donate 10% of procedes from every parking spot given and recieved to charity. We don't just donate to a random charity, we donate to a charity in your community. For example, if you live on the Upper West Side of Manhattan, all procedes colleted on the Upper West Side go towards the charity Citymeals on Wheels. On the Upper East side we donate to Citymeals on Wheels. In the West Village we donate to Citymeals on Wheels. In the East village we donate to Citymeals on Wheels. In Brooklyn we donate to Citymeals on Wheels. In Queens we donate to Citymeals on Wheels. The more cities Parkaroo can reach the better our communities can be. Spread the word.")
                Text("About Us")
                    .bold()
                    .font(.title)
                    .padding(.vertical)
                Text("Parkaroo was founded by a 15 year old kid who was frustrated with the everyday 30 to 60 minutes wait for a parking spot on the Upper West Side in Manhattan. So, he began learning how to code and after eight months of work that problem had a solution, Parkaroo. Then for the first two months of the launch him and a few others got together and handed out flyers to people waiting in their cars during street cleaning hours. We handed out over 50,000 flyers. That is a little about us.")
                Spacer()
            }.padding()
            .navigationBarTitle("Charity", displayMode: .inline)
        }
    }
}
struct CharityView_Previews: PreviewProvider {
    static var previews: some View {
        CharityView()
    }
}
