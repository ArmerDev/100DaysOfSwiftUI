//
//  ContentView.swift
//  DownloadingDataFromWikipedia
//
//  Created by James Armer on 22/06/2023.
//

import MapKit
import SwiftUI

/*
 To make this whole app more useful, we’re going to modify our EditView screen so that it shows interesting places. After all, if visiting London is on your bucket list, you’d probably want some suggestions for things to see nearby. This might sound hard to do, but actually we can query Wikipedia using GPS coordinates, and it will send back a list of places that are nearby.

 Wikipedia’s API sends back JSON data in a precise format, so we need to do a little work to define Codable structs capable of storing it all. The structure is this:

 The main result contains the result of our query in a key called “query”.
 Inside the query is a “pages” dictionary, with page IDs as the key and the Wikipedia pages themselves as values.
 Each page has a lot of information, including its coordinates, title, terms, and more.
 We can represent that using three linked structs, so create a new Swift file called Result.swift, navigate there and then update its code...
 
 */

struct ContentView: View {
    @State private var selectedPlace: Location?
    @State private var locations = [Location]()
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())
                        
                        Text(location.name)
                            .fixedSize()
                    }
                    .onTapGesture {
                        selectedPlace = location
                    }
                }
            }
                .ignoresSafeArea()
            
            Circle()
                .fill(.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
                        locations.append(newLocation)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
        }
        .sheet(item: $selectedPlace) { place in
            EditView(location: place) { newLocation in
                if let index = locations.firstIndex(of: place) {
                    locations[index] = newLocation
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
