//
//  ContentView.swift
//  AddingToAListOfWords
//
//  Created by James Armer on 11/05/2023.
//

import SwiftUI

/*
 The user interface for this app will be made up of three main SwiftUI views: a NavigationView showing the word they are spelling from, a TextField where they can enter one answer, and a List showing all the words they have entered previously.

 For now, every time users enter a word into the text field, we’ll automatically add it to the list of used words. Later, though, we’ll add some validation to make sure the word hasn’t been used before, can actually be produced from the root word they’ve been given, and is a real word and not just some random letters.

 Let’s start with the basics: we need an array of words they have already used, a root word for them to spell other words from, and a string we can bind to a text field.
 */

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    /*
     As for the body of the view, we’re going to start off as simple as possible: a NavigationView with rootWord for its title, then a couple of sections inside a list:
     */
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        Text(word)
                    }
                }
            }
            .navigationTitle(rootWord)
        }
    }
    
    /*
     Note: Using id: \.self would cause problems if there were lots of duplicates in usedWords, but soon enough we’ll be disallowing that so it’s not a problem.

     Now, our text view has a problem: although we can type into the text box, we can’t submit anything from there – there’s no way of adding our entry to the list of used words.

     To fix that we’re going to write a new method called addNewWord() that will:

     Lowercase newWord and remove any whitespace
     Check that it has at least 1 character otherwise exit
     Insert that word at position 0 in the usedWords array
     Set newWord back to be an empty string
     Later on we’ll add some extra validation between steps 2 and 3 to make sure the word is allowable, but for now this method is straightforward:
     */
    
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // exit if the remaining string is empty
        guard answer.count > 0 else { return }
        
        // extra validation to come
        
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
}

/*
 We want to call addNewWord() when the user presses return on the keyboard, and in SwiftUI we can do that by adding an onSubmit() modifier somewhere in our view hierarchy – it could be directly on the button, but it can be anywhere else in the view because it will be triggered when any text is submitted.

 onSubmit() needs to be given a function that accepts no parameters and returns nothing, which exactly matches the addNewWord() method we just wrote. So, we can pass that in directly by adding this modifier below navigationTitle():
 */

struct ContentView2: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        Text(word)
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
        }
    }
    
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // exit if the remaining string is empty
        guard answer.count > 0 else { return }
        
        // extra validation to come
        
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
}

/*
 Run the app now and you’ll see that things are starting to come together already: we can now type words into the text field, press return, and see them appear in the list.

 Inside addNewWord() we used usedWords.insert(answer, at: 0) for a reason: if we had used append(answer) the new words would have appeared at the end of the list where they would probably be off screen, but by inserting words at the start of the array they automatically appear at the top of the list – much better.

 Before we put a title up in the navigation view, I’m going to make two small changes to our layout.

 First, when we call addNewWord() it lowercases the word the user entered, which is helpful because it means the user can’t add “car”, “Car”, and “CAR”. However, it looks odd in practice: the text field automatically capitalizes the first letter of whatever the user types, so when they submit “Car” what they see in the list is “car”.

 To fix this, we can disable capitalization for the text field with another modifier: textInputAutocapitalization().
 
 The second thing we’ll change, just because we can, is to use Apple’s SF Symbols icons to show the length of each word next to the text. SF Symbols provides numbers in circles from 0 through 50, all named using the format “x.circle.fill” – so 1.circle.fill, 20.circle.fill.

 In this program we’ll be showing eight-letter words to users, so if they rearrange all those letters to make a new word the longest it will be is also eight letters. As a result, we can use those SF Symbols number circles just fine – we know that all possible word lengths are covered.

 So, we can wrap our word text in a HStack, and place an SF Symbol next to it using Image(systemName:)
 */

struct ContentView3: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
        }
    }
    
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // exit if the remaining string is empty
        guard answer.count > 0 else { return }
        
        // extra validation to come
        
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
}

/*
 If you run the app now you’ll see you can type words in the text field, press return, then see them appear in the list with their length icon to the side. Nice!

 Now, if you wanted to we could add one sneaky little extra tweak in here. When we submit our text field right now, the text just appears in the list immediately, but we could animate that by modifying the insert() call inside addNewWord() to this:
 */

struct ContentView4: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
        }
    }
    
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // exit if the remaining string is empty
        guard answer.count > 0 else { return }
        
        // extra validation to come
        
        withAnimation{
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
}

/*
 We haven’t looked at animations just yet, and we’re going to look at them much more shortly, but that change alone will make our new words slide in much more nicely – it’s a big improvement!
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
        ContentView3()
            .previewDisplayName("ContentView 3")
        ContentView4()
            .previewDisplayName("ContentView 4")
    }
}
