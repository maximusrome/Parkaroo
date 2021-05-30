//
//  MapGetView.swift
//  Parkaroo
//
//  Created by max rome on 11/22/20.
//
import MapKit
import SwiftUI

struct MapGetView: UIViewRepresentable {
    @EnvironmentObject var locationTransfer: LocationTransfer
    @EnvironmentObject var gGRequestConfirm: GGRequestConfirm
    
    @Binding var gettingPinAnnotation: CustomMKPointAnnotation?
    
    var annotations1: [CustomMKPointAnnotation]
    
    let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.isRotateEnabled = false
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations1.count != (view.annotations.count - 1) {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations1)
        }
        if let annotation = gettingPinAnnotation {
            view.addAnnotation(annotation)
        }
//        if locationTransfer.logoTap {
//            let coordinate = CLLocationCoordinate2D(latitude: 40.7812, longitude: -73.9665)
//            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//            let region = MKCoordinateRegion(center: coordinate, span: span)
//            view.setRegion(region, animated: true)
//            locationTransfer.logoTap = false
//        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, LocationServiceDelegate {
        
        func locationReceived(location: CLLocation) {
            centerMapOnCoordinate(coordinate: location.coordinate)
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
            parent.locationTransfer.centerCoordinate1 = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if !(annotation is MKUserLocation) {
                if let annotation = annotation as? CustomMKPointAnnotation? {
                    let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
                    view.glyphImage = UIImage(named: "launch1")
                    view.glyphTintColor = annotation?.type == .normal ? UIColor(named: "gray2") : UIColor(named: "orange1")
                    view.markerTintColor = annotation?.type == .normal ? UIColor(named: "orange1") : UIColor(named: "gray2")
                    return view
                }
                else {
                    return nil
                }
            }
            else {return nil}
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            
            if let annotation = view.annotation as? CustomMKPointAnnotation {
                self.parent.locationTransfer.readPin(id: annotation.id)
                self.parent.gGRequestConfirm.showBox3 = true
            }
            
            
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            if !self.parent.gGRequestConfirm.moveBox {
                self.parent.gGRequestConfirm.showBox3 = false
            }
        }
        
        fileprivate func centerMapOnCoordinate(coordinate: CLLocationCoordinate2D) {
            let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            parent.mapView.setRegion(viewRegion, animated: true)
        }
    }
}
//struct MapGetView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapGetView(centerCoordinate: centerCoordinate)
//    }
//}
