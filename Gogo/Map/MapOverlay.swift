//
//  MapOverlay.swift
//  Gogo
//
//  Created by Xian Yin on 12/28/24.
//
import SwiftUI
import MapKit


struct MapOverlay: UIViewRepresentable {
    
    var route: MKPolyline?
    @Binding var centerCoordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // 如果绑定的中心坐标发生变化，更新地图的中心
        uiView.setCenter(centerCoordinate, animated: true)
        
        uiView.removeOverlays(uiView.overlays)
        
        if let route = route {
            uiView.addOverlay(route)
            uiView.setVisibleMapRect(route.boundingMapRect, animated: true)
        }
    }
}
