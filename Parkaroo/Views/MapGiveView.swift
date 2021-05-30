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
//        centerMapOnCoordinate()
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations.count != (view.annotations.count - 1) {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
//        if locationTransfer.logoTap1 {
//            let coordinate = CLLocationCoordinate2D(latitude: 40.7812, longitude: -73.9665)
//            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//            let region = MKCoordinateRegion(center: coordinate, span: span)
//            view.setRegion(region, animated: true)
//            locationTransfer.logoTap1 = false
//        }
    }
    
//    func centerMapOnCoordinate() {
//        let coordinate = CLLocationCoordinate2D(latitude: 40.7812, longitude: -73.9665)
//        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        let region = MKCoordinateRegion(center: coordinate, span: span)
//        mapView.setRegion(region, animated: true)
//    }
    
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
                view.glyphTintColor = UIColor(named: "orange1")
                view.markerTintColor = UIColor(named: "gray2")
                return view
            }
            else {return nil}
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//            self.parent.gGRequestConfirm.showBox1 = true
        }
        
        fileprivate func centerMapOnCoordinate(coordinate: CLLocationCoordinate2D) {
            let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            parent.mapView.setRegion(viewRegion, animated: true)
        }
    }
}

//struct MapGiveView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapGiveView(centerCoordinate: .constant(MKPointAnnotation.example.coordinate), annotations: [MKPointAnnotation.example])
//    }
//}
