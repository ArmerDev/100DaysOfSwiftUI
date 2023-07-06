//
//  ContentView.swift
//  BuildAStackOfCards
//
//  Created by James Armer on 06/07/2023.
//

import SwiftUI

/*
 Now that we’ve designed one card and its associated card view, the next step is to build a stack of those cards to represent the things our user is trying to learn. This stack will change as the app is used because the user will be able to remove cards, so we need to mark it with @State.

 Right now we don’t have any way of adding cards, so we’re going to add a stack of 10 using our example card. Swift’s arrays have a helpful initializer, init(repeating:count:), which takes one value and repeats it a number of times to create the array. In our case we can use that with our example Card to create a simple test array.

 So, start by adding this property to ContentView:

    @State private var cards = [Card](repeating: Card.example, count: 10)
 
 Our main ContentView is going to contain a number of overlapping elements inside stacks, but for now we’re just going to put in a rough skeleton:

 - Our stack of cards will be placed inside a ZStack so we can make them partially overlap with a neat 3D effect.
 
 - Around that ZStack will be a VStack. Right now that VStack won’t do much, but later on it will allow us to place a timer above our cards.
 
 - Around that VStack will be another ZStack, so we can place our cards and timer on top of a background.
 
 Right now these stacks probably feel like overkill, but it will make more sense as we progress.

 The only complex part of our next code is how we position the cards inside the card stack so they have slight overlapping. I’ve said it before, but the best way to write SwiftUI code is to carve off any messy calculations so they are handled as methods or modifiers.

 In this case we’re going to create a new stacked() modifier that takes a position in an array along with the total size of the array, and offsets a view by some amount based on those values. This will allow us to create an attractive card stack where each card is a little further down the screen than the ones before it.

 Add this extension to ContentView.swift, outside of the ContentView struct:

 extension View {
     func stacked(at position: Int, in total: Int) -> some View {
         let offset = Double(total - position)
         return self.offset(x: 0, y: offset * 10)
     }
 }
 As you can see, that pushes views down by 10 points for each place they are in the array: 0, then 10, 20, 30, and so on.

 With that simple modifier we can now build a really nice card stack effect using the layout I described earlier. Replace your current body property in ContentView with this:
 */

struct ContentView: View {
    @State private var cards = [Card](repeating: Card.example, count: 10)
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index])
                            .stacked(at: index, in: cards.count)
                    }
                }
            }
        }
    }
}

/*
 When you run that back you’ll see what I mean about the shadows building up as the card depth increases. It looks quite stark against a white background, but if we add a background picture you’ll see it looks better.

 In the GitHub files for this project you’ll see background@2x.jpg and background@3x.jpg – please drag those both into your asset catalog so we can use them.

 Now add this Image view into ContentView, just inside the initial ZStack:

     Image("background")
         .resizable()
         .ignoresSafeArea()
 
 Adding a background image is only a small change, but I think it makes the whole app look better!
 */

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
