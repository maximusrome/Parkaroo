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
        mapView.showsUserLocation = true
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        return mapView
    }
    func updateUIView(_ view: MKMapView, context: Context) {
        if LocationService.shared.locationAuthorized {
            if annotations.count != (view.annotations.count - 1) {
                view.removeAnnotations(view.annotations)
                view.addAnnotations(annotations)
            }
        } else {
            if annotations.count != view.annotations.count {
                view.removeAnnotations(view.annotations)
                view.addAnnotations(annotations)
            }
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, MKMapViewDelegate, LocationServiceDelegate1 {
        func locationReceived(location: CLLocation, span: CLLocationDistance) {
            centerMapOnCoordinate(coordinate: location.coordinate, span: span)
        }
        var parent: MapGiveView
        init(_ parent: MapGiveView) {
            self.parent = parent
            super.init()
            LocationService1.shared.delegate = self
            if LocationService1.shared.currentLocation != nil {
                LocationService1.shared.updateMapLocation()
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
        fileprivate func centerMapOnCoordinate(coordinate: CLLocationCoordinate2D, span: CLLocationDistance) {
            let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: span, longitudinalMeters: span)
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
