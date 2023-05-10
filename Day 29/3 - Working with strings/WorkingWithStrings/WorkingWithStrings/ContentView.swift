//
//  ContentView.swift
//  WorkingWithStrings
//
//  Created by James Armer on 10/05/2023.
//

import SwiftUI

/*
 iOS gives us some really powerful APIs for working with strings, including the ability to split them into an array, remove whitespace, and even check spellings. We’ve looked at some of these previously, but there’s at least one major addition I want to look at.

 In this app, we’re going to be loading a file from our app bundle that contains over 10,000 eight-letter words, each of which can be used to start the game. These words are stored one per line, so what we really want is to split that string up into an array of strings in order that we can pick one randomly.

 Swift gives us a method called components(separatedBy:) that can converts a single string into an array of strings by breaking it up wherever another string is found. For example, the method test() will create the array ["a", "b", "c"]:
 */

struct ContentView: View {
    var body: some View {
        Text("Hello World")
    }
    
    func test() {
        let input = "a b c"
        let letters = input.components(separatedBy: " ")
    }
}

/*
 Below we have a string where words are separated by line breaks, so to convert that into a string array we need to split on line breaks.

 In programming – almost universally, I think – we use a special character sequence to represent line breaks: \n. So, we would write code like this:
 */

struct ContentView2: View {
    var body: some View {
        Text("Hello World")
    }
    
    func test() {
        let input = """
                    a
                    b
                    c
                    """
        let letters = input.components(separatedBy: "\n")
        
        /*
         Regardless of what string we split on, the result will be an array of strings. From there we can read individual values by indexing into the array, such as letters[0] or letters[2], but Swift gives us a useful other option: the randomElement() method returns one random item from the array.

         For example, this will read a random letter from our array:
         */
        let letter = letters.randomElement()
        /*
         Now, although we can see that the letters array will contain three items, Swift doesn’t know that – perhaps we tried to split up an empty string, for example. As a result, the randomElement() method returns an optional string, which we must either unwrap or use with nil coalescing.
         
         Another useful string method is trimmingCharacters(in:), which asks Swift to remove certain kinds of characters from the start and end of a string. This uses a new type called CharacterSet, but most of the time we want one particular behavior: removing whitespace and new lines – this refers to spaces, tabs, and line breaks, all at once.

         This behavior is so common it’s built right into the CharacterSet struct, so we can ask Swift to trim all whitespace at the start and end of a string like this:
         */
        
        let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

/*
 There’s one last piece of string functionality I’d like to cover before we dive into the main project, and that is the ability to check for misspelled words.

 This functionality is provided through the class UITextChecker. You might not realize this, but the “UI” part of that name carries two additional meanings with it:

 This class comes from UIKit. That doesn’t mean we’re loading all the old user interface framework, though; we actually get it automatically through SwiftUI.
 It’s written using Apple’s older language, Objective-C. We don’t need to write Objective-C to use it, but there is a slightly unwieldy API for Swift users.
 Checking a string for misspelled words takes four steps in total. First, we create a word to check and an instance of UITextChecker that we can use to check that string:
 */

struct ContentView3: View {
    var body: some View {
        Text("Hello World")
    }
    
    func test() {
        let word = "swift"
        let checker = UITextChecker()
        
        /*
         Second, we need to tell the checker how much of our string we want to check. If you imagine a spellchecker in a word processing app, you might want to check only the text the user selected rather than the entire document.

         However, there’s a catch: Swift uses a very clever, very advanced way of working with strings, which allows it to use complex characters such as emoji in exactly the same way that it uses the English alphabet. However, Objective-C does not use this method of storing letters, which means we need to ask Swift to create an Objective-C string range using the entire length of all our characters, like this:
         */
        
        let range = NSRange(location: 0, length: word.utf16.count)
        
        /*
         UTF-16 is what’s called a character encoding – a way of storing letters in a string. We use it here so that Objective-C can understand how Swift’s strings are stored; it’s a nice bridging format for us to connect the two.

         Third, we can ask our text checker to report where it found any misspellings in our word, passing in the range to check, a position to start within the range (so we can do things like “Find Next”), whether it should wrap around once it reaches the end, and what language to use for the dictionary:
         */
        
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        /*
         That sends back another Objective-C string range, telling us where the misspelling was found. Even then, there’s still one complexity here: Objective-C didn’t have any concept of optionals, so instead relied on special values to represent missing data.

         In this instance, if the Objective-C range comes back as empty – i.e., if there was no spelling mistake because the string was spelled correctly – then we get back the special value NSNotFound.

         So, we could check our spelling result to see whether there was a mistake or not like this:
         */
        
        let allGood = misspelledRange.location == NSNotFound
    }
}

// OK, that’s enough API exploration – let’s get into our actual project…
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
