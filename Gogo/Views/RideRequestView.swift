//
//  RideRequestView.swift
//  GogoStudy
//
//  Created by Xian Yin on 12/31/24.
//

import SwiftUI

struct RideRequestView: View {
    @State private var selectedRideType: RideType = .uberX
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    var body: some View {
        VStack{
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            //trip info view
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 32)
                    Rectangle()
                        .fill(.black)
                        .frame(width: 8, height: 8)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Current location")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(locationViewModel.pickupTime ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        if let location = locationViewModel.selectedDestinationLocation {
                            Text(location.title)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text(locationViewModel.dropOffTime ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 8)
                }
            }
            .padding()
            
            Divider()
                .padding(.vertical, 8)
            
            // ride type selection view
            Text("SUGGESTED RIDES")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal){
                HStack(spacing: 12) {
                    ForEach(RideType.allCases) {type in
                        VStack(alignment: .leading) {
                            Image(systemName: type.imageName)
                                .resizable()
                                .scaledToFit()
                            
                            VStack(spacing: 4){
                                Text(type.description)
                                    .font(.system(size: 14, weight: .semibold))
                                
                                Text("$\(String(format: "%.2f", locationViewModel.computeRidePrice(forType: type)))")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .padding(8)
                        }
                        .frame(width: 112, height: 140)
                        .foregroundColor(type == selectedRideType ? .white : .black)
                        .background(type == selectedRideType ? .blue : Color.theme.secondBackgroundColor)
                        .cornerRadius(10)
                        .scaleEffect(type == selectedRideType ? 1.2 : 1.0)
                        .onTapGesture{
                            withAnimation {
                                selectedRideType = type
                            }
                        }
                    }
                }
            }
            
            // payment option view
            HStack{
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(.blue)
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Text("********** 1234")
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .padding()
            }
            .frame(height: 50)
            .background(Color.theme.secondBackgroundColor)
            .cornerRadius(10)
            .padding(.horizontal)
            
            //request ride button
            Button {
                
            } label: {
                Text("Confirm ride")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }

        }
        .padding(.bottom, 24)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .background(.white)
    }
}

#Preview {
    RideRequestView()
        .environmentObject(LocationSearchViewModel()) // 注入环境对象
}
