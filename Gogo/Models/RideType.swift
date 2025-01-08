//
//  RideType.swift
//  GogoStudy
//
//  Created by Xian Yin on 12/31/24.
//

import Foundation


/*
 let ride = RideType.uberX
 print(ride.id)           // 输出 0
 print(ride.description)  // 输出 "UberX"
 print(ride.imageName)    // 输出 "uber-x"
 */
enum RideType: Int, CaseIterable, Identifiable{
    case uberX
    case black
    case uberXL
    
    var id: Int { return rawValue }
    
    var description: String {
        switch self {
            
        case .uberX: return "UberX"
        case .black: return "UberBlack"
        case .uberXL: return "UberXL"
        }
    }
    
    
    var imageName: String {
        switch self {
        case .uberX: return "uber-x"
        case .black: return "uber-black"
        case .uberXL: return "uber-x"
        }
    }
    
    var baseFare: Double {
        switch self {
        case .uberX: return 5
        case .black: return 20
        case .uberXL: return 10
        }
    }
    
    func computePrice(for distanceInMeters: Double) -> Double{
        let distanceInMiles = distanceInMeters / 1600
        
        switch self {
        case .uberX: return distanceInMiles * 1.5 + baseFare
        case .black: return distanceInMiles * 2.0 + baseFare
        case .uberXL: return distanceInMiles * 1.75 + baseFare
        }
    }
    
}
