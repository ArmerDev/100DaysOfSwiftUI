//
//  ContentView.swift
//  LettingTheUserMarkFavorites
//
//  Created by James Armer on 18/07/2023.
//

import SwiftUI

/*
 The final task for this project is to let the user assign favorites to resorts they like. This is mostly straightforward, using techniques we’ve already covered:

 - Creating a new Favorites class that has a Set of resort IDs the user likes.
 
 - Giving it add(), remove(), and contains() methods that manipulate the data, sending update notifications to SwiftUI while also saving any changes to UserDefaults.
 
 - Injecting an instance of the Favorites class into the environment.
 
 - Adding some new UI to call the appropriate methods.
 
 Swift’s sets already contain methods for adding, removing, and checking for an element, but we’re going to add our own around them so we can use objectWillChange to notify SwiftUI that changes occurred, and also call a save() method so the user’s changes are persisted. This in turn means we can mark the favorites set using private access control, so we can’t accidentally bypass our methods and miss out saving.

 Create a new Swift file called Favorites.swift, replace its Foundation import with SwiftUI, then give it this code:

     class Favorites: ObservableObject {
         // the actual resorts the user has favorited
         private var resorts: Set<String>

         // the key we're using to read/write in UserDefaults
         private let saveKey = "Favorites"

         init() {
             // load our saved data

             // still here? Use an empty array
             resorts = []
         }

         // returns true if our set contains this resort
         func contains(_ resort: Resort) -> Bool {
             resorts.contains(resort.id)
         }

         // adds the resort to our set, updates all views, and saves the change
         func add(_ resort: Resort) {
             objectWillChange.send()
             resorts.insert(resort.id)
             save()
         }

         // removes the resort from our set, updates all views, and saves the change
         func remove(_ resort: Resort) {
             objectWillChange.send()
             resorts.remove(resort.id)
             save()
         }

         func save() {
             // write out our data
         }
     }
     
 You’ll notice I’ve missed out the actual functionality for loading and saving favorites – that will be your job to fill in shortly.

 We need to create a Favorites instance in ContentView and inject it into the environment so all views can share it. So, add this new property to ContentView:

 @StateObject var favorites = Favorites()
 Now inject it into the environment by adding this modifier to the NavigationView:

 .environmentObject(favorites)
 Because that’s attached to the navigation view, every view the navigation view presents will also gain that Favorites instance to work with. So, we can load it from inside ResortView by adding this new property:

 @EnvironmentObject var favorites: Favorites
 Tip: Make sure you modify your ResortView preview to inject an example Favorites object into the environment, so your SwiftUI preview carries on working. This will work fine: .environmentObject(Favorites()).

 All this work hasn’t really accomplished much yet – sure, the Favorites class gets loaded when the app starts, but it isn’t actually used anywhere despite having properties to store it.

 This is easy enough to fix: we’re going to add a button at the end of the scrollview in ResortView so that users can either add or remove the resort from their favorites, then display a heart icon in ContentView for favorite resorts.

 First, add this to the end of the scrollview in ResortView:

 Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
     if favorites.contains(resort) {
         favorites.remove(resort)
     } else {
         favorites.add(resort)
     }
 }
 .buttonStyle(.borderedProminent)
 .padding()
 Now we can show a colored heart icon next to favorite resorts in ContentView by adding this to the end of the label for our NavigationLink:

 if favorites.contains(resort) {
     Spacer()
     Image(systemName: "heart.fill")
     .accessibilityLabel("This is a favorite resort")
         .foregroundColor(.red)
 }
 Tip: As you can see, the foregroundColor() modifier works great here because our image uses SF Symbols.

 That mostly works, but you might notice a glitch: if you favorite resorts with longer names you might find their name wraps onto two lines even though there’s space for it to be all on one.

 This happens because we’ve made an assumption in our code, and it’s coming back to bite us: we were passing an Image and a VStack into the label for our NavigationLink, which SwiftUI was smart enough to arrange neatly for us, but as soon as we added a third view it wasn’t sure how to respond.

 To fix this, we need to tell SwiftUI explicitly that the content of our NavigationLink is a plain old HStack, so it will size everything appropriately. So, wrap the entire contents of the NavigationLink label – everything from the Image down to the new condition wrapping the heart icon – inside a HStack to fix the problem.

 That should make the text layout correctly even with the spacer and heart icon – much better. And that also finishes our project, so give it one last try and see what you think. Good job!
 */

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var searchText = ""
    @StateObject var favorites = Favorites()
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )

                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
            
            WelcomeView()
        }
        .environmentObject(favorites)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
