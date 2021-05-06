//
//  LocationTransfer.swift
//  Parkaroo
//
//  Created by max rome on 1/1/21.
//

import Foundation
import MapKit
import Firebase

class LocationTransfer: ObservableObject {
    @Published var pin = [Pin]()
    
    @Published var locations = [MKPointAnnotation]()
    @Published var locations1 = [MKPointAnnotation]()
    @Published var logoTap = true
    @Published var logoTap1 = true
    @Published var vehicle = ""
    @Published var vehicle1 = ""
    @Published var minute = ""
    @Published var minute1 = ""
    @Published var centerCoordinate = CLLocationCoordinate2D()
    @Published var centerCoordinate1 = CLLocationCoordinate2D()
    
    @Published var credits = 0
    
    func createPin() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("pins").document(userID).setData(["latitude": self.centerCoordinate.latitude, "longitude": self.centerCoordinate.longitude])
    }
    func readPin() {
        let db = Firestore.firestore()
        db.collection("pins").getDocuments() { (querySnapshot, err) in
            if err != nil {
                print("There was an error")
            } else {
                for document in querySnapshot!.documents {
                    self.centerCoordinate1.latitude = document["latitude"] as! Double
                    self.centerCoordinate1.longitude = document["longitude"] as! Double
                    print("coordinates read")
                }
            }
        }
    }
    func deletePin() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("pins").document(userID).delete()
    }
    func createCredit() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).setData(["credits": self.credits], merge: true)
    }
    func readCredit() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if err != nil {
                print("There was an error")
            } else {
                for document in querySnapshot!.documents {
                    self.credits = document["credits"] as? Int ?? 0
                    print("credits read")
                }
            }
        }
    }
    func updateCredit() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).updateData(["credits": self.credits])
    }
    func createMinute() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("pins").document(userID).setData(["minute": self.minute], merge: true)
    }
    func readMinute() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("pins").document(userID).getDocument { (document, error) in
            if error != nil {
                print("There was an error")
            } else {
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    self.minute1 = documentData?["minute"] as! String
                    print("minute read")
                } else {
                    print("doc doesn't exist or equals nil")
                }
            }
        }
    }
    func readVehicle() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).getDocument { (document, error) in
            if error != nil {
                print("There was an error")
            } else {
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    self.vehicle = documentData?["vehicle"] as! String
                    self.vehicle1 = documentData?["vehicle"] as! String
                    print("Vehicle read")
                } else {
                    print("vehicle doc doesn't exist or equals nil")
                }
            }
        }
    }
}
