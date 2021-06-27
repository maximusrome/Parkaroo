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
                Text("Frequently Asked Questions")
                    .bold()
                    .font(.title)
                    .padding(.vertical)
                Text("How do I use the app?")
                    .bold()
                    .font(.title3)
                Text("The best source of info is in the Tutorial page under the menu. Or just email us and we'll be happy to answer all your questions.\n")
                Text("Should I tell my friends about this app?")
                    .bold()
                    .font(.title3)
                Text("Absolutely yes. The more people that use the app, the more spots that will be available, and hence a better experience for everyone.\n")
                Text("How do I get a credit?")
                    .bold()
                    .font(.title3)
                Text("The best way to get a credit is to give up a parking spot. We encourage this as it is a way to pay it forward (give up a spot now and get a spot in the future). As an alternative, you can purchase one in the Credits page under the menu.\n")
                Text("Does this app sell parking spots?")
                    .bold()
                    .font(.title3)
                Text("No, it does not. The app provides information that increases the odds of finding on-street parking spots. It does not guarantee that you will get a spot. But we hope it simplifies urban parking and makes your life much easier.\n")
                Group {
                    Text("What if the seller leaves the spot before I get there and the spot is gone?")
                        .bold()
                        .font(.title3)
                    Text("There is a button to refund your credit. You will be able to rate the seller. In this instance, we recommend giving the seller a low rating, so others in the future will know that he/she is less reliable than other sellers.\n")
                }
            }
        }.padding(.horizontal)
        .navigationBarTitle("Frequently Asked Questions", displayMode: .inline)
    }
}
struct FAQSView_Previews: PreviewProvider {
    static var previews: some View {
        FAQSView()
    }
}
