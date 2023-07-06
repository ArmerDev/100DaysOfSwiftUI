//
//  CardView.swift
//  MovingViewsWithDragGestureAndOffset()
//
//  Created by James Armer on 06/07/2023.
//

import SwiftUI

/*
 First, add this new @State property to CardView, to track how far the user has dragged:

    @State private var offset = CGSize.zero
 
 Next we’re going to add three modifiers to CardView, placed directly below the frame() modifier. Remember: the order in which you apply modifiers matters, and nowhere is this more true than when working with offsets and rotations.

 If we rotate then offset, then the offset is applied based on the rotated axis of our view. For example, if we move something 100 pixels to its left then rotate 90 degrees, we’d end up with it being 100 pixels to the left and rotated 90 degrees. But if we rotated 90 degrees then moved it 100 pixels to its left, we’d end up with something rotated 90 degrees and moved 100 pixels directly down, because its concept of “left” got rotated.

 Where things get doubly tricky is when you factor in how SwiftUI creates new views by wrapping modifiers. When it comes to moving and rotating, this means if we want a view to slide directly to true west (regardless of its rotation) while also rotating it, we need to put the rotation first then the offset.

 Now, offset.width will contain how far the user dragged our card, but we don’t want to use that for our rotation because the card would spin too fast So, instead add this modifier below frame(), so we use 1/5th of the drag amount:

    .rotationEffect(.degrees(Double(offset.width / 5)))
 
 Next we’re going to apply our movement, so the card slides relative to the horizontal drag amount. Again, we’re not going to use the original value of offset.width because it would require the user to drag a long way to get any meaningful results, so instead we’re going to multiply it by 5 so the cards can be swiped away with small gestures.

 Add this modifier below the previous one:

    .offset(x: offset.width * 5, y: 0)
 
 While we’re here, I want to add one more modifier based on the drag gesture: we’re going to make the card fade out as it’s dragged further away.

 Now, the calculation for this view takes a little thinking, and I wouldn’t blame you if you wanted to spin this off into a method rather than putting it inline. Here’s how it works:

 - We’re going to take 1/50th of the drag amount, so the card doesn’t fade out too quickly.
 
 - We don’t care whether they have moved to the left (negative numbers) or to the right (positive numbers), so we’ll put our value through the abs() function. If this is given a positive number it returns the same number, but if it’s given a negative number it removes the negative sign and returns the same value as a positive number.
 
 - We then use this result to subtract from 2.
 
 The use of 2 there is intentional, because it allows the card to stay opaque while being dragged just a little. So, if the user hasn’t dragged at all the opacity is 2.0, which is identical to the opacity being 1. If they drag it 50 points left or right, we divide that by 50 to get 1, and subtract that from 2 to get 1, so the opacity is still 1 – the card is still fully opaque. But beyond 50 points we start to fade out the card, until at 100 points left or right the opacity is 0.

 Add this modifier below the previous two:

    .opacity(2 - Double(abs(offset.width / 50)))
 
 So, we’ve created a property to store the drag amount, and added three modifiers that use the drag amount to change the way the view is rendered. What remains is the most important part: we need to actually attach a DragGesture to our card so that it updates offset as the user drags the card around. Drag gestures have two useful modifiers of their own, letting us attach functions to be triggered when the gesture has changed (called every time they move their finger), and when the gesture has ended (called when they lift their finger).

 Both of these functions are handed the current gesture state to evaluate. In our case we’ll be reading the translation property to see where the user has dragged to, and we’ll be using that to set our offset property, but you can also read the start location, predicted end location, and more. When it comes to the ended function, we’ll be checking whether the user moved it more than 100 points in either direction so we can prepare to remove the card, but if they haven’t we’ll set offset back to 0.

 Add this gesture() modifier below the previous three:

     .gesture(
         DragGesture()
             .onChanged { gesture in
                 offset = gesture.translation
             }
             .onEnded { _ in
                 if abs(offset.width) > 100 {
                     // remove the card
                 } else {
                     offset = .zero
                 }
             }
     )
 
 Go ahead and run the app now: you should find the cards move, rotate, and fade away as they are dragged, and if you drag more than a certain distance they stay away rather than jumping back to their original location.

 This works well, but to really finish this step we need to fill in the // remove the card comment so the card actually gets removed in the parent view. Now, we don’t want CardView to call up to ContentView and manipulate its data directly, because that causes spaghetti code. Instead, a better idea is to store a closure parameter inside CardView that can be filled with whatever code we want later on – it means we have the flexibility to get a callback in ContentView without explicitly tying the two views together.

 So, add this new property to CardView below its existing card property:

     var removal: (() -> Void)? = nil
 
 As you can see, that’s a closure that accepts no parameters and sends nothing back, defaulting to nil so we don’t need to provide it unless it’s explicitly needed.

 Now we can replace // remove the card with a call to that closure:

    removal?()
 
 Tip: That question mark in there means the closure will only be called if it has been set.

 Back in ContentView we can now write a method to handle removing a card, then connect it to that closure.

 First, add this method that takes an index in our cards array and removes that item:

     func removeCard(at index: Int) {
         cards.remove(at: index)
     }
 
 Finally, we can update the way we create CardView so that we use trailing closure syntax to remove the card when it’s dragged more than 100 points. This is just a matter of calling the removeCard(at:) method we just wrote, but if we wrap that inside a withAnimation() call then the other cards will automatically slide up.

 Here’s how your code should look:

     ForEach(0..<cards.count, id: \.self) { index in
         CardView(card: cards[index]) {
            withAnimation {
                removeCard(at: index)
            }
         }
         .stacked(at: index, in: cards.count)
     }
     
 Go ahead and run the app now – I think the result really looks great, and you can now swipe your way through all the cards in the stack until you reach the end!
 */

struct CardView: View {
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    
    let card: Card
    var removal: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)
                .shadow(radius: 10)
            
            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                
                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        removal?()
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
    }
}

struct CardView_Preview: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}

