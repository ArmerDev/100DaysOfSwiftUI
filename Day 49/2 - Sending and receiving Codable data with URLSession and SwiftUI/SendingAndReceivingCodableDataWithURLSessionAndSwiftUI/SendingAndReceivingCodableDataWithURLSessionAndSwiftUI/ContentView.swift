//
//  ContentView.swift
//  SendingAndReceivingCodableDataWithURLSessionAndSwiftUI
//
//  Created by James Armer on 29/05/2023.
//

import SwiftUI

/*
 iOS gives us built-in tools for sending and receiving data from the internet, and if we combine it with Codable support then it’s possible to convert Swift objects to JSON for sending, then receive back JSON to be converted back to Swift objects. Even better, when the request completes we can immediately assign its data to properties in SwiftUI views, causing our user interface to update.

 To demonstrate this we can load some example music JSON data from Apple’s iTunes API, and show it all in a SwiftUI List. Apple’s data includes lots of information, but we’re going to whittle it down to just two types: a Result will store a track ID, its name, and the album it belongs to, and a Response will store an array of results.
 */

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

/*
 We can now write a simple ContentView that shows an array of results:
 */

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
    }
}

/*
 That won’t show anything at first, because the results array is empty. This is where our networking call comes in: we’re going to ask the iTunes API to send us a list of all the songs by Taylor Swift, then use JSONDecoder to convert those results into an array of Result instances.

 However, doing this means you need to meet two important Swift keywords: async and await. You see, any iPhone capable of running SwiftUI can perform billions of operations every second – it’s so fast that it completes most work before we even realized it started it. On the flip side, networking – downloading data from the internet – might take several hundreds milliseconds or more to come, which is extremely slow for a computer that’s used to doing literally a billion other things in that time.

 Rather than forcing our entire progress to stop while the networking happens, Swift gives us the ability to say “this work will take some time, so please wait for it to complete while the rest of the app carries on running as usual.”

 This functionality – this ability to leave some code running while our main app code carries on working – is called an asynchronous function. A synchronous function is one that runs fully before returning a value as needed, but an asynchronous function is one that is able to go to sleep for a while, so that it can wait for some other work to complete before continuing. In our case, that means going to sleep while our networking code happens, so that the rest of our app doesn’t freeze up for several seconds.

 To make this easier to understand, let’s write it in a few stages. First, here’s the basic method stub –
 */

struct ContentView2: View {
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
    }
    
    func loadData() async {
        
    }
}

/*
 Notice the new async keyword in there – we’re telling Swift this function might want to go to sleep in order to complete its work.

 We want that to be run as soon as our List is shown, but we can’t just use onAppear() here because that doesn’t know how to handle sleeping functions – it expects its function to be synchronous.

 SwiftUI provides a different modifier for these kinds of tasks, giving it a particularly easy to remember name: task(). This can call functions that might go to sleep for a while; all Swift asks us to do is mark those functions with a second keyword, await, so we’re explicitly acknowledging that a sleep might happen.

 Add this modifier to the List now:

     .task {
         await loadData()
     }
 */

struct ContentView3: View {
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        
    }
}

/*
 Tip: Think of await as being like try – we’re saying we understand a sleep might happen, in the same way try says we acknowledge an error might be thrown.

 Inside loadData() we have three steps we need to complete:

 - Creating the URL we want to read.
 - Fetching the data for that URL.
 - Decoding the result of that data into a Response struct.
 
 We’ll add those step by step, starting with the URL. This needs to have a precise format: “itunes.apple.com” followed by a series of parameters – you can find the full set of parameters if you do a web search for “iTunes Search API”. In our case we’ll be using the search term “Taylor Swift” and the entity “song”, so add this to loadData() now:

 guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
     print("Invalid URL")
     return
 }
 */

struct ContentView4: View {
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
    }
}

/*
 Step 2 is to fetch the data from that URL, which is where our sleep is likely to happen. I say “likely” because it might not – iOS will do a little caching of data, so if the URL is fetched twice back to back then the data will get sent back immediately rather than triggering a sleep.

 Regardless, a sleep is possible here, and every time a sleep is possible we need to use the await keyword with the code we want to run. Just as importantly, an error might also be thrown here – maybe the user isn’t currently connected to the internet, for example.

 So, we need to use both try and await at the same time. Please add this code directly after the previous code:

         do {
             let (data, _) = try await URLSession.shared.data(from: url)

             // more code to come
         } catch {
             print("Invalid data")
         }
 */

struct ContentView5: View {
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // more code to come
        } catch {
            print("Invalid data")
        }
    }
}

/*
 That introduced three important things, so let’s break it down:

-  Our work is being done by the data(from:) method, which takes a URL and returns the Data object at that URL. This method belongs to the URLSession class, which you can create and configure by hand if you want, but you can also use a shared instance that comes with sensible defaults.
 
-  The return value from data(from:) is a tuple containing the data at the URL and some metadata describing how the request went. We don’t use the metadata, but we do want the URL’s data, hence the underscore – we create a new local constant for the data, and toss the metadata away.
 
-  When using both try and await at the same time, we must write try await – using await try is not allowed. There’s no special reason for this, but they had to pick one so they went with the one that reads more naturally.
 
 So, if our download succeeds our data constant will be set to whatever data was sent back from the URL, but if it fails for any reason our code prints “Invalid data” and does nothing else.

 The last part of this method is to convert the Data object into a Response object using JSONDecoder, then assign the array inside to our results property. This is exactly what we’ve used before, so this shouldn’t be a surprise – add this last code in place of the // more code to come comment now:

 if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
     results = decodedResponse.results
 }
 */

struct ContentView6: View {
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }
    }
}

/*
 If you run the code now you should see a list of Taylor Swift songs appear after a short pause – it really isn’t a lot of code given how well the end result works.

 All this only handles downloading data. Later on in this project we’re going to look at how to adopt a slightly different approach so you can send Codable data, but that’s enough for now.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView6()
    }
}
