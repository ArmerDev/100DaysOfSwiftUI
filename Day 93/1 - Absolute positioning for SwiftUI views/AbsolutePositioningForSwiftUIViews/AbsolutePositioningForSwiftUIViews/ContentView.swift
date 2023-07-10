//
//  ContentView.swift
//  AbsolutePositioningForSwiftUIViews
//
//  Created by James Armer on 10/07/2023.
//

import SwiftUI

/*
 SwiftUI gives us two ways of positioning views: absolute positions using position(), and relative positions using offset(). They might seem similar, but once you understand how SwiftUI places views inside frames the underlying differences between position() and offset() become clearer.

 A simple SwiftUI view looks like this:
 */

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
    }
}

/*
 SwiftUI offers the full available space to ContentView, which in turn passes it on to the text view. The text view automatically uses only as much as space as its text needs, so it passes that back up to ContentView, which is always and exactly the same size as its body (so it directly fits around the text). As a result, SwiftUI centers ContentView in the available space, which from a user’s perspective is what places the text in the center.

 If you want to absolutely position a SwiftUI view you should use the position() modifier like this:
 */

struct ContentView2: View {
    var body: some View {
        Text("Hello, world!")
            .position(x: 100, y: 100)
    }
}

/*
 That will position the text view at x:100 y:100 within its parent. Now, to really see what’s happening here I want you to add a background color:
 */

struct ContentView3: View {
    var body: some View {
        Text("Hello, world!")
            .background(.red)
            .position(x: 100, y: 100)
    }
}

/*
 You’ll see the text has a red background tightly fitted around it. Now try moving the background() modifier below the position() modifier, like this:
 */

struct ContentView4: View {
    var body: some View {
        Text("Hello, world!")
            .position(x: 100, y: 100)
            .background(.red)
    }
}

/*
 Now you’ll see the text is in the same location, but the whole safe area is colored red.

 To understand what’s happening here you need to remember the three step layout process of SwiftUI:

 - A parent view proposes a size for its child.
 
 - Based on that information, the child then chooses its own size and the parent must respect that choice.
 
 - The parent then positions the child in its coordinate space.
 
 So, the parent is responsible for positioning the child, not the child. This causes a problem, because we’ve just told our text view to be at an exact position – how can SwiftUI resolve this?

 The answer to this is also why our background() color made the whole safe area red: when we use position() we get back a new view that takes up all available space, so it can position its child (the text) at the correct location.

 When we use text, position, then background the position will take up all available space so it can position its text correctly, then the background will use that size for itself. When we use text, background, then position, the background will use the text size for its size, then the position will take up all available space and place the background in the correct location.

 When discussing the offset() modifier earlier, I said “if you offset some text its original dimensions don’t actually change, even though the resulting view is rendered in a different location.” With that in mind, try running this code:
 */

struct ContentView5: View {
    var body: some View {
        Text("Hello, world!")
            .offset(x: 100, y: 100)
            .background(.red)
    }
}

/*
 You’ll see the text appears in one place and the background in another. I’m going to explain why that is, but first I want you to think about it yourself because if you understand that then you really understand how SwiftUI’s layout system works.

 When we use the offset() modifier, we’re changing the location where a view should be rendered without actually changing its underlying geometry. This means when we apply background() afterwards it uses the original position of the text, not its offset. If you move the modifier order so that background() comes before offset() then things work more like you might have expected, showing once again that modifier order matters.
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
    }
}
