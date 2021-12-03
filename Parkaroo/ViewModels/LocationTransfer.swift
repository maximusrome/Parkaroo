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
    @Published var pins = [Pin]()
    @Published var locations = [MKPointAnnotation]()
    @Published var locations1 = [CustomMKPointAnnotation]()
    @Published var minute = ""
    @Published var centerCoordinate = CLLocationCoordinate2D()
    @Published var departure = Timestamp()
    @Published var givingPin: Pin?
    @Published var gettingPin: Pin?
    @Published var buyer: FBUser?
    @Published var seller: FBUser?
    @Published var ratingSubmitted = false
    @Published var showSellerCanceledView = false
    @Published var gettingAnnotation: CustomMKPointAnnotation?
    @Published var giveStreetInfoSelection: String = "Edit"
    @Published var getStreetInfoSelection: String = "Edit"
    @Published var isPresented = true
    @Published var showOnBoarding = false
    @Published var forceUpdate = false
    @Published var lastCompatibleVersion = 1.0
    @Published var sCoordinate = CLLocationCoordinate2D()
    @Published var parkPress = true
    @Published var rightTab = false
    @Published var firstTime = true
    var givingPinListener: ListenerRegistration?
    var gettingPinListener: ListenerRegistration?
    var publisher: AnyPublisher<Void, Never>! = nil
    let updatePublisher = PassthroughSubject<Void, Never>()
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    func createPin() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid ?? ""
        if let minuteDouble = Double(minute) {
            let departureTime = Date().addingTimeInterval(60.0 * (minuteDouble + 1))
            let departureTimeStamp = Timestamp(date: departureTime)
            var data = [String:Any]()
            data[C_ID] = userID
            data[C_LONGITUDE] = centerCoordinate.longitude
            data[C_LATITUDE] = centerCoordinate.latitude
            data[C_STATUS] = pinStatus.available.rawValue
            data[C_DEPARTURE] = departureTimeStamp
            data[C_SELLER] = userID
            data[C_RATINGSUBMITTED] = false
            data[C_STREETINFORMATION] = giveStreetInfoSelection
            db.collection(C_PINS).document(userID).setData(data)
            givingPin = Pin(data: data)
            fetchGivingPin()
            let annotation = MKPointAnnotation()
            annotation.coordinate = centerCoordinate
            locations.append(annotation)
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
    func readSaveLocation() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid ?? ""
        db.collection("users").document(userID).getDocument { (document, error) in
            if error != nil {
                print("There was an error")
            } else {
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    let latitude = documentData![C_SAVELATITUDE] as? Double ?? 0.0
                    let longitude = documentData![C_SAVELONGITUDE] as? Double ?? 0.0
                    self.sCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = self.sCoordinate
                    self.locations.append(annotation)
                } else {
                    print("save location doc doesn't exist or equals nil")
                }
            }
        }
    }
    func readSeller() {
        guard let uid = gettingPin?.seller else {return}
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
        let userID = Auth.auth().currentUser?.uid
        if Auth.auth().currentUser?.uid != nil {
            db.collection("pins").document(userID ?? "").delete()
            givingPin = nil
            locations.removeAll()
        }
    }
    func deleteSellerPin() {
        let db = Firestore.firestore()
        db.collection("pins").document(seller?.uid ?? "").delete()
        gettingPin = nil
        locations.removeAll()
    }
    func readStreetInfo(id: String) {
        let db = Firestore.firestore()
        db.collection(C_PINS).document(id).getDocument { (document, error) in
            if error != nil {
                print("There was an error")
            } else {
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    self.getStreetInfoSelection = documentData?["street_information"] as! String
                    print("street information read")
                } else {
                    print("street information doc doesn't exist or equals nil")
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
                self?.showSellerCanceledView = true
                self?.updatePublisher.send()
            }
        })
    }
    func cleanUpGettingPin() {
        if let listener = gettingPinListener {
            listener.remove()
        }
        gettingPin = nil
        showSellerCanceledView = false
    }
    func fullCleanUp(completion: @escaping () -> Void) {
        if let listener = gettingPinListener {
            listener.remove()
        }
        if let listener = givingPinListener {
            listener.remove()
        }
        deletePin()
        if gettingPin != nil {
            let data = [C_BUYER:"", C_STATUS: pinStatus.available.rawValue]
            updateGettingPin(data: data)
            cleanUpGettingPin()
        }
        seller = nil
        showSellerCanceledView = false
        givingPin = nil
        buyer = nil
        completion()
    }
    func addRefencePin() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = centerCoordinate
        locations.append(annotation)
    }
    func checkLastCompatibleVersion() {
        let db = Firestore.firestore()
        db.collection("version").document("last").getDocument { (document, error) in
            if error != nil {
                print("There was an error updating")
            } else {
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    self.lastCompatibleVersion = documentData?["last_compatible_version"] as! Double
                    if self.lastCompatibleVersion <= Double(self.appVersion) ?? 5.0 {
                        self.forceUpdate = false
                        print("dont show force update")
                    } else if self.lastCompatibleVersion > Double(self.appVersion) ?? 5.0 {
                        self.forceUpdate = true
                        print("show force update")
                    } else {
                        print("Error checking in force update")
                    }
                } else {
                    print("Not Updating")
                }
            }
        }
    }
}
class CustomMKPointAnnotation: MKPointAnnotation {
    var id: String!
    var type: pinType!
}
