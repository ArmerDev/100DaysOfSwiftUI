//
//  ContentView.swift
//  ViewsAsProperties
//
//  Created by James Armer on 07/05/2023.
//

import SwiftUI

/*
 There are lots of ways to make it easier to use complex view hierarchies in SwiftUI, and one option is to use properties – to create a view as a property of your own view, then use that property inside your layouts.

 For example, we could create two text views like this as properties, then use them inside a VStack:
 */

struct ContentView: View {
    let motto1 = Text("Draco dormiens")
    let motto2 = Text("nunquam titillandus")

    var body: some View {
        VStack {
            motto1
            motto2
        }
    }
}

/*
 You can even apply modifiers directly to those properties as they are being used, like this:
 */

struct ContentView2: View {
    let motto1 = Text("Draco dormiens")
    let motto2 = Text("nunquam titillandus")

    var body: some View {
        VStack {
            motto1
                .foregroundColor(.red)
            motto2
                .foregroundColor(.blue)
        }
    }
}

/*
 Creating views as properties can be helpful to keep your body code clearer – not only does it help avoid repetition, but it can also get more complex code out of the body property.

 Swift doesn’t let us create one stored property that refers to other stored properties, because it would cause problems when the object is created. This means trying to create a TextField bound to a local property will cause problems.

 However, you can create computed properties if you want, like this:
 */

var motto1: some View {
    Text("Draco dormiens")
}

/*
 This is often a great way to carve up your complex views into smaller chunks, but be careful: unlike the body property, Swift won’t automatically apply the @ViewBuilder attribute here, so if you want to send multiple views back you have three options.

 First, you can place them in a stack, like this:
 */

var spells: some View {
    VStack {
        Text("Lumos")
        Text("Obliviate")
    }
}

/*
 If you don’t specifically want to organize them in a stack, you can also send back a Group. When this happens, the arrangement of your views is determined by how you use them elsewhere in your code:
 */

var spells2: some View {
    Group {
        Text("Lumos")
        Text("Obliviate")
    }
}

/*
 The third option is to add the @ViewBuilder attribute yourself, like this:
 */

@ViewBuilder var spells3: some View {
    Text("Lumos")
    Text("Obliviate")
}

/*
 Of them all, I prefer to use @ViewBuilder because it mimics the way body works, however I’m also wary when I see folks cram lots of functionality into their properties – it’s usually a sign that their views are getting a bit too complex, and need to be broken up. Speaking of which, let’s tackle that next…
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
    }
}
