//
//  ContentView.swift
//  SavingAndLoadingDataWithUserDefaults
//
//  Created by James Armer on 02/07/2023.
//

import SwiftUI

/*
 This app mostly works, but it has one fatal flaw: any data we add gets wiped out when the app is relaunched, which doesn’t make it much use for remembering who we met. We can fix this by making the Prospects initializer able to load data from UserDefaults, then write it back when the data changes.

 This time our data is stored using a slightly easier format: although the Prospects class uses the @Published property wrapper, the people array inside it is simple enough that it already conforms to Codable just by adding the protocol conformance. So, we can get most of the way to our goal by making three small changes:

 Updating the Prospects initializer so that it loads its data from UserDefaults where possible.
 Adding a save() method to the same class, writing the current data to UserDefaults.
 Calling save() when adding a prospect or toggling its isContacted property.
 
 We’ve looked at the code to do all that previously, so let’s get to it. We already have a simple initializer for Prospects, so we can update it to use UserDefaults.
 
 Navigate to Prospect.swift file...:
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
