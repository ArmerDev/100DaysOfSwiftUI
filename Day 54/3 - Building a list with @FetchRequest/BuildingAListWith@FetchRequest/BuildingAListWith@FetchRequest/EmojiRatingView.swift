//
//  EmojiRatingView.swift
//  BuildingAListWith@FetchRequest
//
//  Created by James Armer on 04/06/2023.
//

import SwiftUI

struct EmojiRatingView: View {
    let rating: Int16

    var body: some View {
        switch rating {
        case 1:
            Text("1")
        case 2:
            Text("2")
        case 3:
            Text("3")
        case 4:
            Text("4")
        default:
            Text("5")
        }
    }
}

/*
 Tip: I used numbers in my text because emoji can cause havoc with e-readers, but you should replace those with whatever emoji you think represent the various ratings.

 Notice how that specifically uses Int16, which makes interfacing with Core Data easier. And that’s the entire view done – it really is that simple.

 Now we can return to ContentView and do a first pass of its UI. This will replace the existing text view with a list and a ForEach over books. We don’t need to provide an identifier for the ForEach because all Core Data’s managed object class conform to Identifiable automatically, but things are trickier when it comes to creating views inside the ForEach.

 You see, all the properties of our Core Data entity are optional, which means we need to make heavy use of nil coalescing in order to make our code work. We’ll look at an alternative to this soon, but for now we’ll just be scattering ?? around.

 Inside the list we’re going to have a NavigationLink that will eventually point to a detail view, and inside that we’ll have our new EmojiRatingView, plus the book’s title and author. So, go back to ContentView replace the existing text view
 */

struct EmojiRatingView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiRatingView(rating: 3)
    }
}
