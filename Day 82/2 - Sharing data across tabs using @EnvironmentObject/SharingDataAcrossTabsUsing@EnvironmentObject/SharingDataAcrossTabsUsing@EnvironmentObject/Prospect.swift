//
//  Prospect.swift
//  SharingDataAcrossTabsUsing@EnvironmentObject
//
//  Created by James Armer on 01/07/2023.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var isContacted = false
}

/*
 Yes, that’s a class rather than a struct. This is intentional, because it allows us to change instances of the class directly and have it be updated in all other views at the same time. Remember, SwiftUI takes care of propagating that change to our views automatically, so there’s no risk of views getting stale.

 When it comes to sharing that across multiple views, one of the best things about SwiftUI’s environment is that it uses the same ObservableObject protocol we’ve been using with the @StateObject property wrapper. This means we can mark properties that should be announced using the @Published property wrapper – SwiftUI takes care of most of the work for us.

 So, add this class in Prospect.swift:
 */

@MainActor class Prospects: ObservableObject {
    @Published var people: [Prospect]
    
    init() {
        self.people = []
    }
}

/*
 We’ll come back to that later on, not least to make the initializer do more than just create an empty array, but it’s good enough for now.

 Now, we want all our ProspectsView instances to share a single instance of the Prospects class, so they are all pointing to the same data. If we were writing UIKit code here I’d go into long explanation about how difficult this is to get right and how careful we need to be to ensure all changes get propagated cleanly, but with SwiftUI it requires just three steps.

 First, we need to add a property to ContentView that creates and stores a single instance of the Prospects class:

 @StateObject var prospects = Prospects()
 Second, we need to post that property into the SwiftUI environment, so that all child views can access it. Because tabs are considered children of the tab view they are inside, if we add it to the environment for the TabView then all our ProspectsView instances will get that object.

 So, add this modifier to the TabView in ContentView:

 .environmentObject(prospects)
 Important: Make sure you add the same modifier to the preview struct for ProspectsView, so your previews continue working.

 And now we want all instances of ProspectsView to read that object back out of the environment when they are created. This uses a new @EnvironmentObject property wrapper that does all the work of finding the object, attaching it to a property, and keeping it up to date over time. So, the final step is just adding this property to ProspectsView:

 @EnvironmentObject var prospects: Prospects
 That really is all it takes – I don’t think there’s a way SwiftUI could make this any easier.

 Important: When you use @EnvironmentObject you are explicitly telling SwiftUI that your object will exist in the environment by the time the view is created. If it isn’t present, your app will crash immediately – be careful, and treat it like an implicitly unwrapped optional.

 Soon we’re going to be adding code to add prospects by scanning QR codes, but for now we’re going to add a navigation bar item that just adds test data and shows it on-screen.

 Change the body property of ProspectsView to this:

 NavigationView {
     Text("People: \(prospects.people.count)")
         .navigationTitle(title)
         .toolbar {
             Button {
                 let prospect = Prospect()
                 prospect.name = "Paul Hudson"
                 prospect.emailAddress = "paul@hackingwithswift.com"
                 prospects.people.append(prospect)
             } label: {
                 Label("Scan", systemImage: "qrcode.viewfinder")
             }
         }
 }
 Now you’ll see a “Scan” button on the first three views of our tab view, and tapping it adds a person to all three simultaneously – you’ll see the count increment no matter which button you tap.
 */
