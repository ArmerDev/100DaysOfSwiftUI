//
//  ContentView.swift
//  ViewComposition
//
//  Created by James Armer on 07/05/2023.
//

import SwiftUI

/*
 SwiftUI lets us break complex views down into smaller views without incurring much if any performance impact. This means that we can split up one large view into multiple smaller views, and SwiftUI takes care of reassembling them for us.

 For example, in this view we have a particular way of styling text views – they have a large font, some padding, foreground and background colors, plus a capsule shape:
 */

struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("First")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.white)
                .background(.blue)
                .clipShape(Capsule())

            Text("Second")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.white)
                .background(.blue)
                .clipShape(Capsule())
        }
    }
}

/*
 Because those two text views are identical apart from their text, we can wrap them up in a new custom view, like this:
 */

struct CapsuleText: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(Capsule())
    }
}

/*
 We can then use that CapsuleText view inside our original view, like this:
 */

struct ContentView2: View {
    var body: some View {
        VStack(spacing: 10) {
            CapsuleText(text: "First")
            CapsuleText(text: "Second")
        }
    }
}

/*
 Of course, we can also store some modifiers in the view and customize others when we use them. For example, if we removed foregroundColor() from CapsuleText, we could then apply custom colors when creating instances of that view like this:
 */

struct CapsuleText2: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .background(.blue)
            .clipShape(Capsule())
    }
}

struct ContentView3: View {
    var body: some View {
        VStack(spacing: 10) {
            CapsuleText2(text: "First")
                .foregroundColor(.white)
            CapsuleText2(text: "Second")
                .foregroundColor(.yellow)
        }    }
}

/*
 Don’t worry about performance issues here – it’s extremely efficient to break up SwiftUI views in this way.
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
