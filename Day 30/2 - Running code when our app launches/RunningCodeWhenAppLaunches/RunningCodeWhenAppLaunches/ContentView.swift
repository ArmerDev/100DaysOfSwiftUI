//
//  ContentView.swift
//  RunningCodeWhenAppLaunches
//
//  Created by James Armer on 11/05/2023.
//

import SwiftUI

/*
 When Xcode builds an iOS project, it puts your compiled program, your asset catalog, and any other assets into a single directory called a bundle, then gives that bundle the name YourAppName.app. This “.app” extension is automatically recognized by iOS and Apple’s other platforms, which is why if you double-click something like Notes.app on macOS it knows to launch the program inside the bundle.
 
 In our game, we’re going to include a file called “start.txt”, which includes over 10,000 eight-letter words that will be randomly selected for the player to work with. This was included in the files for this project that you should have downloaded from GitHub, so please drag start.txt into your project now.
 
 We already defined a property called rootWord, which will contain the word we want the player to spell from. What we need to do now is write a new method called startGame() that will:
 
 1 -Find start.txt in our bundle
 2 - Load it into a string
 3 - Split that string into array of strings, with each element being one word
 4 - Pick one random word from there to be assigned to rootWord, or use a sensible default if the array is empty.
 
 Each of those four tasks corresponds to one line of code, but there’s a twist: what if we can’t locate start.txt in our app bundle, or if we can locate it but we can’t load it? In that case we have a serious problem, because our app is really broken – either we forgot to include the file somehow (in which case our game won’t work), or we included it but for some reason iOS refused to let us read it (in which case our game won’t work, and our app is broken).
 
 Regardless of what caused it, this is a situation that never ought to happen, and Swift gives us a function called fatalError() that lets us respond to unresolvable problems really clearly. When we call fatalError() it will – unconditionally and always – cause our app to crash. It will just die. Not “might die” or “maybe die”: it will always just terminate straight away.
 
 I realize that sounds bad, but what it lets us do is important: for problems like this one, such as if we forget to include a file in our project, there is no point trying to make our app struggle on in a broken state. It’s much better to terminate immediately and give us a clear explanation of what went wrong so we can correct the problem, and that’s exactly what fatalError() does.
 
 Anyway, let’s take a look at the code – I’ve added comments matching the numbers above:
 */

struct ContentView: View {
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
            .onAppear(perform: startGame)
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
    
    func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")
                
                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"
                
                // If we are here everything has worked, so we can exit
                return
            }
        }
        
        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
}

/*
 Now that we have a method to load everything for the game, we need to actually call that thing when our view is shown. SwiftUI gives us a dedicated view modifier for running a closure when a view is shown, so we can use that to call startGame() and get things moving – add this modifier after onSubmit():

 .onAppear(perform: startGame)
 If you run the game now you should see a random eight-letter word at the top of the navigation view. It doesn’t really mean anything yet, because players can still enter whatever words they want. Let’s fix that next…
 */

// ----- Additional Notes --------

// Why do we not include parentheses when using startGame in .onAppear?

/*
 In the line .onAppear(perform: startGame) of your code, you do not need to include the parentheses when passing the startGame function to the perform parameter.

 The reason for this is that the perform parameter expects a closure that takes no arguments and returns Void (i.e., an empty tuple ()). When you pass the startGame function without parentheses, Swift automatically converts the function to a closure with the appropriate signature. This is because functions in Swift are actually closures, and can be passed around and used as values like any other type.

 So, the line .onAppear(perform: startGame) is equivalent to .onAppear(perform: { startGame() }), where the startGame() function is wrapped inside a closure.

 However, if you include the parentheses when passing startGame, like this: .onAppear(perform: startGame()), you would actually be calling the startGame function immediately and passing its return value (which is Void, i.e., an empty tuple ()) to the perform parameter. This is not what you want in this case, since you want the startGame function to be called only when the view appears.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
