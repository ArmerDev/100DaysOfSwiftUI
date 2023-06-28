//
//  DetailView.swift
//  TimeForMapKit
//
//  Created by James Armer on 28/06/2023.
//

import SwiftUI
import MapKit

struct DetailView: View {
    @State private var name: String
    @State private var picture: Data
    @State private var latitude: Double
    @State private var longitude: Double
    
    @State private var region: MKCoordinateRegion
    
    let annotation: [Location]
    
//    let region = MKCoordinateRegion(center: $location, span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    
    init(name: String, picture: Data, latitude: Double, longitude: Double) {
        self.name = name
        self.picture = picture
        self.latitude = latitude
        self.longitude = longitude
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        self.annotation = [Location(id: UUID(), latitude: latitude, longitude: longitude)]
    }
    
    var body: some View {
        VStack {
            Image(uiImage: UIImage(data: picture)!)
                .resizable()
                .scaledToFit()
                .navigationTitle(name)
                .navigationBarTitleDisplayMode(.inline)
            
            Map(coordinateRegion: $region, interactionModes: [], annotationItems: annotation) { location in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
            }
        }

    }
}

