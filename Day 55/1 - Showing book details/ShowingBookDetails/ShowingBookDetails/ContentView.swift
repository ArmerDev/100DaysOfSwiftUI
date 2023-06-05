//
//  ContentView.swift
//  ShowingBookDetails
//
//  Created by James Armer on 05/06/2023.
//

import SwiftUI

/*
 When the user taps a book in ContentView we’re going to present a detail view with some more information – the genre of the book, their brief review, and more. We’re also going to reuse our new RatingView, and even customize it so you can see just how flexible SwiftUI is.

 To make this screen more interesting, we’re going to add some artwork that represents each category in our app. I’ve picked out some artwork already from Unsplash, and placed it into the project11-files folder for this book – if you haven’t downloaded them, please do so now and then drag them into your asset catalog.

 Unsplash has a license that allows us to use pictures commercially or non-commercially, with or without attribution, although attribution is appreciated. The pictures I’ve added are by Ryan Wallace, Eugene Triguba, Jamie Street, Alvaro Serrano, Joao Silas, David Dilbert, and Casey Horner – you can get the originals from https://unsplash.com if you want.

 Next, create a new SwiftUI view called “DetailView”. This only needs one property, which is the book it should show, so please add that now:
 
     let book: Book
 
 Even just having that property is enough to break the preview code at the bottom of DetailView.swift. Previously this was easy to fix because we just sent in an example object, but with Core Data involved things are messier: creating a new book also means having a managed object context to create it inside.
 
 comment continues in DetailView
 */

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var books: FetchedResults<Book>
    
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
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
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
