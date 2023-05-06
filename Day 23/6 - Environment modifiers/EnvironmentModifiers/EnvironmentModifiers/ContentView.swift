//
//  ContentView.swift
//  EnvironmentModifiers
//
//  Created by James Armer on 06/05/2023.
//

import SwiftUI

/*
 Many modifiers can be applied to containers, which allows us to apply the same modifier to many views at the same time.

 For example, if we have four text views in a VStack and want to give them all the same font modifier, we could apply the modifier to the VStack directly and have that change apply to all four text views:
 */

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Gryffindor")
            Text("Hufflepuff")
            Text("Ravenclaw")
            Text("Slytherin")
        }
        .font(.title)
    }
}

/*
 This is called an environment modifier, and is different from a regular modifier that is applied to a view.

 From a coding perspective these modifiers are used exactly the same way as regular modifiers. However, they behave subtly differently because if any of those child views override the same modifier, the child’s version takes priority.

 As an example, this shows our four text views with the title font, but one has a large title:
 */

struct ContentView2: View {
    var body: some View {
        VStack {
            Text("Gryffindor")
                .font(.largeTitle)
            Text("Hufflepuff")
            Text("Ravenclaw")
            Text("Slytherin")
        }
        .font(.title)
    }
}

/*
 There, font() is an environment modifier, which means the Gryffindor text view can override it with a custom font.

 However, the below code applies a blur effect to the VStack then attempts to disable blurring on one of the text views:
 */

struct ContentView3: View {
    var body: some View {
        VStack {
            Text("Gryffindor")
                .blur(radius: 0)
            Text("Hufflepuff")
            Text("Ravenclaw")
            Text("Slytherin")
        }
        .blur(radius: 5)
    }
}

/*
 That won’t work the same way: blur() is a regular modifier, so any blurs applied to child views are added to the VStack blur rather than replacing it.

 To the best of my knowledge there is no way of knowing ahead of time which modifiers are environment modifiers and which are regular modifiers other than reading the individual documentation for each modifier and hope it’s mentioned. Still, I’d rather have them than not: being able to apply one modifier everywhere is much better than copying and pasting the same thing into multiple places.
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
