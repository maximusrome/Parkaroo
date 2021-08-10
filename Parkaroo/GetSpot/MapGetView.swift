//
//  MapGetView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//
import MapKit
import SwiftUI
import Firebase

struct MapGetView: UIViewRepresentable {
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    var annotations1: [CustomMKPointAnnotation]
    let mapView = MKMapView()
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.isRotateEnabled = false
        return mapView
    }
    func updateUIView(_ view: MKMapView, context: Context) {
        var extra = 1
        if let annotation = locationTransfer.gettingAnnotation {
            extra = 2
            if view.view(for: annotation) == nil {
                view.addAnnotation(annotation)
            }
        }
        if LocationService.shared.locationAuthorized {
            if annotations1.count != (view.annotations.count - extra) {
                view.removeAnnotations(view.annotations)
                view.addAnnotations(annotations1)
            }
        } else {
            if annotations1.count != (view.annotations.count - extra + 1) {
                view.removeAnnotations(view.annotations)
                view.addAnnotations(annotations1)
            }
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, MKMapViewDelegate, LocationServiceDelegate {
        func locationReceived(location: CLLocation, span: CLLocationDistance) {
            centerMapOnCoordinate(coordinate: location.coordinate, span: span)
        }
        var parent: MapGetView
        init(_ parent: MapGetView) {
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
                if let annotation = annotation as? CustomMKPointAnnotation? {
                    let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
                    view.glyphImage = UIImage(named: "launch1")
                    view.glyphTintColor = UIColor(named: "gray2")
                    view.markerTintColor = UIColor(named: "orange1")
                    return view
                } else {
                    return nil
                }
            } else {
                let userAnnotation = mapView.view(for: annotation)
                userAnnotation?.canShowCallout = false
                userAnnotation?.isEnabled = false
                userAnnotation?.isUserInteractionEnabled = false
                return userAnnotation
            }
        }
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if !parent.gGRequestConfirm.showGetConfirmView && !parent.locationTransfer.showSellerCanceledView && !parent.gGRequestConfirm.showSellerRatingView {
                if let annotation = view.annotation as? CustomMKPointAnnotation {
                    parent.locationTransfer.readPin(id: annotation.id)
                    parent.locationTransfer.readStreetInfo(id: annotation.id)
                    parent.gGRequestConfirm.showGetRequestView = true
                    Analytics.logEvent("pin_read", parameters: nil)
                }
            }
        }
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            parent.gGRequestConfirm.showGetRequestView = false
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
