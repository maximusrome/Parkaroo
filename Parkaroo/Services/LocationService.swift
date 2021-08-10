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
    var locationAuthorized = false
    var locationNotDetermined = false
    var locationDenied = false
    static let shared = LocationService()
    var manager: CLLocationManager?
    var currentLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    func checkLocationAuthStatus() {
        if locationAuthorized {
            manager?.requestLocation()
        } else if locationDenied {
            print("Denied")
            useDefaultLocation()
        } else {
            manager?.requestAlwaysAuthorization()
        }
    }
    func requestLocation() {
        if locationAuthorized {
            manager?.requestLocation()
        } else {
            useDefaultLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        currentLocation = location
        _ = location.coordinate.latitude
        _ = location.coordinate.longitude
        delegate?.locationReceived(location: location, span: 300.0)
        self.manager?.stopUpdatingLocation()
    }
    func updateMapLocation() {
        if let location = currentLocation {
            if locationAuthorized {
                delegate?.locationReceived(location: location, span: 300.0)
            } else {
                delegate?.locationReceived(location: location, span: 3000.0)
            }
        }
    }
    func useDefaultLocation() {
        let location = CLLocation(latitude: 40.7812, longitude: -73.9665)
        currentLocation = location
        _ = location.coordinate.latitude
        _ = location.coordinate.longitude
        delegate?.locationReceived(location: location, span: 3000.0)
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
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationAuthorized = true
            locationNotDetermined = false
            locationDenied = false
        case .notDetermined:
            locationNotDetermined = true
            locationAuthorized = false
            locationDenied = false
        case .denied:
            locationDenied = true
            locationNotDetermined = false
            locationAuthorized = false
        default:
            break
        }
    }
}
protocol LocationServiceDelegate1 {
    func locationReceived(location: CLLocation, span: CLLocationDistance)
}
class LocationService1: NSObject, CLLocationManagerDelegate {
    private override init() {
        super.init()
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.startUpdatingLocation()
    }
    static let shared = LocationService1()
    var manager: CLLocationManager?
    var currentLocation: CLLocation?
    var delegate: LocationServiceDelegate1?
    func requestLocation() {
        if LocationService.shared.locationAuthorized {
            manager?.requestLocation()
        } else {
            useDefaultLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        currentLocation = location
        _ = location.coordinate.latitude
        _ = location.coordinate.longitude
        delegate?.locationReceived(location: location, span: 300.0)
        self.manager?.stopUpdatingLocation()
    }
    func updateMapLocation() {
        if let location = currentLocation {
            if LocationService.shared.locationAuthorized {
                delegate?.locationReceived(location: location, span: 300.0)
            } else {
                delegate?.locationReceived(location: location, span: 3000.0)
            }
        }
    }
    func useDefaultLocation() {
        let location = CLLocation(latitude: 40.7812, longitude: -73.9665)
        currentLocation = location
        _ = location.coordinate.latitude
        _ = location.coordinate.longitude
        delegate?.locationReceived(location: location, span: 3000.0)
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

