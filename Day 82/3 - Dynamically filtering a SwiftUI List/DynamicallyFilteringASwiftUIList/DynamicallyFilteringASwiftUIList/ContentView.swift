//
//  ContentView.swift
//  DynamicallyFilteringASwiftUIList
//
//  Created by James Armer on 01/07/2023.
//

import SwiftUI

/*
 SwiftUI’s List view likes to work with arrays of objects that conform to the Identifiable protocol, or at least can provide some sort of id parameter that is guaranteed to be unique. However, there’s no reason these need to be stored properties of a view, and in fact if we send in a computed property then we’re able to adjust our filtering on demand.

 In our app, we have three instances of ProspectsView that vary only according to the FilterType property that gets passed in from our tab view. We’re already using that to set the title of each view, but we can also use it to set the contents for a List.

 The easiest way to do this is using Swift’s filter() method. This runs every element in a sequence through a test you provide as a closure, and any elements that return true from the test are sent back as part of a new array. Our ProspectsView already has a prospects property being passed in with an array of people inside it, so we can either return all people, all contacted people, or all uncontacted people.

 Navigate to ProspectsView and add a new property called filteredProspects:
 */

struct ContentView: View {
    @StateObject var prospects = Prospects()
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }
            
            ProspectsView(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }
            
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
        .environmentObject(prospects)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
