//
//  LocationService.swift
//  Parkaroo
//
//  Created by max rome on 5/28/21.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func locationReceived(location: CLLocation, span: CLLocationDistance)
}
class LocationService: NSObject, CLLocationManagerDelegate {
    private override init() {
        super.init()
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.startUpdatingLocation()
    }
    static let shared = LocationService()
    var manager: CLLocationManager?
    var currentLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    func authorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    func authorize() {
        manager?.requestAlwaysAuthorization()
    }
    func checkLocationAuthStatus() {
        if (CLLocationManager.authorizationStatus() == .authorizedAlways) || (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            manager?.requestLocation()
        } else if CLLocationManager.authorizationStatus() == .denied {
            print("Denied")
            useDefaultLocation()
        } else {
            manager?.requestAlwaysAuthorization()
        }
    }
    func requestLocation() {
        if (CLLocationManager.authorizationStatus() == .authorizedAlways) || (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            manager?.requestLocation()
        } else {
            useDefaultLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.currentLocation = location
        _ = location.coordinate.latitude
        _ = location.coordinate.longitude
        self.delegate?.locationReceived(location: location, span: 300.0)
    }
    func updateMapLocation() {
        if let location = self.currentLocation {
            if (CLLocationManager.authorizationStatus() == .authorizedAlways) || (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
                self.delegate?.locationReceived(location: location, span: 300.0)
            } else {
                self.delegate?.locationReceived(location: location, span: 3000.0)
            }
        }
    }
    func useDefaultLocation() {
        let location = CLLocation(latitude: 40.7812, longitude: -73.9665)
        self.currentLocation = location
        _ = location.coordinate.latitude
        _ = location.coordinate.longitude
        self.delegate?.locationReceived(location: location, span: 3000.0)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clErr = error as? CLError {
            switch clErr {
            case CLError.locationUnknown:
                print("location unknown")
            case CLError.denied:
                print("denied")
            default:
                print("other Core Location error")
            }
        } else {
            print("other error:", error.localizedDescription)
        }
    }
}
