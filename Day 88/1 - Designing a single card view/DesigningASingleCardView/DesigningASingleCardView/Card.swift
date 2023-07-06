//
//  Card.swift
//  DesigningASingleCardView
//
//  Created by James Armer on 06/07/2023.
//

import Foundation

struct Card {
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}


/*
 In terms of showing that in a SwiftUI view, we need something slightly more complicated: yes there will be two text labels shown one above the other, but we also need to show a white card behind them to bring our UI to life, then add just a touch of padding to the text so it doesn’t quite go to the edge of the card behind it. In SwiftUI terms this means a VStack for the two labels, inside a ZStack with a white RoundedRectangle.

 I don’t know if you’ve used flashcards to learn before, but they have a very particular shape that makes them wider than they are high. This makes sense if you think about it: you’re usually only writing two or three lines of text, so it’s more natural to write long-ways than short-ways.

 All our apps so far haven’t really cared about device orientation, but we’re going to make this one work only in landscape. This gives us more room to draw our cards, and it will also work better once we introduce gestures later on.

 To force landscape mode, go to your target options in the Info tab, open the disclosure indicator for the key “Supported interface orientations (iPhone)” and delete the portrait option so it leaves just the two landscape options.

 With that done we can take our first pass at a view to represent one card in our app. Create a new SwiftUI view called “CardView” and navigate there...:
 */
