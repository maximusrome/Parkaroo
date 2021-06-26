//
//  MapGiveView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//
import MapKit
import SwiftUI

struct MapGiveView: UIViewRepresentable {
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    var annotations: [MKPointAnnotation]
    let mapView = MKMapView()
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        centerMapOnCoordinate()
        return mapView
    }
    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations.count != (view.annotations.count - 1) {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
    }
    func centerMapOnCoordinate() {
        let coordinate = CLLocationCoordinate2D(latitude: 40.7812, longitude: -73.9665)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, MKMapViewDelegate, LocationServiceDelegate {
        func locationReceived(location: CLLocation) {
            centerMapOnCoordinate(coordinate: location.coordinate)
        }
        var parent: MapGiveView
        init(_ parent: MapGiveView) {
            self.parent = parent
            super.init()
            LocationService.shared.delegate = self
            if LocationService.shared.currentLocation != nil {
                LocationService.shared.updateMapLocation()
            }
        }
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.locationTransfer.centerCoordinate = mapView.centerCoordinate
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if !(annotation is MKUserLocation) {
                let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
                view.glyphImage = UIImage(named: "launch1")
                view.glyphTintColor = UIColor(named: "gray2")
                view.markerTintColor = UIColor(named: "orange1")
                return view
            }
            else {return nil}
        }
        fileprivate func centerMapOnCoordinate(coordinate: CLLocationCoordinate2D) {
            let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
            parent.mapView.setRegion(viewRegion, animated: true)
        }
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            userLocation.title = ""
        }
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            let userLocation = mapView.view(for: mapView.userLocation)
            userLocation?.isEnabled = false
        }
    }
}
