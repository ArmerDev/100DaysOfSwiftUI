//
//  ContentView.swift
//  AddingCodableConformanceFor@PublishedProperties
//
//  Created by James Armer on 29/05/2023.
//

import SwiftUI

/*
 If all the properties of a type already conform to Codable, then the type itself can conform to Codable with no extra work – Swift will synthesize the code required to archive and unarchive your type as needed. However, this doesn’t work when we use property wrappers such as @Published, which means conforming to Codable requires some extra work on our behalf.

 To fix this, we need to implement Codable conformance ourself. This will fix the @Published encoding problem, but is also a valuable skill to have elsewhere too because it lets us control exactly what data is saved and how it happens.

 First let’s create a simple type that recreates the problem. Add this class to ContentView.swift:
 */

class User: ObservableObject, Codable {
    @Published var name = "Paul Hudson"
}

/*
 if we make it @Published then the code no longer compiles.
 
 The @Published property wrapper isn’t magic – the name property wrapper comes from the fact that our name property is automatically wrapped inside another type that adds some additional functionality. In the case of @Published that’s a struct called Published that can store any kind of value.

 Previously we looked at how we can write generic methods that work with any kind of value, and the Published struct takes that a step further: the whole type itself is generic, meaning that you can’t make an instance of Published all by itself, but instead make an instance of Published<String> – a publishable object that contains a string.

 If that sounds confusing, back up: it’s actually a fairly fundamental principle of Swift, and one you’ve been working with for some time. Think about it – we can’t say var names: Set, can we? Swift doesn’t allow it; Swift wants to know what’s in the set. This is because Set is also a generic type: you must make an instance of Set<String>. The same is also true of arrays and dictionaries: we always make them have something specific inside.

 Swift already has rules in place that say if an array contains Codable types then the whole array is Codable, and the same for dictionaries and sets. However, SwiftUI doesn’t provide the same functionality for its Published struct – it has no rule saying “if the published object is Codable, then the published struct itself is also Codable.”

 As a result, we need to make the type conform ourselves: we need to tell Swift which properties should be loaded and saved, and how to do both of those actions.

 None of those steps are terribly hard, so let’s just dive in with the first one: telling Swift which properties should be loaded and saved. This is done using an enum that conforms to a special protocol called CodingKey, which means that every case in our enum is the name of a property we want to load and save. This enum is conventionally called CodingKeys, with an S on the end, but you can call it something else if you want.

 So, our first step is to create a CodingKeys enum that conforms to CodingKey, listing all the properties we want to archive and unarchive. Add this inside the User class now:

 enum CodingKeys: CodingKey {
     case name
 }
 */

class User2: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case name
    }
    
    @Published var name = "Paul Hudson"
}

/*
 The next task is to create a custom initializer that will be given some sort of container, and use that to read values for all our properties. This will involve learning a few new things, but let’s look at the code first – add this initializer to User now:

 required init(from decoder: Decoder) throws {
     let container = try decoder.container(keyedBy: CodingKeys.self)
     name = try container.decode(String.self, forKey: .name)
 }
 */

class User3: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case name
    }
    
    @Published var name = "Paul Hudson"
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
}

/*
 Even though that isn’t much code, there are at least four new things in there.

 First, this initializer is handed an instance of a new type called Decoder. This contains all our data, but it’s down to us to figure out how to read it.

 Second, anyone who subclasses our User class must override this initializer with a custom implementation to make sure they add their own values. We mark this using the required keyword: required init. An alternative is to mark this class as final so that subclassing isn’t allowed, in which case we’d write final class User and drop the required keyword entirely.

 Third, inside the method we ask our Decoder instance for a container matching all the coding keys we already set in our CodingKey struct by writing decoder.container(keyedBy: CodingKeys.self). This means “this data should have a container where the keys match whatever cases we have in our CodingKeys enum. This is a throwing call, because it’s possible those keys don’t exist.

 Finally, we can read values directly from that container by referencing cases in our enum – container.decode(String.self, forKey: .name). This provides really strong safety in two ways: we’re making it clear we expect to read a string, so if name gets changed to an integer the code will stop compiling; and we’re also using a case in our CodingKeys enum rather than a string, so there’s no chance of typos.

 There’s one more task we need to complete before the User class conforms to Codable: we’ve made an initializer so that Swift can decode data into this type, but now we need to tell Swift how to encode this type – how to archive it ready to write to JSON.

 This step is pretty much the reverse of the initializer we just wrote: we get handed an Encoder instance to write to, ask it to make a container using our CodingKeys enum for keys, then write our values attached to each key.

 Add this method to the User class now:

 func encode(to encoder: Encoder) throws {
     var container = encoder.container(keyedBy: CodingKeys.self)
     try container.encode(name, forKey: .name)
 }
 */

class User4: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case name
    }
    
    @Published var name = "Paul Hudson"
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}

/*
 And now our code compiles: Swift knows what data we want to write, knows how to convert some encoded data into our object’s properties, and knows how to convert our object’s properties into some encoded data.

 I hope you’re able to see some real advantages here compared to the stringly typed API of UserDefaults – it’s much harder to make a mistake with Codable because we don’t use strings, and it automatically checks our data types are correct.
 */

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
