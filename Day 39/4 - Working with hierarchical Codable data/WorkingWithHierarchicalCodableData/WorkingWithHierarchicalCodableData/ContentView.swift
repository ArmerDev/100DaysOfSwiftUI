//
//  ContentView.swift
//  WorkingWithHierarchicalCodableData
//
//  Created by James Armer on 22/05/2023.
//

import SwiftUI

/*
 The Codable protocol makes it trivial to decode flat data: if you’re decoding a single instance of a type, or an array or dictionary of those instances, then things Just Work. However, in this project we’re going to be decoding slightly more complex JSON: there will be an array inside another array, using different data types.

 If you want to decode this kind of hierarchical data, the key is to create separate types for each level you have. As long as the data matches the hierarchy you’ve asked for, Codable is capable of decoding everything with no further work from us.

 To demonstrate this, put this button in to your content view:
 */


struct ContentView: View {
    var body: some View {
        Button("Decode JSON") {
            let input = """
            {
                "name": "Taylor Swift",
                "address": {
                    "street": "555, Taylor Swift Avenue",
                    "city": "Nashville"
                }
            }
            """

            // more code to come
        }
    }
}

/*
 That creates a string of JSON in code. In case you aren’t too familiar with JSON, it’s probably best to look at the Swift structs that match it – you can put these directly into the button action or outside of the ContentView struct, it doesn’t matter:
 */

struct User: Codable {
    let name: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let city: String
}

/*
 Hopefully you can now see what the JSON contains: a user has a name string and an address, and addresses are a street string and a city string.

 Now for the best part: we can convert our JSON string to the Data type (which is what Codable works with), then decode that into a User instance:
 */

struct ContentView2: View {
    var body: some View {
        Button("Decode JSON") {
            let input = """
            {
                "name": "Taylor Swift",
                "address": {
                    "street": "555, Taylor Swift Avenue",
                    "city": "Nashville"
                }
            }
            """

            let data = Data(input.utf8)
            
            if let user = try? JSONDecoder().decode(User.self, from: data) {
                print(user.address.street)
            }
        }
    }
}

/*
 If you run that program and tap the button you should see the address printed out – although just for the avoidance of doubt I should say that it’s not her actual address!

 There’s no limit to the number of levels Codable will go through – all that matters is that the structs you define match your JSON string.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
    }
}
