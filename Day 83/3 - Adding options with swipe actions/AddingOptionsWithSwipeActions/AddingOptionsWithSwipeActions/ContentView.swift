//
//  ContentView.swift
//  AddingOptionsWithSwipeActions
//
//  Created by James Armer on 01/07/2023.
//

import SwiftUI

/*
 We need a way to move people between the Contacted and Uncontacted tabs, and the easiest thing to do is add a swipe action to the VStack in ProspectsView. This will allow users to swipe on any person in the list, then tap a single option to move them between the tabs.

 Now, remember that this view is shared in three places, so we need to make sure the swipe actions look correct no matter where it’s used. We could try and use a bunch of ternary conditional operators, but later on we’ll add a second button so the ternary operator approach won’t really help much. Instead, we’ll just wrap the button inside a simple condition
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
