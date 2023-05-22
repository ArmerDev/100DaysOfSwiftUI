//
//  CrewRole.swift
//  UsingGenericsToLoadAnyKindOfCodableData
//
//  Created by James Armer on 22/05/2023.
//

import Foundation

struct CrewRole: Codable {
    let name: String
    let role: String
}

/*
 As for the missions, this will be an ID integer, an array of CrewRole, and a description string. But what about the launch date – we might have one, but we also might not have one. What should that be?

 Well, think about it: how does Swift represent this “maybe, maybe not” elsewhere? How would we store “might be a string, might be nothing at all”? I hope the answer is clear: we use optionals. In fact, if we mark a property as optional Codable will automatically skip over it if the value is missing from our input JSON.
 */

struct Mission: Codable, Identifiable {
    let id: Int
    let launchDate: String?
    let crew: [CrewRole]
    let description: String
}

/*
 Before we look at how to load JSON into that, I want to demonstrate one more thing: our CrewRole struct was made specifically to hold data about missions, and as a result we can actually put the CrewRole struct inside the Mission struct like this:
 */

struct Mission2: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }

    let id: Int
    let launchDate: String?
    let crew: [CrewRole]
    let description: String
}

/*
 This is called a nested struct, and is simply one struct placed inside of another. This won’t affect our code in this project, but elsewhere it’s useful to help keep your code organized: rather than saying CrewRole you’d write Mission.CrewRole. If you can imagine a project with several hundred custom types, adding this extra context can really help!

 Now let’s think about how we can load missions.json into an array of Mission structs. We already added a Bundle extension that loads some JSON file into a dictionary of Astronaut structs, so we could very easily copy and paste that, then tweak it so it loads missions rather than astronauts. However, there’s a better solution: we can leverage Swift’s generics system, which is an advanced feature we touched on lightly back in project 3.

 Generics allow us to write code that is capable of working with a variety of different types. In this project, we wrote the Bundle extension to work with dictionary of astronauts, but really we want to be able to handle dictionaries of astronauts, arrays of missions, or potentially lots of other things.
 
 To make a method generic, we give it a placeholder for certain types. This is written in angle brackets (< and >) after the method name but before its parameters, like this:

        func decode<T>(_ file: String) -> [String: Astronaut] {
 
 We can use anything for that placeholder – we could have written “Type”, “TypeOfThing”, or even “Fish”; it doesn’t matter. “T” is a bit of a convention in coding, as a short-hand placeholder for “type”.
 
 So, let's head over to Bundle-Decodable and fix that:
 */
