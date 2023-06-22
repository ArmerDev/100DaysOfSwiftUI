//
//  Location.swift
//  ImprovingOurMapAnnotations
//
//  Created by James Armer on 22/06/2023.
//

import Foundation
import MapKit

struct Location: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Where Queen Elizabeth lives with her dorgis.", latitude: 51.501, longitude: -0.141)
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}


/*
 The last change I’d like to make here is to add a custom == function to the struct. We already made Location conform to Equatable, which means we can already compare one location to another using ==. Behind the scenes, Swift will write this function for us by comparing every property against every other property, which is rather wasteful – all our locations already have a unique identifier, so if two locations have the same identifier then we can be sure they are the same without also checking the other properties.

 So, we can save a bunch of work by writing our own == function to Location, which compares two identifiers and nothing else:

 static func ==(lhs: Location, rhs: Location) -> Bool {
     lhs.id == rhs.id
 }
 I’m a huge fan of making structs conform to Equatable as standard, even if you can’t use an optimized comparison function like above – structs are simple values like strings and integers, and I think we should extend that same status to our own custom structs too.

 With that in place the next step of our project is complete, so please run it now – you should be able to drop a marker and see our custom annotation, but now behind the scenes know that our code is a little bit neater too!
 */
