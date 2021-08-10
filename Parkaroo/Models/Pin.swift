//
//  Pin.swift
//  Parkaroo
//
//  Created by max rome on 2/7/21.
//

import Foundation
import MapKit
import FirebaseFirestore

struct Pin: Identifiable {
    let id: String
    let longitude: Double
    let latitude: Double
    let status: String
    let departure: Timestamp
    let seller: String
    var buyer: String?
    var ratingSubmitted = false
    init(data: [String:Any]) {
        id = data[C_ID] as! String
        longitude = data[C_LONGITUDE] as! Double
        latitude = data[C_LATITUDE] as! Double
        status = data[C_STATUS] as! String
        departure = data[C_DEPARTURE] as! Timestamp
        seller = data[C_SELLER] as! String
        if let buyer = data[C_BUYER] as? String {
            self.buyer = buyer
        }
        ratingSubmitted = data[C_RATINGSUBMITTED] as! Bool
    }
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
