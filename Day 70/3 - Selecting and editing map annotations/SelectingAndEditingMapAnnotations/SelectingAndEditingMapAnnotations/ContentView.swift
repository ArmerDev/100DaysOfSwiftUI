//
//  ContentView.swift
//  SelectingAndEditingMapAnnotations
//
//  Created by James Armer on 22/06/2023.
//

import MapKit
import SwiftUI

/*
 Users can now drop markers onto our SwiftUI Map, but they can’t do anything with them – they can’t attach their own name and description. Fixing this requires a few steps, and learning a couple of things along the way, but it really brings the whole app together as you’ll see.

 First, we want to show some kind of sheet when the user selects a map annotation, giving them the chance to view or edit details about a location.

 The way we’ve tackled sheets previously has meant creating a Boolean that determines whether the sheet is visible, then sending in some other data for the sheet to present or edit. This time, though, we’re going to take a different approach: we’re going to handle it all with one property.

 So, add this to ContentView now:

     @State private var selectedPlace: Location?
 
 What we’re saying is that we might have a selected location, or we might not – and that’s all SwiftUI needs to know in order to present a sheet. As soon as we place a value into that optional we’re telling SwiftUI to show the sheet, and the value will automatically be set back to nil when the sheet is dismissed. Even better, SwiftUI automatically unwraps the optional for us, so when we’re creating the contents of our sheet we can be sure we have a real value to work with.

 To try it out, attach this modifier to the ZStack in ContentView:

     .sheet(item: $selectedPlace) { place in
         Text(place.name)
     }
 
 As you can see, it takes an optional binding, but also a function that will receive the unwrapped optional when it has a value set. So, inside there our sheet can refer to place.name directly rather than needing to unwrap the optional or use nil coalescing.

 Now to bring the whole thing to life, we just need to give selectedPlace a value by adding a tap gesture to the VStack in our map annotation:

     .onTapGesture {
         selectedPlace = location
     }
 
 That’s it! We can now present a sheet showing the selected location’s name, and it only took a small amount of code. This kind of optional binding isn’t always possible, but I think where it is possible it makes for much more natural code – SwiftUI’s behavior of unwrapping the optional automatically is really helpful.

 Of course, just showing the place’s name isn’t too useful, so the next step here is to create a detail view where used can see and adjust a location’s name and description. This needs to receive a location to edit, allow the user to adjust the two values for that location, then will send back a new location with that tweaked data – it will effectively work like a function, receiving data and sending back something transformed.

 As always we’re going to start small and work our way up, so please create a new SwiftUI view called “EditView”
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
