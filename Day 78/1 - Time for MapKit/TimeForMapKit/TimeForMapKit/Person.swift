//
//  Person.swift
//  TimeForMapKit
//
//  Created by James Armer on 28/06/2023.
//

import MapKit
import SwiftUI

struct Person: Identifiable, Codable {
    var id = UUID()
    let name: String
    let picture: Data
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(name: String, picture: UIImage, latitude: Double, longitude: Double) {
        self.name = name
        self.picture = picture.pngData()!
        self.latitude = latitude
        self.longitude = longitude
    }
}
