//
//  ContentView.swift
//  SortingFetchRequestsWithSortDescriptor
//
//  Created by James Armer on 06/06/2023.
//

import SwiftUI

/*
 When you use SwiftUI’s @FetchRequest property wrapper to pull objects out of Core Data, you get to specify how you want the data to be sorted – should it be alphabetically by one of the fields? Or numerically with the highest numbers first? We specified an empty array, which might work OK for a handful of items but after 20 or so will just annoy the user.

 In this project we have various fields that might be useful for sorting purposes: the title of the book, the author, or the rating are all sensible and would be good choices, but I suspect title is probably the most common so let’s use that.

 Fetch request sorting is performed using a new type called SortDescriptor, and we can create them from either one or two values: the attribute we want to sort on, and optionally whether it should be reversed or not. For example, we can alphabetically sort on the title attribute like this:

 @FetchRequest(sortDescriptors: [
     SortDescriptor(\.title)
 ]) var books: FetchedResults<Book>
 Sorting is done in ascending order by default, meaning alphabetical order for text, but if you wanted to reverse the sort order you’d use this instead:

 SortDescriptor(\.title, order: .reverse)
 
 You can specify more than one sort descriptor, and they will be applied in the order you provide them. For example, if the user added the book “Forever” by Pete Hamill, then added “Forever” by Judy Blume – an entirely different book that just happens to have the same title – then specifying a second sort field is helpful.

 So, we might ask for book title to be sorted ascending first, followed by book author ascending second, like this:

 @FetchRequest(sortDescriptors: [
     SortDescriptor(\.title),
     SortDescriptor(\.author)
 ]) var books: FetchedResults<Book>
 
 Having a second or even third sort field has little to no performance impact unless you have lots of data with similar values. With our books data, for example, almost every book will have a unique title, so having a secondary sort field is more or less irrelevant in terms of performance.
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
