//
//  ContentView.swift
//  SortingWikipediaResults
//
//  Created by James Armer on 22/06/2023.
//

import MapKit
import SwiftUI

/*
 Wikipedia’s results come back to us in an order that probably seems random, but it’s actually sorted according to their internal page ID. That doesn’t help us though, which is why we’re sorting results using a custom closure.

 There are lots of times when using a custom sorting function is exactly what you need, but more often than not there is one natural order to your data – maybe showing news stories newest first, or contacts last name first, etc. So, rather than just provide an inline closure to sorted() we are instead going to make our Page struct conform to Comparable. This is actually pretty easy to do, because we already have the sorting code written – it’s just a matter of moving it across to our Page struct.
 
 Go to Result.swift ...
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
