//
//  DetailView.swift
//  ShowingBookDetails
//
//  Created by James Armer on 05/06/2023.
//

import CoreData
import SwiftUI

/*
 To fix this, we can update our preview code to create a temporary managed object context, then use that to create our book. Once that’s done we can pass in some example data to make our preview look good, then use the test book to create a detail view preview.

 Creating a managed object context means we need to start by importing Core Data. Add this line near the top of DetailView.swift, next to the existing import:

 import CoreData
 As for the previews code itself, replace whatever you have now with this:

 struct DetailView_Previews: PreviewProvider {
     static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

     static var previews: some View {
         let book = Book(context: moc)
         book.title = "Test book"
         book.author = "Test author"
         book.genre = "Fantasy"
         book.rating = 4
         book.review = "This was a great book; I really enjoyed it."

         return NavigationView {
             DetailView(book: book)
         }
     }
 }
 As you can see, creating a managed object context involves telling the system what concurrency type we want to use. This is another way of saying “which thread do you plan to access your data using?” For our example, using the main queue – that’s the one the app was launched using – is perfectly fine.
 */

/*
 With that done we can turn our attention to more interesting problems, namely designing the view itself. To start with, we’re going to place the category image and genre inside a ZStack, so we can put one on top of the other nicely. I’ve picked out some styling that I think looks good, but you’re welcome to experiment with the styling all you want – the only thing I’d recommend you definitely keep is the ScrollView, which ensures our review will fit fully onto the screen no matter how long it is, what device the user has, or whether they have adjusted their font sizes or not.
 */

struct DetailView: View {
    let book: Book
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre ?? "Fantasy")
                    .resizable()
                    .scaledToFit()

                Text(book.genre?.uppercased() ?? "FANTASY")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }
            
            /*
             That places the genre name in the bottom-right corner of the ZStack, with a background color, bold font, and a little padding to help it stand out.

             Below that ZStack we’re going to add the author, review, and rating. We don’t want users to be able to adjust the rating here, so instead we can use another constant binding to turn this into a simple read-only view. Even better, because we used SF Symbols to create the rating image, we can scale them up seamlessly with a simple font() modifier, to make better use of all the space we have.

             So, add these views directly below the previous ZStack:
             */
            
            Text(book.author ?? "Unknown author")
                .font(.title)
                .foregroundColor(.secondary)

            Text(book.review ?? "No review")
                .padding()

            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
        }
        .navigationTitle(book.title ?? "Unknown Book")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/*
 That completes DetailView, so we can head back to ContentView.swift to change the navigation link so it points to the correct thing:

 NavigationLink {
     DetailView(book: book)
 } label: {
 Now run the app again, because you should be able to tap any of the books you’ve entered to show them in our new detail view.
 */

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."

        return NavigationView {
            DetailView(book: book)
        }
    }
}
