//
//  ContentView.swift
//  WhyModifierOrderMatters
//
//  Created by James Armer on 05/05/2023.
//

import SwiftUI

/*
 Whenever we apply a modifier to a SwiftUI view, we actually create a new view with that change applied – we don’t just modify the existing view in place. If you think about it, this behaviour makes sense: our views only hold the exact properties we give them, so if we set the background color or font size there is no place to store that data.

 We’re going to look at why this happens shortly, but first I want to look at the practical implications of this behaviour. Take a look at this code:
 */

struct ContentView: View {
    var body: some View {
        Button("Hello, world!") {
            // do nothing
        }
        .background(.red)
        .frame(width: 200, height: 200)
    }
}

/*
With the above code, you won’t see a 200x200 red button with "Hello, world!" in the middle. Instead, you’ll see a 200x200 empty square, with "Hello, world!" in the middle and with a red rectangle directly around "Hello, world!".
 
 You can understand what’s happening here if you think about the way modifiers work: each one creates a new struct with that modifier applied, rather than just setting a property on the view.

 You can peek into the underbelly of SwiftUI by asking for the type of our view’s body. Modify the button to this:
 
 (Be sure to run this using the simulator, as the Previews console will show AnyView instead)
 */

struct ContentView2: View {
    var body: some View {
        Button("Hello, world!") {
            print(type(of: self.body))
        }
        .background(.red)
        .frame(width: 200, height: 200)
    }
}

/*
 Swift’s type(of:) method prints the exact type of a particular value, and in this instance it will print the following: ModifiedContent<ModifiedContent<Button<Text>, _BackgroundStyleModifier<Color>>, _FrameLayout>

 You can see two things here:

 Every time we modify a view SwiftUI applies that modifier by using generics: ModifiedContent<OurThing, OurModifier>.
 When we apply multiple modifiers, they just stack up: ModifiedContent<ModifiedContent<…
 To read what the type is, start from the innermost type and work your way out:

 The innermost type is ModifiedContent<Button<Text>, _BackgroundStyleModifier<Color>: our button has some text with a background color applied.
 Around that we have ModifiedContent<…, _FrameLayout>, which takes our first view (button + background color) and gives it a larger frame.
 As you can see, we end with ModifiedContent types stacking up – each one takes a view to transform plus the actual change to make, rather than modifying the view directly.

 What this means is that the order of your modifiers matter. If we rewrite our code to apply the background color after the frame, then you might get the result you expected:
 */

struct ContentView3: View {
    var body: some View {
        Button("Hello, world!") {
            print(type(of: self.body))
        }
        .background(.red)
        .frame(width: 200, height: 200)
    }
}

/*
 The best way to think about it for now is to imagine that SwiftUI renders your view after every single modifier. So, as soon as you say .background(.red) it colors the background in red, regardless of what frame you give it. If you then later expand the frame, it won’t magically redraw the background – that was already applied.

 Of course, this isn’t actually how SwiftUI works, because if it did it would be a performance nightmare, but it’s a neat mental shortcut to use while you’re learning.

 An important side effect of using modifiers is that we can apply the same effect multiple times: each one simply adds to whatever was there before.

 For example, SwiftUI gives us the padding() modifier, which adds a little space around a view so that it doesn’t push up against other views or the edge of the screen. If we apply padding then a background color, then more padding and a different background color, we can give a view multiple borders, like this:
 */

struct ContentView4: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .background(.red)
            .padding()
            .background(.blue)
            .padding()
            .background(.green)
            .padding()
            .background(.yellow)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
        ContentView3()
            .previewDisplayName("ContentView 3")
        ContentView4()
            .previewDisplayName("ContentView 4")
    }
}
