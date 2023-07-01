//
//  ContentView.swift
//  SharingDataAcrossTabsUsing@EnvironmentObject
//
//  Created by James Armer on 01/07/2023.
//

import SwiftUI

/*
 SwiftUI’s environment lets us share data in a really beautiful way: any view can send objects into the environment, then any child view can read those objects back out from the environment at a later date. Even better, if one view changes the object all other views automatically get updated – it’s an incredibly smart way to share data in larger applications.

 In our app we have a TabView that contains three instances of ProspectsView, and we want all three of those to work as different views on the same shared data. This is a great example of where SwiftUI’s environment makes sense: we can define a class that stores one prospect, then place an array of those prospects into the environment so all our views can read it if needed.

 So, start by making a new Swift file called Prospect.swift, replacing its Foundation import with SwiftUI, then update its code:
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
