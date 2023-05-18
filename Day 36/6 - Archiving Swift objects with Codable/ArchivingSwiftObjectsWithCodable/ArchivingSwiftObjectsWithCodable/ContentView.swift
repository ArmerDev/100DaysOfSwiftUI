//
//  ContentView.swift
//  ArchivingSwiftObjectsWithCodable
//
//  Created by James Armer on 18/05/2023.
//

import SwiftUI

/*
 @AppStorage is great for storing simple settings such as integers and Booleans, but when it comes to complex data – custom Swift types, for example – we need to do a little more work. This is where we need to poke around directly with UserDefaults itself, rather than going through the @AppStorage property wrapper.

 Here’s a simple User data structure we can work with:
 */

struct User {
    let firstName: String
    let lastName: String
}

/*
 That has two strings, but those aren’t special – they are just pieces of text. The same goes for integer (plain old numbers), Boolean (true or false), and Double (plain old numbers, just with a dot somewhere in there). Even arrays and dictionaries of those values are easy to think about: there’s one string, then another, then a third, and so on.

 When working with data like this, Swift gives us a fantastic protocol called Codable: a protocol specifically for archiving and unarchiving data, which is a fancy way of saying “converting objects into plain text and back again.”

 We’re going to be looking at Codable much more in future projects, but for now we’re going to keep it as simple as possible: we want to archive a custom type so we can put it into UserDefaults, then unarchive it when it comes back out from UserDefaults.

 When working with a type that only has simple properties – strings, integers, Booleans, arrays of strings, and so on – the only thing we need to do to support archiving and unarchiving is add a conformance to Codable, like this:
 */

struct User2: Codable {
    let firstName: String
    let lastName: String
}

/*
 Swift will automatically generate some code for us that will archive and unarchive User instances for us as needed, but we still need to tell Swift when to archive and what to do with the data.

 This part of the process is powered by a new type called JSONEncoder. Its job is to take something that conforms to Codable and send back that object in JavaScript Object Notation (JSON) – the name implies it’s specific to JavaScript, but in practice we all use it because it’s so fast and simple.

 The Codable protocol doesn’t require that we use JSON, and in fact other formats are available, but it is by far the most common. In this instance, we don’t actually care what sort of data is used, because it’s just going to be stored in UserDefaults.

 To convert our user data into JSON data, we need to call the encode() method on a JSONEncoder. This might throw errors, so it should be called with try or try? to handle errors neatly. For example, if we had a property to store a User instance, Then we could create a button that archives the user and save it to UserDefaults, like this:
 */

struct ContentView: View {
    @State private var user = User2(firstName: "Taylor", lastName: "Swift")
    
    var body: some View {
        Button("Save User") {
            let encoder = JSONEncoder()
            
            if let data = try? encoder.encode(user) {
                UserDefaults.standard.set(data, forKey: "UserData")
            }
        }
    }
}

/*
 That accesses UserDefaults directly rather than going through @AppStorage, because the @AppStorage property wrapper just doesn’t work here.

 That data constant is a new data type called, perhaps confusingly, Data. It’s designed to store any kind of data you can think of, such as strings, images, zip files, and more. Here, though, all we care about is that it’s one of the types of data we can write straight into UserDefaults.

 When we’re coming back the other way – when we have JSON data and we want to convert it to Swift Codable types – we should use JSONDecoder rather than JSONEncoder(), but the process is much the same.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
