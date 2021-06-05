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
                Text("Parkaroo is dedicated to improving your community. In addition to reducing local traffic, we donate a portion of proceeds to charity. Every parking spot you give and recieve helps others in need. Parkaroo recently launched in New York City, and we have selected the New York Care's charity to be our partner.\n")
                Text("New York Cars's is a reputable organization that does great work for all New Yorkers. New York Care's organizes food drives, clothing deliveries, tutoring, street clean up, park beautification, and more.\n")
                HStack {
                    Text("Charity Website:")
                        .padding(.trailing, 3)
                Link("New York Care's", destination: URL(string: "https://www.newyorkcares.org")!)
                }
                Text("About Us")
                    .bold()
                    .font(.title)
                    .padding(.vertical)
                Text("Hello, my name is Max, I am 15 years old and I created this app becuase my family was frustrated with the search for on-street parking in NYC. After school I learned how to code and began working on Parkaroo. After eight months we launched version 1.0.\n\nI hope this helps your search for parking, appreciate our dedication to charity and feel good about supporting a young entrepreneur.\n")
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
