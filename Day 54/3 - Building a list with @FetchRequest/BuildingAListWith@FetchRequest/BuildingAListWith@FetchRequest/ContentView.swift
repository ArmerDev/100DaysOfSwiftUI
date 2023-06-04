//
//  ContentView.swift
//  BuildingAListWith@FetchRequest
//
//  Created by James Armer on 04/06/2023.
//

import SwiftUI

/*
 Right now our ContentView has a fetch request property like this:

 @FetchRequest(sortDescriptors: []) var books: FetchedResults<Book>
 And we’re using it in body with this simple text view:

 Text("Count: \(books.count)")
 To bring this screen to life, we’re going to replace that text view with a List showing all the books that have been added, along with their rating and author.

 We could just use the same star rating view here that we made earlier, but it’s much more fun to try something else. Whereas the RatingView control can be used in any kind of project, we can make a new EmojiRatingView that displays a rating specific to this project. All it will do is show one of five different emoji depending on the rating, and it’s a great example of how straightforward view composition is in SwiftUI – it’s so easy to just pull out a small part of your views in this way.

 So, make a new SwiftUI view called “EmojiRatingView”
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
                        Text(book.title ?? "Unknown Title")
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
