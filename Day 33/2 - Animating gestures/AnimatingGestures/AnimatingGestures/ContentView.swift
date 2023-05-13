//
//  ContentView.swift
//  AnimatingGestures
//
//  Created by James Armer on 13/05/2023.
//

import SwiftUI

/*
 SwiftUI lets us attach gestures to any views, and the effects of those gestures can also be animated. We get a range of gestures to work with, such as tap gestures to let any view respond to taps, drag gestures that respond to us dragging a finger over a view, and more.

 We’ll be looking at gestures in more detail later on, but for now let’s try something relatively simple: a card that we can drag around the screen, but when we let go it snaps back into its original location.
 */

struct ContentView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

/*
 The above code draws a card-like view in the center of the screen. We want to move that around the screen based on the location of our finger, and that requires three steps.

 First, we need some state to store the amount of their drag.
 
 Second, we want to use that size to influence the card’s position on-screen. SwiftUI gives us a dedicated modifier for this called offset(), which lets us adjust the X and Y coordinate of a view without moving other views around it. You can pass in discrete X and Y coordinates if you want to, but – by no mere coincidence – offset() can also take a CGSize directly.

 So, step two is to add this modifier to the card gradient:
 */

struct ContentView2: View {
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(dragAmount)
    }
}

/*
 Now comes the important part: we can create a DragGesture and attach it to the card. Drag gestures have two extra modifiers that are useful to us here: onChanged() lets us run a closure whenever the user moves their finger, and onEnded() lets us run a closure when the user lifts their finger off the screen, ending the drag.

 Both of those closures are given a single parameter, which describes the drag operation – where it started, where it is currently, how far it moved, and so on. For our onChanged() modifier we’re going to read the translation of the drag, which tells us how far it’s moved from the start point – we can assign that directly to dragAmount so that our view moves along with the gesture. For onEnded() we’re going to ignore the input entirely, because we’ll be setting dragAmount back to zero.

 So, add this modifier to the linear gradient now:
 */

struct ContentView3: View {
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in dragAmount = .zero }
            )
    }
}

/*
 If you run the code you’ll see you can now drag the gradient card around, and when you release the drag it will jump back to the center. The card has its offset determined by dragAmount, which in turn is being set by the drag gesture.

 Now that everything works we can bring that movement to life with some animation, and we have two options: add an implicit animation that will animate the drag and the release, or add an explicit animation to animate just the release.

 To see the former in action, add this modifier to the linear gradient:
    .animation(.spring(), value: dragAmount)
 
 As you drag around, the card will move to the drag location with a slight delay because of the spring animation, but it will also gently overshoot if you make sudden movements.
 */

struct ContentView4: View {
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in dragAmount = .zero }
            )
            .animation(.spring(), value: dragAmount)
    }
}

/*
 To see explicit animations in action, remove that animation() modifier and change your existing onEnded() drag gesture code to this:

             .onEnded { _ in
                 withAnimation(.spring()) {
                     dragAmount = .zero
                 }
             }
 
 Now the card will follow your drag immediately (because that’s not being animated), but when you release it will animate.
 */

struct ContentView5: View {
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            dragAmount = .zero
                        }
                    }
            )
    }
}

/*
 If we combine offset animations with drag gestures and a little delay, we can create remarkably fun animations without a lot of code.

 To demonstrate this, we could write the text “Hello SwiftUI” as a series of individual letters, each one with a background color and offset that is controlled by some state. Strings are just slightly fancy arrays of characters, so we can get a real array from a string like this: Array("Hello SwiftUI").

 Anyway, try this out and see what you think:
 */

struct ContentView6: View {
    let letters = Array("Hello SwiftUI")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.default.delay(Double(num) / 20), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded { _ in
                    dragAmount = .zero
                    enabled.toggle()
                }
        )
    }
}

/*
 If you run that code you’ll see that any letter can be dragged around to have the whole string follow suit, with a brief delay causing a snake-like effect. SwiftUI will also add in color changing as you release the drag, animating between blue and red even as the letters move back to the center.
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
        ContentView5()
            .previewDisplayName("ContentView 5")
        ContentView6()
            .previewDisplayName("ContentView 5")
    }
}
