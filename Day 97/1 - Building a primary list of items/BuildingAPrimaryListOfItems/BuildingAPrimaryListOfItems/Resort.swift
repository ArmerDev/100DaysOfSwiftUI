//
//  Resort.swift
//  BuildingAPrimaryListOfItems
//
//  Created by James Armer on 17/07/2023.
//

import Foundation

struct Resort: Codable, Identifiable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]
    
    static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    static let example = allResorts[0]
}

/*
 As usual, it’s a good idea to add an example value to your model so that it’s easier to show working data in your designs. This time, though, there are quite a few fields to work with and it’s helpful if they have real data, so I don’t really want to create one by hand.

 Instead, we’re going to load an array of resorts from JSON stored in our app bundle, which means we can re-use the same code we wrote for project 8 – the Bundle-Decodable.swift extension. If you still have yours, you can drop it into your new project, but if not then create a new Swift file called Bundle-Decodable.swift (then return to this file after adding decodable code):
 */

/*
 With that in place, we can add some properties to Resort to store our example data, and there are two options here. The first option is to add two static properties: one to load all resorts into an array, and one to store the first item in that array, like this:

 static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
 static let example = allResorts[0]
 
 The second is to collapse all that down to a single line of code. This requires a little bit of gentle typecasting because our decode() extension method needs to know what type of data it’s decoding:

 static let example = (Bundle.main.decode("resorts.json") as [Resort])[0]
 
 Of the two, I prefer the first option because it’s simpler and has a little more use if we wanted to show random examples rather than the same one again and again. In case you were curious, when we use static let for properties, Swift automatically makes them lazy – they don’t get created until they are used. This means when we try to read Resort.example Swift will be forced to create Resort.allResorts first, then send back the first item in that array for Resort.example. This means we can always be sure the two properties will be run in the correct order – there’s no chance of example going missing because allResorts wasn’t called yet.

 Now that our simple Resort struct is done, we can also use that same Bundle extension to add a property to ContentView that loads all our resorts into a single array:

 let resorts: [Resort] = Bundle.main.decode("resorts.json")
 */

/*
 Navigate to ContentView.swift...
 */
