//
//  ContentView.swift
//  UsingAnAlertToPopANavigationLinkProgrammatically
//
//  Created by James Armer on 06/06/2023.
//

import SwiftUI

/*
 You’ve already seen how NavigationLink lets us push to a detail screen, which might be a custom view or one of SwiftUI’s built-in types such as Text or Image. Because we’re inside a NavigationView, iOS automatically provides a “Back” button to let users get back to the previous screen, and they can also swipe from the left edge to go back. However, sometimes it’s useful to programmatically go back – i.e., to move back to the previous screen when we want rather than when the user swipes.

 To demonstrate this, we’re going to add one last feature to our app that deletes whatever book the user is currently looking at. To do this we need to show an alert asking the user if they really want to delete the book, then delete the book from the current managed object context if that’s what they want. Once that’s done, there’s no point staying on the current screen because its associated book doesn’t exist any more, so we’re going to pop the current view – remove it from the top of the NavigationView stack, so we move back to the previous screen.

 First, we need three new properties in our DetailView struct: one to hold our Core Data managed object context (so we can delete stuff), one to hold our dismiss action (so we can pop the view off the navigation stack), and one to control whether we’re showing the delete confirmation alert or not.

 So, start by adding these three new properties to DetailView:

 @Environment(\.managedObjectContext) var moc
 @Environment(\.dismiss) var dismiss
 @State private var showingDeleteAlert = false
 The second step is writing a method that deletes the current book from our managed object context, and dismisses the current view. It doesn’t matter that this view is being shown using a navigation link rather than a sheet – we still use the same dismiss() code.

 Add this method to DetailView now:

 func deleteBook() {
     moc.delete(book)

     // uncomment this line if you want to make the deletion permanent
     // try? moc.save()
     dismiss()
 }
 The third step is to add an alert() modifier that watches showingDeleteAlert, and asks the user to confirm the action. So far we’ve been using simple alerts with a dismiss button, but here we need two buttons: one button to delete the book, and another to cancel. Both of these have specific button roles that automatically make them look correct, so we’ll use those.

 Apple provides very clear guidance on how we should label alert text, but it comes down to this: if it’s a simple “I understand” acceptance then “OK” is good, but if you want users to make a choice then you should avoid titles like “Yes” and “No” and instead use verbs such as “Ignore”, “Reply”, and “Confirm”.

 In this instance, we’re going to use “Delete” for the destructive button, then provide a cancel button next to it so users can back out of deleting if they want. So, add this modifier to the ScrollView in DetailView:

 .alert("Delete book", isPresented: $showingDeleteAlert) {
     Button("Delete", role: .destructive, action: deleteBook)
     Button("Cancel", role: .cancel) { }
 } message: {
     Text("Are you sure?")
 }
 The final step is to add a toolbar item that starts the deletion process – this just needs to flip the showingDeleteAlert Boolean, because our alert() modifier is already watching it. So, add this one last modifier to the ScrollView:

 .toolbar {
     Button {
         showingDeleteAlert = true
     } label: {
         Label("Delete this book", systemImage: "trash")
     }
 }
 You can now delete books in ContentView using swipe to delete or the edit button, or navigate into DetailView then tap the dedicated delete button in there – it should delete the book, update the list in ContentView, then automatically dismiss the detail view.

 That’s another app complete – good job!
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

