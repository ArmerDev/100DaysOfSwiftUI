//
//  Astronaut.swift
//  LoadingASpecificKindOfCodableData
//
//  Created by James Armer on 22/05/2023.
//

import Foundation

struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}

/*
 As you can see, I’ve made that conform to Codable so we can create instances of this struct straight from JSON, but also Identifiable so we can use arrays of astronauts inside ForEach and more – that id field will do just fine.

 Next we want to convert astronauts.json into a dictionary of Astronaut instances, which means we need to use Bundle to find the path to the file, load that into an instance of Data, and pass it through a JSONDecoder. Previously we put this into a method on ContentView, but here I’d like to show you a better way: we’re going to write an extension on Bundle to do it all in one centralized place.

 Create another new Swift file, this time called Bundle-Decodable.swift. This will mostly use code you’ve seen before, but there’s one small difference: previously we used String(contentsOf:) to load files into a string, but because Codable uses Data we are instead going to use Data(contentsOf:). It works in just the same way as String(contentsOf:): give it a file URL to load, and it either returns its contents or throws an error.
 */
