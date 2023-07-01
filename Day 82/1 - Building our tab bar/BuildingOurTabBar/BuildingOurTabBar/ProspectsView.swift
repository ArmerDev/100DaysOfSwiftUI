//
//  ProspectsView.swift
//  BuildingOurTabBar
//
//  Created by James Armer on 01/07/2023.
//

import SwiftUI

struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    /*
     Now we can use that to allow each instance of ProspectsView to be slightly different by giving it a new property:
     */
    let filter: FilterType
    
    var body: some View {
        NavigationView {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationTitle(title)
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted People"
        case .uncontacted:
            return "Uncontacted People"
        }
    }
}

/*
 This will immediately break ContentView and ProspectsView_Previews because they need to provide a value for that property when creating ProspectsView, but first let’s use it to customize each of the three views just a little by giving them a navigation bar title.

 Start by adding this computed property to ProspectsView:

 var title: String {
     switch filter {
     case .none:
         return "Everyone"
     case .contacted:
         return "Contacted people"
     case .uncontacted:
         return "Uncontacted people"
     }
 }
 Now replace the default “Hello, World!” body text with this:

 NavigationView {
     Text("Hello, World!")
         .navigationTitle(title)
 }
 That at least makes each of the ProspectsView instances look slightly different so we can be sure the tabs are working correctly.

 To make our code compile again we need to make sure that every ProspectsView initializer is called with a filter. So, in ProspectsView_Previews change the body to this:

 ProspectsView(filter: .none)
 Then change the three ProspectsView instances in ContentView so they have filter: .none, filter: .contacted, and filter: .uncontacted respectively.

 If you run the app now you’ll see it’s looking better. Now for the real challenge: those first three views need to work with the same data, so how can we share it all smoothly? For that we need to turn to SwiftUI’s environment…
 */

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
