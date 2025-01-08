//
//  Vehicle.swift
//  Gogo
//
//  Created by Xian Yin on 12/29/24.
//

import Foundation
import MapKit

struct Vehicle: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    let subtitle: String
}
