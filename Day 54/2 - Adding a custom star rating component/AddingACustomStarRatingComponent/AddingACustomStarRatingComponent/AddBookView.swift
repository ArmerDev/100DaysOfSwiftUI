//
//  AddBookView.swift
//  AddingACustomStarRatingComponent
//
//  Created by James Armer on 04/06/2023.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    
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
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                /*
                 That’s all it takes – our default values are sensible, so it looks great out of the box. And the result is much nicer to use: there’s no need to tap into a detail view with a picker here, because star ratings are more natural and more common.
                 */

                Section {
                    Button("Save") {
                        
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


struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
