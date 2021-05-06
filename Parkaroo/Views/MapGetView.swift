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
    var annotations1: [MKPointAnnotation]
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        return mapView
    }
    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations1.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations1)
        }
        if locationTransfer.logoTap {
            let coordinate = CLLocationCoordinate2D(latitude: 40.7812, longitude: -73.9665)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            view.setRegion(region, animated: true)
            locationTransfer.logoTap = false
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapGetView
        
        init(_ parent: MapGetView) {
            self.parent = parent
        }
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.locationTransfer.centerCoordinate1 = mapView.centerCoordinate
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.glyphImage = UIImage(named: "launch1")
            view.glyphTintColor = UIColor(named: "gray2")
            view.markerTintColor = UIColor(named: "orange1")
            return view
        }
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            self.parent.locationTransfer.readMinute()
            self.parent.gGRequestConfirm.showBox3 = true
        }
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            if !self.parent.gGRequestConfirm.moveBox {
                self.parent.gGRequestConfirm.showBox3 = false
            }
        }
    }
}
//struct MapGetView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapGetView(centerCoordinate: centerCoordinate)
//    }
//}
