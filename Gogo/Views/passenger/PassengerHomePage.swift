//
//  CarOwnerHomePage.swift
//  Gogo
//
//  Created by Xian Yin on 1/6/25.
//

import SwiftUI
import MapKit

struct PassengerHomePage: View {
    //确保 LocationManager 只被初始化一次并绑定到视图的生命周期
    @StateObject private var locationManager = LocationManager.shared // 添加 LocationManager 实例
    @State private var mapState = MapViewState.noInput
    @State private var centerCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    @State private var pinCoordinate: CLLocationCoordinate2D? // 图钉位置
    @State private var isPinJumping = false
    
    @State var pickupAddress: String = ""
    @State var dropoffAddress: String = ""
    
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    var body: some View {
        ZStack(alignment: .bottomLeading){
            MapViewRepresentable(isPinJumping: $isPinJumping,
                                     mapState: $mapState,
                                     centerCoordinate: $centerCoordinate)
                .ignoresSafeArea()
            
            if pickupAddress != "" { // 确保地址已更新
                CustomPinView(address: pickupAddress)
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
                                withAnimation(.spring()) {
                                    mapState = .searchingForLocation
                                    _ = LocationSearchView(mapState: $mapState,
                                                       pickupAddress: $pickupAddress,
                                                       dropoffAddress: $dropoffAddress)
                                }
                            }
                        )
                    
                    DropOffPointView(title: "想去哪儿？", dropoffAddress: $dropoffAddress, onSelect: {title, address in
                    })
                    .highPriorityGesture(
                            TapGesture().onEnded {
                                withAnimation(.spring()) {
                                    mapState = .searchingForLocation
                                    _ = LocationSearchView(mapState: $mapState,
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
        .onReceive(locationManager.$userLocation) { location in
            print("locationManager.currentAddress====:\(location)")
            if let location = location {
                print("locationManager.currentAddress:\(location)")
                pinCoordinate = location // 将图钉初始化到用户位
                viewModel.userLocation = location
                pickupAddress = locationManager.currentAddress
            }
        }
    }
    
    
}

#Preview {
    PassengerHomePage()
        .environmentObject(LocationSearchViewModel())
}
