//
//  ContentView.swift
//  DeletingFromACoreDataFetchRequest
//
//  Created by James Armer on 06/06/2023.
//

import SwiftUI

/*
 We already used @FetchRequest to place Core Data objects into a SwiftUI List, and with only a little more work we can enable both swipe to delete and a dedicated Edit/Done button.

 Just as with regular arrays of data, most of the work is done by attaching an onDelete(perform:) modifier to ForEach, but rather than just removing items from an array we instead need to find the requested object in our fetch request then use it to call delete() on our managed object context. Once all the objects are deleted we can trigger another save of the context; without that the changes won’t actually be written out to disk.

 So, start by adding this method to ContentView:

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
 We can trigger that by adding an onDelete(perform:) modifier to the ForEach of ContentView, but remember: it needs to go on the ForEach and not the List.

 Add this modifier now:

 .onDelete(perform: deleteBooks)
 That gets us swipe to delete, and we can go one better by adding an Edit/Done button too. Find the toolbar() modifier in ContentView, and add another ToolbarItem:

 ToolbarItem(placement: .navigationBarLeading) {
     EditButton()
 }
 That completes ContentView, so try running the app – you should be able to add and delete books freely now, and can delete by using swipe to delete or using the edit button.
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
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}

