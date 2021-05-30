//
//  HelpView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//
import SwiftUI

struct FAQSView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("FAQ's")
                    .bold()
                    .font(.title)
                    .padding(.vertical)
                Text("How do I use the app?")
                    .bold()
                    .font(.title3)
                Text("Go to the tutorial page under menu and you will find all the documentation you will ever need about how to use Parkaroo.\n")
                Text("Will tell my friends about this app lower the odds of me getting a spot?")
                    .bold()
                    .font(.title3)
                Text("You should tell your friends about this app, the more people are on the app the more spots that are avaliable, hence enhancing your overall experience on the app.\n")
                Text("Do I have to give up my spot to get a credit or is there another way?")
                    .bold()
                    .font(.title3)
                Text("You don't, if you only want to get spots you can purchase a credit to save the most amount of time.\n")
                Group {
                    Text("Is this app legal?")
                        .bold()
                        .font(.title3)
                    Text("Yes, this app is 100% legal. Trading information for a parking spot is legal.\n")
                    Text("What if someone leaves the spot before I get there and there is another car in the spot?")
                        .bold()
                        .font(.title3)
                    Text("There is a button, to completely refund your credit and your transaction fee. You will also be able to rate the seller, we recommend giving him/her a bad rating, so others know that person is not reliable.\n")
                    Text("Is my personal data being collected?")
                        .bold()
                        .font(.title3)
                    Text("No, we are not collect any person data on anyone using the app.\n")
                    Text("Can I make money from this app?")
                        .bold()
                        .font(.title3)
                    Text("No, but you can earn credits which you can use to get a spot.")
                }
            }
        }.padding(.horizontal)
        .navigationBarTitle("Help", displayMode: .inline)
    }
}
struct FAQSView_Previews: PreviewProvider {
    static var previews: some View {
        FAQSView()
    }
}
