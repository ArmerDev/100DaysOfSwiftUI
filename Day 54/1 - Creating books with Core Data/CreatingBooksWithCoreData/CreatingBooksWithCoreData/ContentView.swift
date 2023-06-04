//
//  ContentView.swift
//  CreatingBooksWithCoreData
//
//  Created by James Armer on 04/06/2023.
//

import SwiftUI

/*
 Our first task in this project will be to design a Core Data model for our books, then creating a new view to add books to the database.

 First, the model: open Bookworm.xcdatamodeld and add a new entity called “Book” – we’ll create one new object in there for each book the user has read. In terms of what constitutes a book, I’d like you to add the following attributes:

 id, UUID – a guaranteed unique identifier we can use to distinguish between books
 title, String – the title of the book
 author, String – the name of whoever wrote the book
 genre, String – one of several strings from the genres in our app
 review, String – a brief overview of what the user thought of the book
 rating, Integer 16 – the user’s rating for this book
 Most of those should make sense, but the last one is an odd one: “integer 16”. What is the 16? And how come there are also Integer 32 and Integer 64? Well, just like Float and Double the difference is how much data they can store: Integer 16 uses 16 binary digits (“bits”) to store numbers, so it can hold values from -32,768 up to 32,767, whereas Integer 32 uses 32 bits to store numbers, so it hold values from -2,147,483,648 up to 2,147,483,647. As for Integer 64… well, that’s a really large number – about 9 quintillion.

 The point is that these values aren’t interchangeable: you can’t take the value from a 64-bit number and try to store it in a 16-bit number, because you’d probably lose data. On the other hand, it’s a waste of space to use 64-bit integers for values we know will always be small. As a result, Core Data gives us the option to choose just how much storage we want.

 Our next step is to write a form that can create new entries. This will combine so many of the skills you’ve learned so far: Form, @State, @Environment, TextField, TextEditor, Picker, sheet(), and more, plus all your new Core Data knowledge.

 Start by creating a new SwiftUI view called “AddBookView”.
 
 - Comment continues in AddBookView
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
