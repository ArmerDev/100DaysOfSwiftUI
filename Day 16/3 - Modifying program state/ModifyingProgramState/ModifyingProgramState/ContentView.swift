//
//  ContentView.swift
//  ModifyingProgramState
//
//  Created by James Armer on 29/04/2023.
//

import SwiftUI

/*
 
 There’s a saying among SwiftUI developers that our “views are a function of their state,” but while that’s only a handful of words it might be quite meaningless to you at first.

 If you were playing a fighting game, you might have lost a few lives, scored some points, collected some treasure, and perhaps picked up some powerful weapons. In programming, we call these things state – the active collection of settings that describe how the game is right now.

 When we say SwiftUI’s views are a function of their state, we mean that the way your user interface looks – the things people can see and what they can interact with – are determined by the state of your program. For example, they can’t tap Continue until they have entered their name in a text field.
 
 
 */

struct ContentView: View {
    
    var tapCount = 0
    
    var body: some View {
        Button("Tap Count: \(tapCount)") {
            tapCount += 1
        }
    }
}

/* As you can see, the above code will now work because we are trying to mutate tapCount. While it is a variable, its within a Struct. If you remember, Swift makes all our structs constant, because it might be declared as a constant.

When creating struct methods that want to change properties, we need to add the mutating keyword: mutating func doSomeWork(), for example. However, Swift doesn’t let us make mutating computed properties, which means we can’t write mutating var body: some View – it just isn’t allowed.

This might seem like we’re stuck at an impasse: we want to be able to change values while our program runs, but Swift won’t let us because our views are structs.

Fortunately, Swift gives us a special solution called a property wrapper: a special attribute we can place before our properties that effectively gives them super-powers. In the case of storing simple program state like the number of times a button was tapped, we can use a property wrapper from SwiftUI called @State, like this:
 
 */

struct ContentView2: View {
    
    @State var tapCount = 0
    
    var body: some View {
        Button("Tap Count: \(tapCount)") {
            tapCount += 1
        }
    }
}

/*
 
 @State allows us to work around the limitation of structs: we know we can’t change their properties because structs are fixed, but @State allows that value to be stored separately by SwiftUI in a place that can be modified.

 Yes, it feels a bit like a cheat, and you might wonder why we don’t use classes instead – they can be modified freely. But trust me, it’s worthwhile: as you progress you’ll learn that SwiftUI destroys and recreates your structs frequently, so keeping them small and simple is important for performance.

 Tip: There are several ways of storing program state in SwiftUI, and you’ll learn all of them. @State is specifically designed for simple properties that are stored in one view. As a result, Apple recommends we add private access control to those properties, like this: @State private var tapCount = 0.
 
 */


struct ContentView3: View {
    
    @State private var tapCount = 0
    
    var body: some View {
        Button("Tap Count: \(tapCount)") {
            tapCount += 1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView3()
    }
}
