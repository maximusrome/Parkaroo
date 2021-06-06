//
//  LocationTransfer.swift
//  Parkaroo
//
//  Created by max rome on 1/1/21.
//

import Foundation
import MapKit
import Firebase
import Combine

class LocationTransfer: ObservableObject {
    @Published var pin = [Pin]()
    @Published var pins = [Pin]()
    @Published var locations = [MKPointAnnotation]()
    @Published var locations1 = [CustomMKPointAnnotation]()
    @Published var vehicle = ""
    @Published var vehicle1 = ""
    @Published var minute = ""
    @Published var minute1 = ""
    @Published var centerCoordinate = CLLocationCoordinate2D()
    @Published var centerCoordinate1 = CLLocationCoordinate2D()
    @Published var credits = 0
    @Published var departure = Timestamp()
    @Published var givingPin: Pin?
    @Published var gettingPin: Pin?
    @Published var buyer: FBUser?
    @Published var seller: FBUser?
    @Published var ratingSubmitted = false
    @Published var sellerCanceled = false
    var givingPinListener: ListenerRegistration?
    var gettingPinListener: ListenerRegistration?
    var publisher: AnyPublisher<Void, Never>! = nil
    let updatePublisher = PassthroughSubject<Void, Never>()
    func createPin() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        if let minuteDouble = Double(self.minute) {
            let departureTime = Date().addingTimeInterval(60.0 * (minuteDouble + 1))
            let departureTimeStamp = Timestamp(date: departureTime)
            var data = [String:Any]()
            data[C_ID] = userID
            data[C_LONGITUDE] = self.centerCoordinate.longitude
            data[C_LATITUDE] = self.centerCoordinate.latitude
            data[C_STATUS] = pinStatus.available.rawValue
            data[C_DEPARTURE] = departureTimeStamp
            data[C_SELLER] = userID
            data[C_RATINGSUBMITTED] = false
            db.collection(C_PINS).document(userID).setData(data)
            self.givingPin = Pin(data: data)
            self.fetchGivingPin()
            let annotation = MKPointAnnotation()
            annotation.coordinate = self.centerCoordinate
            self.locations.append(annotation)
        }
    }
    func updateGettingPin(data: [String:Any]) {
        if let gettingPin = gettingPin {
            let db = Firestore.firestore()
            db.collection(C_PINS).document(gettingPin.id).getDocument { snapshot, error in
                if error != nil {
                    print("There was an error")
                } else {
                    if snapshot?.exists ?? false {
                        db.collection(C_PINS).document(gettingPin.id).setData(data, merge: true)
                    }
                }
            }
        }
    }
    func readPin(id: String) {
        let db = Firestore.firestore()
        db.collection(C_PINS).document(id).getDocument { [weak self] documentSnapshot, error in
            if error != nil {
                print("There was an error")
            } else {
                guard var data = documentSnapshot?.data() else {
                    print("No Document")
                    return
                }
                if data[C_ID] == nil {
                    data[C_ID] = id
                }
                self?.gettingPin = Pin(data: data)
                self?.readSeller()
            }
        }
    }
    func readSeller() {
        guard let uid = self.gettingPin?.seller else {return}
        FBFirestore.retrieveFBUser(uid: uid) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                self?.seller = user
            }
        }
    }
    func deletePin() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("pins").document(userID).delete()
        self.givingPin = nil
        self.seller = nil
        self.buyer = nil
        self.locations.removeAll()
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
        if let minuteDouble = Double(self.minute) {
            let departureTime = Date().addingTimeInterval(60.0 * minuteDouble)
            let departureTimeStamp = Timestamp(date: departureTime)
            db.collection("pins").document(userID).setData(["minute": self.minute, "departure":departureTimeStamp], merge: true)
        }
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
                    self.departure = documentData?["departure"] as! Timestamp
                    print("minute read")
                } else {
                    print("doc doesn't exist or equals nil")
                }
            }
        }
    }
    func readVehicle(uid: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { (document, error) in
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
    func fetchLocations() {
        let db = Firestore.firestore()
        _ = db.collection(C_PINS).whereField("status", isEqualTo: "available").addSnapshotListener { [weak self] querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No Pins")
                return
            }
            self?.pins = documents.map { queryDocumentSnapshot in
                var data = queryDocumentSnapshot.data()
                data[C_ID] = queryDocumentSnapshot.documentID
                return Pin(data: data)
            }
            if let index = self?.pins.firstIndex(where: { pin in
                return pin.id == Auth.auth().currentUser?.uid
            }) {
                self?.pins.remove(at: index)
            }
            self?.locations1 = documents.map { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let latitude = data[C_LATITUDE] as? Double ?? 0.0
                let longitude = data[C_LONGITUDE] as? Double ?? 0.0
                let annotation = CustomMKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotation.id = queryDocumentSnapshot.documentID
                annotation.type = .normal
                return annotation
            }
            if let index = self?.locations1.firstIndex(where: { annotation in
                return annotation.id == Auth.auth().currentUser?.uid
            }) {
                self?.locations1.remove(at: index)
            }
        }
    }
    func fetchGivingPin() {
        if let listener = givingPinListener {
            listener.remove()
        }
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        givingPinListener = db.collection(C_PINS).document(userID).addSnapshotListener({ [weak self] documentSnapshot, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            if let data = documentSnapshot?.data() {
                var data = data
                if data[C_ID] == nil {
                    data[C_ID] = documentSnapshot?.documentID
                }
                self?.givingPin = Pin(data: data)
                self?.ratingSubmitted = data[C_RATINGSUBMITTED] as? Bool ?? false
                if let buyerID = data[C_BUYER] as? String, buyerID.count > 0 {
                    FBFirestore.retrieveFBUser(uid: buyerID) { [weak self] result in
                        switch result {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .success(let user):
                            self?.buyer = user
                        }
                    }
                } else {
                    self?.buyer = nil
                }
            }
        })
    }
    func fetchGettingPin(id: String) {
        if let listener = gettingPinListener {
            listener.remove()
        }
        let db = Firestore.firestore()
        gettingPinListener = db.collection(C_PINS).document(id).addSnapshotListener({ [weak self] documentSnapshot, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            if let data = documentSnapshot?.data() {
                var data = data
                if data[C_ID] == nil {
                    data[C_ID] = documentSnapshot?.documentID
                }
                self?.gettingPin = Pin(data: data)
            } else {
                self?.sellerCanceled = true
                self?.updatePublisher.send()
            }
        })
    }
    func cleanUpGettingPin() {
        if let listener = gettingPinListener {
            listener.remove()
        }
        self.gettingPin = nil
        self.seller = nil
        self.sellerCanceled = false
    }
    func fullCleanUp(completion: @escaping () -> Void) {
        if let listener = gettingPinListener {
            listener.remove()
        }
        if let listener = givingPinListener {
            listener.remove()
        }
        self.deletePin()
        if gettingPin != nil {
            let data = [C_BUYER:"", C_STATUS: pinStatus.available.rawValue]
            self.updateGettingPin(data: data)
            self.cleanUpGettingPin()
        }
        self.seller = nil
        self.sellerCanceled = false
        self.givingPin = nil
        self.buyer = nil
        self.locations.removeAll()
        self.locations1.removeAll()
        completion()
    }
}
class CustomMKPointAnnotation: MKPointAnnotation {
    var id: String!
    var type: pinType!
}
