//
//  ContentView.swift
//  ControllingTheAnimationStack
//
//  Created by James Armer on 13/05/2023.
//

import SwiftUI

/*
 At this point, I want to put together two things that you already understand individually, but together might hurt your head a little.

 Previously we looked at how the order of modifiers matters. So, if we wrote code like this:
 */



struct ContentView: View {
    var body: some View {
        Button("Tap Me") {
            // do nothing
        }
        .background(.blue)
        .frame(width: 200, height: 200)
        .foregroundColor(.white)
    }
}

/*
 The result would look different from code like this:
 */

struct ContentView2: View {
    var body: some View {
        Button("Tap Me") {
            // do nothing
        }
        .frame(width: 200, height: 200)
        .background(.blue)
        .foregroundColor(.white)
    }
}

/*
 This is because if we color the background before adjusting the frame, only the original space is colored rather than the expanded space. If you recall, the underlying reason for this is the way SwiftUI wraps views with modifiers, allowing us to apply the same modifier multiple times – we repeated background() and padding() several times to create a striped border effect.

 That’s concept one: modifier order matters, because SwiftUI wraps views with modifiers in the order they are applied.

 Concept two is that we can apply an animation() modifier to a view in order to have it implicitly animate changes.

 To demonstrate this, we could modify our button code so that it shows different colors depending on some state.
 
 First, we define the state, and then in the button's action we will toggle that state property boolean. After that, we can use a conditional value inside the background() modifier so the button is either blue or red. Finally, we add the animation() modifier to the button to make those changes animate:
 */

struct ContentView3: View {
    @State private var enabled = false
    
    var body: some View {
        Button("Tap Me") {
            enabled.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled ? .blue : .red)
        .foregroundColor(.white)
        .animation(.default, value: enabled)
    }
}

/*
 If you run the code you’ll see that tapping the button animates its color between blue and red.

 So: order modifier matters and we can attach one modifier several times to a view, and we can cause implicit animations to occur with the animation() modifier. All clear so far?

 Right. Brace yourself, because this might hurt.

 You can attach the animation() modifier several times, and the order in which you use it matters.

 To demonstrate this, we will add the clipShape modifier to the button, after all the other modifiers:
 */

struct ContentView4: View {
    @State private var enabled = false
    
    var body: some View {
        Button("Tap Me") {
            enabled.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled ? .blue : .red)
        .foregroundColor(.white)
        .animation(.default, value: enabled)
        .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
    }
}

/*
 The above code will cause the button to move between a square and a rounded rectangle depending on the state of the enabled Boolean.

 When you run the program, you’ll see that tapping the button causes it to animate between red and blue, but jump between square and rounded rectangle – that part doesn’t animate.
 
 Hopefully you can see where we’re going next: Let's move the clipShape() modifier before the animation, like this:
 */

struct ContentView5: View {
    @State private var enabled = false
    
    var body: some View {
        Button("Tap Me") {
            enabled.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled ? .blue : .red)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
        .animation(.default, value: enabled)
    }
}

/*
 And now when you run the code both the background color and clip shape animate.

 So, the order in which we apply animations matters: only changes that occur before the animation() modifier get animated.

 Now for the fun part: if we apply multiple animation() modifiers, each one controls everything before it up to the next animation. This allows us to animate state changes in all sorts of different ways rather than uniformly for all properties.

 For example, we could make the color change happen with the default animation, but use an interpolating spring for the clip shape:
 */

struct ContentView6: View {
    @State private var enabled = false
    
    var body: some View {
        Button("Tap Me") {
            enabled.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled ? .blue : .red)
        .animation(.default, value: enabled)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
        .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled)
    }
}

/*
 You can have as many animation() modifiers as you need to construct your design, which lets us split one state change into as many segments as we need.

 For even more control, it’s possible to disable animations entirely by passing nil to the modifier. For example, you might want the color change to happen immediately but the clip shape to retain its animation, in which case you’d write this:
 */

struct ContentView7: View {
    @State private var enabled = false
    
    var body: some View {
        Button("Tap Me") {
            enabled.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled ? .blue : .red)
        .animation(nil, value: enabled)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
        .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled)
    }
}

/*
 That kind of control wouldn’t be possible without multiple animation() modifiers – if you tried to move background() after the animation you’d find that it would just undo the work of clipShape().
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
            .previewDisplayName("ContentView 6")
        ContentView7()
            .previewDisplayName("ContentView 7")
    }
}
