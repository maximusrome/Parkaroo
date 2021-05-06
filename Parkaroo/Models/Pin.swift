//
//  Pin.swift
//  Parkaroo
//
//  Created by max rome on 2/7/21.
//

import Foundation

struct Pin: Identifiable {
    let id = UUID()
    let minute: String
    let vehicle: String
    let longitude: Double
    let latitude: Double

}
