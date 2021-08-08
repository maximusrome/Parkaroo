//
//  MessagesViewModel.swift
//  Parkaroo
//
//  Created by max rome on 8/4/21.
//

import Foundation
import Firebase

struct Message: Codable, Identifiable, Equatable {
    var id: String?
    var content: String
    var messageDate: String
    var sender: String
}
class MessagesViewModel: ObservableObject {
    @Published var messages = [Message]()
    private let db = Firestore.firestore()
    private let userID = Auth.auth().currentUser
    func sendMessage(messageDate: String, messageContent: String, docId: String, receiver: String) {
        if userID != nil {
            db.collection("chatrooms").document(docId).collection("messages").addDocument(data: [
                                                                                            "messageDate": messageDate,
                                                                                            "sentAt": Date(),
                                                                                            "content": messageContent,
                                                                                            "sender": userID!.uid])
            NotificationsService.shared.sendN(uid: receiver, message: "New Message\n" + messageContent)
        }
    }
    func fetchData(docId: String) {
        if userID != nil {
            db.collection("chatrooms").document(docId).collection("messages").order(by: "sentAt", descending: false).addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("no documents")
                    return
                }
                self.messages = documents.map { docSnapshot -> Message in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let content = data["content"] as? String ?? ""
                    let messageDate = data["messageDate"] as? String ?? ""
                    let sender = data["sender"] as? String ?? ""
                    return Message(id: docId, content: content, messageDate: messageDate, sender: sender)
                }
            })
        }
    }
}
