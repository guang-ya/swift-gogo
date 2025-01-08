//
//  CarOwnerHomePage.swift
//  Gogo
//
//  Created by Xian Yin on 1/6/25.
//

import SwiftUI
import MapKit

struct CarOwnerHomePage: View {
    //确保 LocationManager 只被初始化一次并绑定到视图的生命周期
    @StateObject private var locationManager = LocationManager() // 添加 LocationManager 实例
    @State private var mapState = MapViewState.noInput
    @State private var centerCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    @State private var pinCoordinate: CLLocationCoordinate2D? // 图钉位置
    @State private var isPinJumping = false
    @State private var address: String = "正在获取地址..."
    
    @State var pickupAddress: String = ""
    @State var dropoffAddress: String = ""
    
    
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    var body: some View {
        ZStack(alignment: .bottomLeading){
            MapViewRepresentable(isPinJumping: $isPinJumping,
                                     mapState: $mapState,
                                     centerCoordinate: $centerCoordinate)
                .ignoresSafeArea()
            
            if address != "正在获取地址..." { // 确保地址已更新
                CustomPinView(address: address)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
//                    .offset(y: isPinJumping ? -20 : 0) // 图钉跳起效果
//                    .animation(.spring(), value: isPinJumping)
            }
            
            if mapState == .searchingForLocation {
                LocationSearchView(mapState: $mapState,
                                   pickupAddress: $pickupAddress,
                                   dropoffAddress: $dropoffAddress)
            } else if mapState == .noInput{
                //上下车view
                VStack(alignment: .leading, spacing: 10) {
                    PickupPointView(title: "从哪里出发:",
                                    pickupAddress: $pickupAddress,
                                    onSelect: {title, description in
                    })
                    .highPriorityGesture(
                            TapGesture().onEnded {
                                print("PickupPointView tapped!")
                                withAnimation(.spring()) {
                                    mapState = .searchingForLocation
                                    LocationSearchView(mapState: $mapState,
                                                       pickupAddress: $pickupAddress,
                                                       dropoffAddress: $dropoffAddress)
                                }
                            }
                        )
                    
                    DropOffPointView(title: "想去哪儿？", dropoffAddress: $dropoffAddress, onSelect: {title, address in
                        
                    })
                    .highPriorityGesture(
                            TapGesture().onEnded {
                                print("PickupPointView tapped!")
                                withAnimation(.spring()) {
                                    mapState = .searchingForLocation
                                    LocationSearchView(mapState: $mapState,
                                                       pickupAddress: $pickupAddress,
                                                       dropoffAddress: $dropoffAddress)
                                }
                            }
                        )
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                .padding([.leading, .trailing, .bottom])
                
                
//                LocationSearchActivationView()
//                    .padding(.top, 72)
//                    .onTapGesture {
//                        withAnimation(.spring) {
//                            mapState = .searchingForLocation
//                        }
//                    }
            }
            MapViewActionButton(mapState: $mapState)
                    .padding(.leading)
                    .padding(.top, 4)
            
            
            
            
            if mapState == .locationSelected || mapState == .polylineAdded{
                RideRequestView()
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location{
                pinCoordinate = location // 将图钉初始化到用户位置
                viewModel.userLocation = location
                reverseGeocodeLocation(location)
            }
        }
    }
    
    // 反向地理编码
    private func reverseGeocodeLocation(_ location: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)

        geocoder.reverseGeocodeLocation(clLocation) { placemarks, error in
            if let placemark = placemarks?.first {
                let street = placemark.thoroughfare ?? "未知街道"
                let city = placemark.locality ?? "未知城市"
                let state = placemark.administrativeArea ?? ""
                address = "\(street), \(city), \(state)"
            } else if let error = error {
                address = "地址解析失败: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    CarOwnerHomePage()
        .environmentObject(LocationSearchViewModel())
}
