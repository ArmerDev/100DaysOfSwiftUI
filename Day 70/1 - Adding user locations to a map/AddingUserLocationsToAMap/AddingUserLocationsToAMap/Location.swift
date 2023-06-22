//
//  Location.swift
//  AddingUserLocationsToAMap
//
//  Created by James Armer on 22/06/2023.
//

import Foundation

struct Location: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
}


/*
 Storing latitude and longitude separately gives us Codable conformance out of the box, which is always nice to have. We’ll add a little more to that shortly, but it’s enough to get us moving.

 Now that we have a data type where we can store an individual location, we need an array of those to store all the places the user wants to visit. We’ll put this into ContentView for now just we can get moving, but again we’ll return to it shortly to add more.

 So, start by adding this property to ContentView:

 @State private var locations = [Location]()
 Next, we want to add a location to that whenever the + button is tapped, so replace the // create a new location comment with this:

 let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
 locations.append(newLocation)
 Finally, update ContentView so that it sends in the locations array to be converted into annotations:

 Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
     MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
 }
 .ignoresSafeArea()
 */
