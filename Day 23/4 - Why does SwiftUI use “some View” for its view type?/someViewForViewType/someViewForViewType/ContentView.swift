//
//  ContentView.swift
//  someViewForViewType
//
//  Created by James Armer on 06/05/2023.
//

import SwiftUI

/*
 SwiftUI relies very heavily on a Swift power feature called “opaque return types”, which you can see in action every time you write some View. This means “one object that conforms to the View protocol, but we don’t want to say what.”

 Returning some View means even though we don’t know what view type is going back, the compiler does. That might sound small, but it has important implications.

 First, using some View is important for performance: SwiftUI needs to be able to look at the views we are showing and understand how they change, so it can correctly update the user interface. If SwiftUI didn’t have this extra information, it would be really slow for SwiftUI to figure out exactly what changed – it would pretty much need to ditch everything and start again after every small change.

 The second difference is important because of the way SwiftUI builds up its data using ModifiedContent. Previously we looked at code like that shown below:
 */

struct ContentView: View {
    var body: some View {
        Button("Hello World") {
            print(type(of: self.body))
        }
        .frame(width: 200, height: 200)
        .background(.red)
    }
}

/*
 That creates a simple button then makes it print its exact Swift type, and gives some long output with a couple of instances of ModifiedContent.

 The View protocol has an associated type attached to it, which is Swift’s way of saying that View by itself doesn’t mean anything – we need to say exactly what kind of view it is. It effectively has a hole in it, in a similar way to how Swift doesn’t let us say “this variable is an array” and instead requires that we say what’s in the array: “this variable is a string array.”

 So, while it’s not allowed to write a view like this:
 */

struct ContentView1: View {
    var body: View {
        Text("Hello World")
    }
}

/*
 It is perfectly legal to write a view like this:
 */

struct ContentView2: View {
    var body: Text {
        Text("Hello World")
    }
}

/*
 Returning View makes no sense, because Swift wants to know what’s inside the view – it has a big hole that must be filled. On the other hand, returning Text is fine, because we’ve filled the hole; Swift knows what the view is.

 Now let’s return to our code from earlier:
 */

struct ContentView3: View {
    var body: some View {
        Button("Hello World") {
            print(type(of: self.body))
        }
        .frame(width: 200, height: 200)
        .background(.red)
    }
}

/*
 If we want to return one of those from our body property, what should we write? While you could try to figure out the exact combination of ModifiedContent structs to use, it’s hideously painful and the simple truth is that we don’t care because it’s all internal SwiftUI stuff.

 What some View lets us do is say “this will be a view, such as Button or Text, but I don’t want to say what.” So, the hole that View has will be filled by a real view object, but we aren’t required to write out the exact long type.

 There are two places where it gets a bit more complicated:

1 - How does VStack work – it conforms to the View protocol, but how does it fill the “what kind of content does it have?” hole if it can contain lots of different things inside it?
2 - What happens if we send back two views directly from our body property, without wrapping them in a stack?
 
 
 To answer the first question first, if you create a VStack with two text views inside, SwiftUI silently creates a TupleView to contain those two views – a special type of view that holds exactly two views inside it. So, the VStack fills the “what kind of view is this?” with the answer “it’s a TupleView containing two text views.”

 And what if you have three text views inside the VStack? Then it’s a TupleView containing three views. Or four views. Or eight views, or even ten views – there is literally a version of TupleView that tracks ten different kinds of content:

 
        TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)>
 
 
 And that’s why SwiftUI doesn’t allow more than 10 views inside a parent: they wrote versions of TupleView that handle 2 views through 10, but no more.

 As for the second question, Swift silently applies a special attribute to the body property called @ViewBuilder. This has the effect of silently wrapping multiple views in one of those TupleView containers, so that even though it looks like we’re sending back multiple views they get combined into one TupleView.

 This behavior isn’t magic: if you right-click on the View protocol and choose “Jump to Definition”, you’ll see the requirement for the body property and also see that it’s marked with the @ViewBuilder attribute:

 @ViewBuilder var body: Self.Body { get }
 Of course, how SwiftUI interprets multiple views going back without a stack around them isn’t specifically defined anywhere, but as you’ll learn later on that’s actually helpful.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
