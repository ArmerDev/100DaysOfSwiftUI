//
//  ContentView.swift
//  WhySwiftUIUsesStructForViews
//
//  Created by James Armer on 04/05/2023.
//

import SwiftUI

/*
 If you ever programmed for UIKit or AppKit (Apple’s original user interface frameworks for iOS and macOS) you’ll know that they use classes for views rather than structs. SwiftUI does not: we prefer to use structs for views across the board, and there are a couple of reasons why.

 First, there is an element of performance: structs are simpler and faster than classes. I say an element of performance because lots of people think this is the primary reason SwiftUI uses structs, when really it’s just one part of the bigger picture.

 In UIKit, every view descended from a class called UIView that had many properties and methods – a background color, constraints that determined how it was positioned, a layer for rendering its contents into, and more. There were lots of these, and every UIView and UIView subclass had to have them, because that’s how inheritance works.

 In SwiftUI, all our views are trivial structs and are almost free to create. Think about it: if you make a struct that holds a single integer, the entire size of your struct is… that one integer. Nothing else. No surprise extra values inherited from parent classes, or grandparent classes, or great-grandparent classes, etc – they contain exactly what you can see and nothing more.

 Thanks to the power of modern iPhones, I wouldn’t think twice about creating 1000 integers or even 100,000 integers – it would happen in the blink of an eye. The same is true of 1000 SwiftUI views or even 100,000 SwiftUI views; they are so fast it stops being worth thinking about.

 However, even though performance is important there’s something much more important about views as structs: it forces us to think about isolating state in a clean way. You see, classes are able to change their values freely, which can lead to messier code – how would SwiftUI be able to know when a value changed in order to update the UI?

 By producing views that don’t mutate over time, SwiftUI encourages us to move to a more functional design approach: our views become simple, inert things that convert data into UI, rather than intelligent things that can grow out of control.

 You can see this in action when you look at the kinds of things that can be a view. We already used Color.red and LinearGradient as views – trivial types that hold very little data. In fact, you can’t get a great deal simpler than using Color.red as a view: it holds no information other than “fill my space with red”.

 In comparison, Apple’s documentation for UIView lists about 200 properties and methods that UIView has, all of which get passed on to its subclasses whether they need them or not.

 Tip: If you use a class for your view you might find your code either doesn’t compile or crashes at runtime. Trust me on this: use a struct.
 */

struct ContentView: View {
    var body: some View {
        Text("Why SwiftUI uses Structs for Views")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
