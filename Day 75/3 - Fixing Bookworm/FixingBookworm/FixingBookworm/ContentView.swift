//
//  ContentView.swift
//  FixingBookworm
//
//  Created by James Armer on 25/06/2023.
//

import SwiftUI

/*
 In project 11 we built Bookworm, an app that lets users store ratings and descriptions for books they had read, and we also introduced a custom RatingView UI component that showed star ratings from 1 to 5.

 Again, most of the app does well with VoiceOver, but that rating control is a hard fail – it uses tap gestures to add functionality, so users won’t realize they are buttons, and it doesn’t even convey the fact that they are supposed to represent ratings. For example, if I tap one of the gray stars, VoiceOver reads out to me, “star, fill, image, possibly airplane, star” – it’s really not useful at all.

 That in itself is a problem, but it’s extra problematic because our RatingView is designed to be reusable – it’s the kind of thing you can take from this project and use in a dozen other projects, and that just means you end up polluting many apps with poor accessibility.

 We’re going to tackle this one in an unusual way: first with a simpler set of modifiers that do an okay job, but then by seeing how we can use accessibilityAdjustableAction() to get a more optimal result.

 Our initial approach will use three modifiers, each added below the current tapGesture() modifier inside RatingView. First, we need to add one that provides a meaningful label for each star, like this:

 .accessibilityLabel("\(number == 1 ? "1 star" : "\(number) stars")")
 Second, we can remove the .isImage trait, because it really doesn’t matter that these are images:

 .accessibilityRemoveTraits(.isImage)
 And finally, we should tell the system that each star is actually a button, so users know it can be tapped. While we’re here, we can make VoiceOver do an even better job by adding a second trait, .isSelected, if the star is already highlighted.

 So, add this final modifier beneath the previous two:

 .accessibilityAddTraits(number > rating ? .isButton : [.isButton, .isSelected])
 It only took three small changes, but this improved component is much better than what we had before.

 This initial approach works well enough, and it’s certainly the easiest to take because it builds on all the skills you’ve used elsewhere. However, there’s a second approach that I want to look at, because I think it yields a far more useful result – it works more efficiently for folks relying on VoiceOver and other tools.

 First, remove the three modifiers we just added, and instead add these four to the HStack:

 .accessibilityElement()
 .accessibilityLabel(label)
 .accessibilityValue(rating == 1 ? "1 star" : "\(rating) stars")
 .accessibilityAdjustableAction { direction in
     switch direction {
     case .increment:
         if rating < maximumRating { rating += 1 }
     case .decrement:
         if rating > 1 { rating -= 1 }
     default:
         break
     }
 }
 That groups all its children together, applies the label “Rating”, but then adds a value based on the current stars. It also allows that rating value to be adjusted up or down using swipes, which is much better than trying to work through lots of individual images.
 */

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title, order: .reverse
                      )]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink {
                        DetailView(book: book)
                    } label: {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)

                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                    .foregroundColor(book.rating == 1 ? .red : .primary)
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
               .navigationTitle("Bookworm")
               .toolbar {
                   ToolbarItem(placement: .navigationBarTrailing) {
                       Button {
                           showingAddScreen.toggle()
                       } label: {
                           Label("Add Book", systemImage: "plus")
                       }
                   }
                   
                   ToolbarItem(placement: .navigationBarLeading) {
                       EditButton()
                   }
               }
               .sheet(isPresented: $showingAddScreen) {
                   AddBookView()
               }
       }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let book = books[offset]
            
            // delete it from the context
            moc.delete(book)
        }
        
        
        // save the context
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController()
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext,
                          dataController.container.viewContext)
    }
}

