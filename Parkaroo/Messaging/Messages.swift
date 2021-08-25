//
//  Messages.swift
//  Parkaroo
//
//  Created by max rome on 8/4/21.
//

import SwiftUI
import Firebase

struct Messages: View {
    let chatroom: Chatroom
    @ObservedObject var viewModel = MessagesViewModel()
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var locationTransfer: LocationTransfer
    @Environment(\.presentationMode) var presentationMode
    @State private var messageField = ""
    @State private var receiver = ""
    @State private var showingInappropriateAlert = false
    init(chatroom: Chatroom) {
        self.chatroom = chatroom
        viewModel.fetchData(docId: chatroom.id)
    }
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollView in
                    ForEach(viewModel.messages) { message in
                        if message.sender == Auth.auth().currentUser?.uid {
                            HStack {
                                Spacer()
                                VStack {
                                    HStack {
                                        Spacer()
                                        Text(message.content)
                                            .padding(10)
                                            .background(Color("orange1"))
                                            .cornerRadius(20)
                                            .listRowInsets(EdgeInsets())
                                    }
                                    HStack {
                                        Spacer()
                                        Text(message.messageDate)
                                            .font(.footnote)
                                            .foregroundColor(Color("gray3"))
                                    }
                                }
                            }.padding(.horizontal)
                        } else {
                            HStack {
                                VStack {
                                    HStack {
                                        Text(message.content)
                                            .padding(10)
                                            .background(Color("gray3"))
                                            .cornerRadius(20)
                                            .listRowInsets(EdgeInsets())
                                        Spacer()
                                    }
                                    HStack {
                                        Text(message.messageDate)
                                            .font(.footnote)
                                            .foregroundColor(Color("gray3"))
                                        Spacer()
                                    }
                                }
                                Spacer()
                            }.padding(.horizontal)
                        }
                    }
                    .onChange(of: viewModel.messages) { message in
                        withAnimation {
                            scrollView.scrollTo(message.last?.id)
                        }
                    }
                }
            }.padding(.vertical)
            Spacer()
            HStack {
                TextField("Message", text: $messageField)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    if containsProfanityMessage() {
                        showingInappropriateAlert = true
                    } else {
                        findReceiver()
                        let date = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeStyle = .short
                        let newDate = dateFormatter.string(from: date)
                        viewModel.sendMessage(messageDate: newDate, messageContent: messageField, docId: chatroom.id, receiver: receiver)
                        messageField = ""
                        Analytics.logEvent("message_sent", parameters: nil)
                    }
                }) {
                    Image(systemName: "paperplane")
                        .imageScale(.large)
                        .foregroundColor(messageField == "" ? Color.gray : Color("orange1"))
                }.disabled(messageField == "")
                .alert(isPresented: $showingInappropriateAlert) {
                    Alert(title: Text("Inappropriate"), dismissButton: .default(Text("Okay")))
                }
            }.padding(.horizontal)
            .padding(.vertical, 5)
            .navigationBarTitle("Messages")
        }.onReceive(locationTransfer.updatePublisher, perform: { _ in
            if locationTransfer.showSellerCanceledView {
                presentationMode.wrappedValue.dismiss()
            }
        })
    }
    private func findReceiver() {
        if locationTransfer.givingPin?.buyer != nil {
            receiver = locationTransfer.givingPin?.buyer ?? ""
        } else if locationTransfer.gettingPin?.seller != nil {
            receiver = locationTransfer.gettingPin?.seller ?? ""
        } else {
            receiver = ""
        }
    }
    func containsProfanityMessage() -> Bool {
        return profanity.contains(where: messageField.contains)
    }
    let profanity = ["shit","fuck","poop","ass","cunt","testicle","wanker","pussy","dick","twat","penis","vagina","bitch","bastard","damn","piss","hoser","slut","whore","fag","homo","shag","cock","crap","douche","bollocks","sod","arse","tits","boob","prick","pecker","bomb","anus","jizz","cum","fanny","tranny","anal","ballsack","blowjob","boner","butt","dildo","dyke","jerk","nigger","nigga","pube","scrotum","sex","spunk","bimbo","breast","hooker","horny","pedophile","lesbo","molest","moron","idiot","pimp","queer","wtf","turd","retard","rape","porn","pee","nazi","kkk","klan","honkey","kooch","kike","drugs","Shit","Fuck","Poop","Ass","Cunt","Testicle","Wanker","Pussy","Dick","Twat","Penis","Vagina","Bitch","Bastard","Damn","Piss","Hoser","Slut","Whore","Fag","Homo","Shag","Cock","Crap","Douche","Bollocks","Sod","Arse","Tits","Boob","Prick","Pecker","Bomb","Anus","Jizz","Cum","Fanny","Tranny","Anal","Ballsack","Blowjob","Boner","Butt","Dildo","Dyke","Jerk","Nigger","Nigga","Pube","Scrotum","Sex","Spunk","Bimbo","Breast","Hooker","Horny","Pedophile","Lesbo","Molest","Moron","Idiot","Pimp","Queer","Wtf","Turd","Retard","Rape","Porn","Pee","Nazi","Kkk","Klan","Honkey","Kooch","Kike","Drugs"]
}
struct Messages_Previews: PreviewProvider {
    static var previews: some View {
        Messages(chatroom: Chatroom(id: "TIA3ccGOr4hRe5ceVNCo323TBIK2", sellerID: "0caoBuiG6uVN8oSYIONDaak5LMX2"))
            .environmentObject(UserInfo())
            .environmentObject(LocationTransfer())
    }
}
