//
//  ContentView.swift
//  BuildingOurTabBar
//
//  Created by James Armer on 01/07/2023.
//

import SwiftUI

/*
 This app is going to display four SwiftUI views inside a tab bar: one to show everyone that you met, one to show people you have contacted, another to show people you haven’t contacted, and a final one showing your personal information for others to scan.

 Those first three views are variations on the same concept, but the last one is quite different. As a result, we can represent all our UI with just three views: one to display people, one to show our data, and one to bring all the others together using TabView.

 So, our first step will be to create placeholder views for our tabs that we can come back and fill in later. Press Cmd+N to make a new SwiftUI view and call it “ProspectsView”, then create another SwiftUI view called “MeView”. You can leave both of them with the default “Hello, World!” text view; it doesn’t matter for now.

 For now, what matters is ContentView, because that’s where we’re going to store our TabView that contains all the other views in our UI. We’re going to add some more logic here shortly, but for now this is just going to be a TabView with three instances of ProspectsView and one MeView. Each of those views will have a tabItem() modifier with an image that I picked out from SF Symbols and some text.

 Replace the body of your current ContentView with this:
 */

struct ContentView: View {
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
    }
}

/*
 If you run the app now you’ll see a neat tab bar across the bottom of the screen, allowing us to tap through each of our four views.

 Now, obviously creating three instances of ProspectsView will be weird in practice because they’ll just be identical, but we can fix that by customizing each view. Remember, we want the first one to show every person you’ve met, the second to show people you have contacted, and the third to show people you haven’t contacted, and we can represent that with an enum plus a property on ProspectsView.

 So, go to ProspectsView and add this enum :
 
 enum FilterType {
     case none, contacted, uncontacted
 }
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
