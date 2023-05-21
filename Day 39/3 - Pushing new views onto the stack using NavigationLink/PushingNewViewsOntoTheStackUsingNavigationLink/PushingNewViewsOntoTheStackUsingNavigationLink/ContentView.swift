//
//  ContentView.swift
//  PushingNewViewsOntoTheStackUsingNavigationLink
//
//  Created by James Armer on 21/05/2023.
//

import SwiftUI

/*
 SwiftUI’s NavigationView shows a navigation bar at the top of our views, but also does something else: it lets us push views onto a view stack. In fact, this is really the most fundamental form of iOS navigation – you can see it in Settings when you tap Wi-Fi or General, or in Messages whenever you tap someone’s name.

 This view stack system is very different from the sheets we’ve used previously. Yes, both show some sort of new view, but there’s a difference in the way they are presented that affects the way users think about them.

 Let’s start by looking at some code so you can see for yourself. If we wrap the default text view with a navigation view and give it a title, we get this:
 */

struct ContentView: View {
    var body: some View {
        NavigationView {
            Text("Hello, world!")
                .padding()
            .navigationTitle("SwiftUI")
        }
    }
}

/*
 That text view is just static text; it’s not a button with any sort of action attached to it. We’re going to make it so that when the user taps on “Hello, world!” we present them with a new view, and that’s done using NavigationLink: give this a destination and something that can be tapped, and it will take care of the rest.

 One of the many things I love about SwiftUI is that we can use NavigationLink with any kind of destination view. Yes, we can design a custom view to push to, but we can also push straight to some text.

 To try this out, change your view to this:
 */

struct ContentView2: View {
    var body: some View {
        NavigationView {
            NavigationLink {
                Text("Detail View")
            } label: {
                Text("Hello, world!")
                    .padding()
            }
            .navigationTitle("SwiftUI")
        }
    }
}

/*
 Now run the code and see what you think. You will see that “Hello, world!” now looks like a button, and tapping it makes a new view slide in from the right saying “Detail View”. Even better, you’ll see that the “SwiftUI” title animates down to become a back button, and you can tap that or swipe from the left edge to go back.

 So, both sheet() and NavigationLink allow us to show a new view from the current one, but the way they do it is different and you should choose them carefully:

 NavigationLink is for showing details about the user’s selection, like you’re digging deeper into a topic.
 sheet() is for showing unrelated content, such as settings or a compose window.
 The most common place you see NavigationLink is with a list, and there SwiftUI does something quite marvelous.

 Try modifying your code to this:
 */

struct ContentView3: View {
    var body: some View {
        NavigationView {
            List(0..<100) { row in
                NavigationLink {
                    Text("Detail \(row)")
                } label: {
                    Text("Row \(row)")
                }
            }
            .navigationTitle("SwiftUI")
        }
    }
}

/*
 When you run the app now you’ll see 100 list rows that can be tapped to show a detail view, but you’ll also see gray disclosure indicators on the right edge. This is the standard iOS way of telling users another screen is going to slide in from the right when the row is tapped, and SwiftUI is smart enough to add it automatically here. If those rows weren’t navigation links – if you comment out the NavigationLink line and its closing brace – you’ll see the indicators disappear.
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
