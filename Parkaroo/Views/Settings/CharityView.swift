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
                Text("Parkaroo is dedicated to improving your community. In addition to reducing local traffic, we donate a portion of proceeds to charity. Every parking spot you give and receive helps others in need. Parkaroo recently launched in New York City, and we have selected the New York Cares charity to be our partner.\n")
                Text("New York Cares is a reputable organization that does great work for all New Yorkers. New York Cares organizes food drives, clothing deliveries, tutoring, street clean up, park beautification, and more.\n")
                HStack {
                    Text("Charity Website:")
                    Link("New York Cares", destination: URL(string: "https://www.newyorkcares.org")!)
                }
                Text("About Us")
                    .bold()
                    .font(.title)
                    .padding(.vertical)
                Text("Hello, my name is Max, I am 15 years old and I created this app becuase my family was frustrated with the search for on-street parking in NYC. Each day, after school, I taught my self how to code and eight months later Parkaroo version 1.0 was launched.\n\nI hope this helps improve your parking experience, and makes you feel good about supporting a great charity and encouraging a young entrepreneur.\n")
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
