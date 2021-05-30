//
//  LocationService.swift
//  Parkaroo
//
//  Created by Bernie Cartin on 5/28/21.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func locationReceived(location: CLLocation)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    private override init() {
        super.init()
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
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
        }
        else if CLLocationManager.authorizationStatus() == .denied {
            print("Denied")
            useDefaultLocation()
        }
        else {
            manager?.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.currentLocation = location
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.delegate?.locationReceived(location: location)
        }
    }
    
    func updateMapLocation() {
        if let location = self.currentLocation {
            self.delegate?.locationReceived(location: location)
        }
    }
    
    func useDefaultLocation() {
        let location = CLLocation(latitude: 40.758896, longitude: -73.985130)
        self.currentLocation = location
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
                
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            self?.delegate?.locationReceived(location: location)
        }
        
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
