//
//  ChatroomsViewModel.swift
//  Parkaroo
//
//  Created by max rome on 8/4/21.
//

import Foundation
import Firebase

struct Chatroom: Codable, Identifiable {
    var id: String
    var sellerID: String
}
class ChatroomsViewModel: ObservableObject {
    @Published var chatrooms = [Chatroom]()
    @Published var docID = " "
    private let db = Firestore.firestore()
    private let userID = Auth.auth().currentUser
    func fetchData() {
        if userID != nil {
            db.collection("chatrooms").whereField("users", arrayContains: userID!.uid).addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print ("no docs returned!")
                    return
                }
                self.chatrooms = documents.map({docSnapshot -> Chatroom in
                    let data = docSnapshot.data()
                    self.docID = docSnapshot.documentID
                    let sellerID = data["sellerID"] as? String ?? ""
                    return Chatroom(id: self.docID, sellerID: sellerID)
                })
            })
        }
    }
    func createChatroom(sellerID: String) {
        if userID != nil {
            db.collection("chatrooms").document().setData([
                "users": [userID!.uid, sellerID]]) { err in
                    if let err = err {
                        print("error adding document! \(err)")
                    }
                }
        }
    }
    func deleteChatroom() {
        if userID != nil {
            db.collection("chatrooms").whereField("users", arrayContains: userID!.uid).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                }
            }
        }
    }
}
