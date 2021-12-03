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
                Text("Get a credit by giving up a parking spot or by purchasing one on the Credits page under the menu.\n")
                Text("Does this app sell parking spots?")
                    .bold()
                    .font(.title3)
                Text("No, it does not. The app provides information that increases the odds of finding on-street parking spots. It does not guarantee that you will get a spot. But we hope it simplifies urban parking and makes your life much easier.\n")
                Group {
                    Text("What if the seller leaves the spot before I get there and the spot is gone?")
                        .bold()
                        .font(.title3)
                    Text("You will be able to rate the seller. In this instance, we recommend giving the seller a low rating, so others in the future will know that he/she is less reliable than other sellers. In additon, you can always contact us to refund your credit.\n")
                    Text("How much time should I leave for a person to reserve my spot?")
                        .bold()
                        .font(.title3)
                    Text("We recommend entering a departure time between 15 to 60 minutes. This will give a neighbor plenty of time to get to your spot.\n")
                    Text("Should I wait for the buyer to arrive?")
                        .bold()
                        .font(.title3)
                    Text("Generally, you will not need to wait because the buyer will already be next to your spot before you are ready to leave. However, if the buyer is late you should wait a few minutes because you get a credit when someone successfully gets your spot.\n")
                    Text("How can I stay up to date on Parkaroo News?")
                        .bold()
                        .font(.title3)
                    Text("We have a parkaroo instagram, @parkaroonyc, a facebook page, as well as a website where you can subscribe to our email list.\n")
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
