//
//  LocationManager.swift
//  GogoStudy
//
//  Created by Xian Yin on 12/29/24.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var currentAddress: String = "正在获取地址..." // 默认地址
    
    override init() {
        super.init()
        locationManager.delegate = self
        //kCLLocationAccuracyNearestTenMeters：精确到 10 米以内。
        //kCLLocationAccuracyKilometer：精确到 1 公里。
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //kCLLocationAccuracyBest 是最高精度的常量，表示希望位置数据尽可能准确
        locationManager.requestWhenInUseAuthorization()
        //开始监听位置更新  如果只需要一次位置数据，可以使用 requestLocation()，这样会触发一次位置更新并自动停止。
        locationManager.startUpdatingLocation()
    }
    
//    // 反向地理编码
//    private func reverseGeocodeLocation(_ location: CLLocationCoordinate2D) {
//        let geocoder = CLGeocoder()
//        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
//
//        geocoder.reverseGeocodeLocation(clLocation) { placemarks, error in
//            if let placemark = placemarks?.first {
//                let street = placemark.thoroughfare ?? "未知街道"
//                let city = placemark.locality ?? "未知城市"
//                let state = placemark.administrativeArea ?? ""
//                address = "\(street), \(city), \(state)"
//            } else if let error = error {
//                address = "地址解析失败: \(error.localizedDescription)"
//            }
//        }
//    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    // 当位置更新时，这个方法会被调用
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        
        //位置更新回调（didUpdateLocations）通常在后台线程调用，但 UI 更新（例如修改 @Published 属性或界面）必须在主线程上完成，否则会引发线程冲突或崩溃。
        DispatchQueue.main.async {
                self.userLocation = location.coordinate // 更新用户当前位置
                self.reverseGeocode(location: location) // 反向地理编码，获取当前位置的地址
        }
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("定位失败: \(error.localizedDescription)")
        self.currentAddress = "无法获取当前位置"
    }
    
    func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                let street = placemark.thoroughfare ?? "未知街道"
                let city = placemark.locality ?? "未知城市"
                let state = placemark.administrativeArea ?? ""
                self.currentAddress = "\(street), \(city), \(state)"
            } else if let error = error {
                print("反向地理编码失败: \(error.localizedDescription)")
                self.currentAddress = "地址获取失败"
            }
        }
    }
}
