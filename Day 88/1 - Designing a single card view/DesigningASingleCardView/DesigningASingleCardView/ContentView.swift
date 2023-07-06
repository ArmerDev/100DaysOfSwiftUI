//
//  ContentView.swift
//  DesigningASingleCardView
//
//  Created by James Armer on 06/07/2023.
//

import SwiftUI

/*
 In this project we want users to see a card with some prompt text for whatever they want to learn, such as “What is the capital city of Scotland?”, and when they tap it we’ll reveal the answer, which in this case is of course Edinburgh.

 A sensible place to start for most projects is to define the data model we want to work with: what does one card of information look like? If you wanted to take this app further you could store some interesting statistics such as number of times shown and number of times correct, but here we’re only going to store a string for the prompt and a string for the answer. To make our lives easier, we’re also going to add an example card as a static property, so we have some test data for previewing and prototyping.

 So, create a new Swift file called Card.swift and navigate there...
 */

struct ContentView: View {
    var body: some View {
        CardView(card: Card.example)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
