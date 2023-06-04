//
//  ContentView.swift
//  AddingACustomStarRatingComponent
//
//  Created by James Armer on 04/06/2023.
//

import SwiftUI

/*
 SwiftUI makes it really easy to create custom UI components, because they are effectively just views that have some sort of @Binding exposed for us to read.

 To demonstrate this, we’re going to build a star rating view that lets the user enter scores between 1 and 5 by tapping images. Although we could just make this view simple enough to work for our exact use case, it’s often better to add some flexibility where appropriate so it can be used elsewhere too. Here, that means we’re going to make six customizable properties:

 What label should be placed before the rating (default: an empty string)
 The maximum integer rating (default: 5)
 The off and on images, which dictate the images to use when the star is highlighted or not (default: nil for the off image, and a filled star for the on image; if we find nil in the off image we’ll use the on image there too)
 The off and on colors, which dictate the colors to use when the star is highlighted or not (default: gray for off, yellow for on)
 We also need one extra property to store an @Binding integer, so we can report back the user’s selection to whatever is using the star rating.

 So, create a new SwiftUI view called “RatingView”
 */

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
           Text("Count: \(books.count)")
               .navigationTitle("Bookworm")
               .toolbar {
                   ToolbarItem(placement: .navigationBarTrailing) {
                       Button {
                           showingAddScreen.toggle()
                       } label: {
                           Label("Add Book", systemImage: "plus")
                       }
                   }
               }
               .sheet(isPresented: $showingAddScreen) {
                   AddBookView()
               }
       }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController()
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
