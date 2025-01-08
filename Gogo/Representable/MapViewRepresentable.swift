//
//  UberMapViewRepresentable.swift
//  GogoStudy
//
//  Created by Xian Yin on 12/29/24.
//


import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    
    let mapView = MKMapView()
    @Binding var isPinJumping: Bool // 控制图钉动画状态
    @Binding var mapState: MapViewState
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = true
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = locationViewModel.selectedDestinationLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
            }
        case .polylineAdded:
            break
        }
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
            
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
    
}

extension MapViewRepresentable {
    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        let parent: MapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            // 更新地图中心坐标
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            DispatchQueue.main.async {
                            self.parent.isPinJumping = true // 图钉跳起
                        }
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // 更新中心坐标
            DispatchQueue.main.async {
                self.parent.isPinJumping = false
                self.parent.centerCoordinate = mapView.centerCoordinate
            }
        }
        
        //MARK -Helpers
        //添加标注
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        //显示导航折线
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D){
            guard let userLocationCoordinate = self.userLocationCoordinate else { return }
            
            parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate, to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                //目的地一直闪烁的问题
                self.parent.mapState = .polylineAdded
                //设置导航地图适应窗口大小
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                               edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func clearMapViewAndRecenterOnUserLocation(){
            parent.mapView.removeAnnotations(parent.mapView.overlays)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
    }
}
