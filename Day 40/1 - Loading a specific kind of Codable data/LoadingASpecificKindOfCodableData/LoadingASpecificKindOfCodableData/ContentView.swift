//
//  ContentView.swift
//  LoadingASpecificKindOfCodableData
//
//  Created by James Armer on 22/05/2023.
//

import SwiftUI

/*
 In this app we’re going to load two different kinds of JSON into Swift structs: one for astronauts, and one for missions. Making this happen in a way that is easy to maintain and doesn’t clutter our code takes some thinking, but we’ll work towards it step by step.

 First, drag in the two JSON files for this project. These are available in the GitHub repository for this book, under “project8-files” – look for astronauts.json and missions.json, then drag them into your project navigator. While we’re adding assets, you should also copy all the images into your asset catalog – these are in the “Images” subfolder. The images of astronauts and mission badges were all created by NASA, so under Title 17, Chapter 1, Section 105 of the US Code they are available for us to use under a public domain license.

 If you look in astronauts.json, you’ll see each astronaut is defined by three fields: an ID (“grissom”, “white”, “chaffee”, etc), their name (“Virgil I. "Gus" Grissom”, etc), and a short description that has been copied from Wikipedia. If you intend to use the text in your own shipping projects, it’s important that you give credit to Wikipedia and its authors and make it clear that the work is licensed under CC-BY-SA available from here: https://creativecommons.org/licenses/by-sa/3.0.

 Let’s convert that astronaut data into a Swift struct now – press Cmd+N to make a new file, choose Swift file, then name it Astronaut.swift. Give it this code:
 */

struct ContentView: View {
    let astronauts = Bundle.main.decode("astronauts.json")
    
    /*
     Yes, that’s all it takes. Sure, all we’ve done is just moved code out of ContentView and into an extension, but there’s nothing wrong with that – anything we can do to help our views stay small and focused is a good thing.

     If you want to double check that your JSON is loaded correctly, modify the default text view to show astronauts.count:
     */
    
    var body: some View {
        Text("\(astronauts.count)")
    }
    
    /*
     That should display 32 rather than “Hello World”.
     */
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
