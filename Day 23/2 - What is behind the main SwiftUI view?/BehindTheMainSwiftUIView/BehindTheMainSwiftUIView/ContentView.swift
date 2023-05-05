//
//  ContentView.swift
//  BehindTheMainSwiftUIView
//
//  Created by James Armer on 05/05/2023.
//

import SwiftUI

/*
 When you’re just starting out with SwiftUI, you get this code:
 */

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

/*
 It’s common to then modify that text view with a background color and expect it to fill the screen:
 */

struct ContentView2: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .background(.red)
    }
}

/*
 However, that doesn’t happen. Instead, we get a small red text view in the center of the screen, and a sea of white beyond it.

 This confuses people, and usually leads to the question – “how do I make what’s behind the view turn red?”

 Let me say this as clearly as I can: for SwiftUI developers, there is nothing behind our view. You shouldn’t try to make that white space turn red with weird hacks or workarounds, and you certainly shouldn’t try to reach outside of SwiftUI to do it.

 Now, right now at least there is something behind our content view called a UIHostingController: it is the bridge between UIKit (Apple’s original iOS UI framework) and SwiftUI. However, if you start trying to modify that you’ll find that your code no longer works on Apple’s other platforms, and in fact might stop working entirely on iOS at some point in the future.

 Instead, you should try to get into the mindset that there is nothing behind our view – that what you see is all we have.

 Once you’re in that mindset, the correct solution is to make the text view take up more space; to allow it to fill the screen rather than being sized precisely around its content. We can do that by using the frame() modifier, passing in .infinity for both its maximum width and maximum height.
 */

struct ContentView3: View {
    var body: some View {
        Text("Hello, world!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.red)
    }
}

/*
 Using maxWidth and maxHeight is different from using width and height – we’re not saying the text view must take up all that space, only that it can. If you have other views around, SwiftUI will make sure they all get enough space.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
        ContentView3()
            .previewDisplayName("ContentView 3")
    }
}
