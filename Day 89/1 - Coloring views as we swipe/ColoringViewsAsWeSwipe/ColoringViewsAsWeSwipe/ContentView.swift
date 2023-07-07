//
//  ContentView.swift
//  ColoringViewsAsWeSwipe
//
//  Created by James Armer on 07/07/2023.
//

import SwiftUI

/*
 Users can swipe our cards left or right to mark them as being guessed correctly or not, but there’s no visual distinction between the two directions. Borrowing controls from dating apps like Tinder, we’ll make swiping right good (they guessed the answer correctly), and swiping left bad (they were wrong).

 We’ll solve this problem in two ways: for a phone with default settings we’ll make the cards become colored green or red before fading away, but if the user enabled the Differentiate Without Color setting we’ll leave the cards as white and instead show some extra UI over our background.

 Let’s start with a first pass on the cards themselves. Right now our card view is created with this background:

     RoundedRectangle(cornerRadius: 25, style: .continuous)
         .fill(.white)
         .shadow(radius: 10)
     
 We’re going to replace that with some more advanced code: we’ll give it a background of the same rounded rectangle except in green or red depending on the gesture movement, then we’ll make the white fill from above fade out as the drag movement gets larger.

 First, the background. Add this directly before the shadow() modifier:

     .background(
         RoundedRectangle(cornerRadius: 25, style: .continuous)
             .fill(offset.width > 0 ? .green : .red)
     )
     
 As for the white fill opacity, this is going to be similar to the opacity() modifier we added previously except we’ll use 1 minus 1/50th of the gesture width rather than 2 minus the gesture width. This creates a really nice effect: we used 2 minus earlier because it meant the card would have to move at least 50 points before fading away, but for the card fill we’re going to use 1 minus so that it starts becoming colored straight away.

 Replace the existing fill() modifier with this:

     .fill(
         .white
             .opacity(1 - Double(abs(offset.width / 50)))
     )
     
 If you run the app now you’ll see that the cards blend from white to either red or green, then start to fade out. Awesome!

 However, as nice as our code is it won’t work well for folks with red/green color blindness – they will see the brightness of the cards change, but it won’t be clear which side is which.

 To fix this we’re going to add an environment property to track whether we should be using color for this purpose or not, then disable the red/green effect when that property is true.

 Start by adding this new property to CardView, before the existing properties:

     @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
     
 Now we can use that for both the fill and background for our RoundedRectangle to make sure we fade out the white smoothly. It’s important we use it for both, because as the card fades out the background color will start to bleed through the fill.

 So, replace your current RoundedRectangle code with this:

     RoundedRectangle(cornerRadius: 25, style: .continuous)
         .fill(
             differentiateWithoutColor
                 ? .white
                 : .white
                     .opacity(1 - Double(abs(offset.width / 50)))

         )
         .background(
             differentiateWithoutColor
                 ? nil
                 : RoundedRectangle(cornerRadius: 25, style: .continuous)
                     .fill(offset.width > 0 ? .green : .red)
         )
         .shadow(radius: 10)
     
 So, when in a default configuration our cards will fade to green or red, but when Differentiate Without Color is enabled that won’t be used. Instead we need to provide some extra UI in ContentView to make it clear which side is positive and which is negative.

 Earlier we made a very particular structure of stacks in ContentView: we had a ZStack, then a VStack, then another ZStack. That first ZStack, the outermost one, allows us to have our background and card stack overlapping, and we’re also going to put some buttons in that stack so users can see which side is “good”.

 First, add this property to ContentView:

     @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
     
 Now add these new views directly after the VStack:

     if differentiateWithoutColor {
         VStack {
             Spacer()

             HStack {
                 Image(systemName: "xmark.circle")
                     .padding()
                     .background(.black.opacity(0.7))
                     .clipShape(Circle())
                 Spacer()
                 Image(systemName: "checkmark.circle")
                     .padding()
                     .background(.black.opacity(0.7))
                     .clipShape(Circle())
             }
             .foregroundColor(.white)
             .font(.largeTitle)
             .padding()
         }
     }
     
 That creates another VStack, this time starting with a spacer so that the images inside the stacks are pushed to the bottom of the screen. And with that condition around them all, they’ll only appear when Differentiate Without Color is enabled, so most of the time our UI stays clear.

 All this extra work matters: it makes sure users get a great experience regardless of their accessibility needs, and that’s what we should always be aiming for.
 */

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @State private var cards = [Card](repeating: Card.example, count: 10)
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                    }
                }
            }
            
            if differentiateWithoutColor {
                VStack {
                    Spacer()
                    
                    HStack {
                        Image(systemName: "xmark.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                        Spacer()
                        Image(systemName: "checkmark.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
    }
    
    func removeCard(at index: Int) {
        cards.remove(at: index)
    }
}

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
