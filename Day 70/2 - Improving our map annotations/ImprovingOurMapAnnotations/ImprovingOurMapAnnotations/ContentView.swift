//
//  ContentView.swift
//  ImprovingOurMapAnnotations
//
//  Created by James Armer on 22/06/2023.
//

import MapKit
import SwiftUI

/*
 Right now we’re using MapMarker to place locations in our Map view, but SwiftUI lets us place any kind of view on top of our map so we can have complete customizability. So, we’re going to use that to show a custom SwiftUI view containing an icon and some text to show the location’s name, then take a look at the underlying data type to see what improvements can be made there.

 Thanks to the brilliance of SwiftUI, this takes hardly any code at all
 */

struct ContentView: View {
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
    }
}

/*
 That’s already an immediate improvement, because now it’s clear what each marker represents – the location name appears directly underneath. However, I want to look beyond just the SwiftUI view: I want to look at the Location struct itself, and apply a few improvements that make it better.

 First, I don’t particularly like having to make a CLLocationCoordinate2D inside our SwiftUI view, and I’d much prefer to move that kind of logic inside our Location struct. So, we can move that into a computed property to clean up our code. First, add an import for MapKit into Location.swift, then add this to Location:

     var coordinate: CLLocationCoordinate2D {
         CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
     }
 
 Now our ContentView code is simpler:

    MapAnnotation(coordinate: location.coordinate) {
 */

/*
 The second change I want to make is one I encourage everyone to make when building custom data types for use with SwiftUI: add an example! This makes previewing significantly easier, so where possible I would encourage you to add a static example property to your types containing some sample data that can be previewed well.

 So, add this second property to Location now:

 static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Where Queen Elizabeth lives with her dorgis.", latitude: 51.501, longitude: -0.141)
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
