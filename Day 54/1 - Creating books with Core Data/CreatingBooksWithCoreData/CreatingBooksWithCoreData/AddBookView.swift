//
//  AddBookView.swift
//  CreatingBooksWithCoreData
//
//  Created by James Armer on 04/06/2023.
//

import SwiftUI

/*
 n terms of properties, we need an environment property to store our managed object context:
 */

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    
    /*
     As this form is going to store all the data required to make up a book, we need @State properties for each of the book’s values except id, which we can generate dynamically. So, add these properties next:
     */

     @State private var title = ""
     @State private var author = ""
     @State private var rating = 3
     @State private var genre = ""
     @State private var review = ""
    
    // Finally, we need one more property to store all possible genre options, so we can make a picker using ForEach
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    // We can now take a first pass at the form itself – we’ll improve it soon, but this is enough for now.
    
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section {
                    TextEditor(text: $review)

                    Picker("Rating", selection: $rating) {
                        ForEach(0..<6) {
                            Text(String($0))
                        }
                    }
                } header: {
                    Text("Write a review")
                }

                Section {
                    Button("Save") {
                        // add the book
                        
                        /*
                         When it comes to filling in the button’s action, we’re going to create an instance of the Book class using our managed object context, copy in all the values from our form (converting rating to an Int16 to match Core Data), then save the managed object context.

                         Most of this work is just copying one value into another, with the only vaguely interesting thing being how we convert from an Int to an Int16 for the rating. Even that is pretty guessable: Int16(someInt) does it all.
                         */
                        
                        let newBook = Book(context: moc)
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.genre = genre
                        newBook.review = review
                        
                        try? moc.save()
                        
                        dismiss()
                        
                    }
                }
            }
            .navigationTitle("Add Book")
        }
    }
}

/*
 That completes the form for now, but we still need a way to show and hide it when books are being added.

 Showing AddBookView involves returning to ContentView.swift and following the usual steps for a sheet:

 Adding an @State property to track whether the sheet is showing.
 Add some sort of button – in the toolbar, in this case – to toggle that property.
 A sheet() modifier that shows AddBookView when the property becomes true.
 Enough talk – let’s start writing some more code. Please start by adding these three properties to ContentView:

 @Environment(\.managedObjectContext) var moc
 @FetchRequest(sortDescriptors: []) var books: FetchedResults<Book>

 @State private var showingAddScreen = false
 That gives us a managed object context we can use later on to delete books, a fetch request reading all the books we have (so we can test everything worked), and a Boolean that tracks whether the add screen is showing or not.

 For the ContentView body, we’re going to use a navigation view so we can add a title plus a button in its top-right corner, but otherwise it will just hold some text showing how many items we have in the books array – just so we can be sure everything is working. Remember, this is where we need to add our sheet() modifier to show an AddBookView as needed.

 Replace the existing body property of ContentView with this:

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
 Tip: That explicitly specifies a trailing navigation bar placement so that we can add a second button later.

 Bear with me – we’re almost done! We’ve now designed our Core Data model, created a form to add data, then updated ContentView so that it can present the form and pass in its managed object context. The final step is to to make the form dismiss itself when the user adds a book.

 We’ve done this before, so hopefully you know the drill. We need to start by adding another environment property to AddBookView to be able to dismiss the current view:

 @Environment(\.dismiss) var dismiss
 Finally, add a call to dismiss() to the end of your button’s action closure.

 You should be able to run the app now and add an example book just fine. When AddBookView slides away the count label should update itself to 1.
 */

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
