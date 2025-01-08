//
//  LocationSearchViewModel.swift
//  GogoStudy
//
//  Created by Xian Yin on 12/29/24.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
    
    //MARK: properties
    //将属性标记为 @Published 后，任何订阅该属性的视图或对象都会在属性值变化时收到通知。
    //只有在 ObservableObject 类型中，Published 才能正常工作。
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedDestinationLocation: Location?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" { // 存储属性，初始值为空字符串
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion){
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("Debug: Location search failed with error \(error.localizedDescription)")
                return
            }
            
            guard let item = response?.mapItems.last else {return}
            let coordinate = item.placemark.coordinate
            self.selectedDestinationLocation = Location(title: localSearch.title, coordinate: coordinate)
            
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(forType type: RideType) -> Double {
        guard let coordinate = selectedDestinationLocation?.coordinate else { return 0.0}
        guard let userLocation = self.userLocation else { return 0.0}
        
        let userLocation1 = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let tripDistanceInMeters = userLocation1.distance(from: destination)
        return type.computePrice(for: tripDistanceInMeters)
    }
    
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                             to destination: CLLocationCoordinate2D,
                             completion: @escaping (MKRoute) -> Void){
        
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        let directions = MKDirections(request: request)
        
        directions.calculate {response, error in
            if let error = error {
                print("Debug: Failed t get directions with error \(error.localizedDescription)")
                return
            }
            guard let route = response?.routes.first else {return}
            self.configurePickupAndDropoffTimes(with: route.expectedTravelTime)
            completion(route)
        }
    }
    
    func configurePickupAndDropoffTimes(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        pickupTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravelTime)
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    //MKLocalSearchCompleter 的结果更新通知，并将结果同步到 LocationSearchViewModel 中
    //（例如 self.results 属性），从而用于更新用户界面中的搜索结果列表。
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
