//
//  MapViewModel.swift
//  Gogo
//
//  Created by Xian Yin on 12/28/24.
//

import MapKit

class MapViewModel: ObservableObject {
    @Published var route: MKPolyline?

    func calculateRoute(start: String, end: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(start) { (startPlacemarks, error) in
            guard let startPlacemark = startPlacemarks?.first else { return }
            let startCoordinate = startPlacemark.location!.coordinate
            
            geocoder.geocodeAddressString(end) { (endPlacemarks, error) in
                guard let endPlacemark = endPlacemarks?.first else { return }
                let endCoordinate = endPlacemark.location!.coordinate
                
                let startMapItem = MKMapItem(placemark: MKPlacemark(coordinate: startCoordinate))
                let endMapItem = MKMapItem(placemark: MKPlacemark(coordinate: endCoordinate))
                
                let directionRequest = MKDirections.Request()
                directionRequest.source = startMapItem
                directionRequest.destination = endMapItem
                directionRequest.transportType = .automobile
                
                let directions = MKDirections(request: directionRequest)
                directions.calculate { (response, error) in
                    guard let route = response?.routes.first else { return }
                    DispatchQueue.main.async {
                        self.route = route.polyline
                    }
                }
            }
        }
    }
}
