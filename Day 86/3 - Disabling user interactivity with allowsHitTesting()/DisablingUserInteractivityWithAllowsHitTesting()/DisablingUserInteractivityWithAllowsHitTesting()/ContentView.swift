//
//  ContentView.swift
//  DisablingUserInteractivityWithAllowsHitTesting()
//
//  Created by James Armer on 03/07/2023.
//

import SwiftUI

/*
 SwiftUI has an advanced hit testing algorithm that uses both the frame of a view and often also its contents. For example, if you add a tap gesture to a text view then all parts of the text view are tappable – you can’t tap through the text if you happen to press exactly where a space is. On the other hand, if you attach the same gesture to a circle then SwiftUI will ignore the transparent parts of the circle.

 To demonstrate this, here’s a circle overlapping a rectangle using a ZStack, both with onTapGesture() modifiers:
 */

struct ContentView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Rectangle tapped!")
                }

            Circle()
                .fill(.red)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Circle tapped!")
                }
        }
    }
}

/*
 If you try that out, you’ll find that tapping inside the circle prints “Circle tapped”, but on the rectangle behind the circle prints “Rectangle tapped” – even though the circle actually has the same frame as the rectangle.

 SwiftUI lets us control user interactivity in two useful ways, the first of which is the allowsHitTesting() modifier. When this is attached to a view with its parameter set to false, the view isn’t even considered tappable. That doesn’t mean it’s inert, though, just that it doesn’t catch any taps – things behind the view will get tapped instead.

 Try adding it to our circle like this:
 */

struct ContentView2: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Rectangle tapped!")
                }

            Circle()
                .fill(.red)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Circle tapped!")
                }
                .allowsHitTesting(false)
        }
    }
}

/*
 Now tapping the circle will always print “Rectangle tapped!”, because the circle will refuses to respond to taps.

 The other useful way of controlling user interactivity is with the contentShape() modifier, which lets us specify the tappable shape for something. By default the tappable shape for a circle is a circle of the same size, but you can specify a different shape instead like this:
 */

struct ContentView3: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Rectangle tapped!")
                }

            Circle()
                .fill(.red)
                .frame(width: 300, height: 300)
                .contentShape(Rectangle())
                .onTapGesture {
                    print("Circle tapped!")
                }
        }
    }
}

/*
 Where the contentShape() modifier really becomes useful is when you tap actions attached to stacks with spacers, because by default SwiftUI won’t trigger actions when a stack spacer is tapped.

 Here’s an example you can try out:
 */

struct ContentView4: View {
    var body: some View {
        VStack {
            Text("Hello")
            Spacer().frame(height: 100)
            Text("World")
        }
        .onTapGesture {
            print("VStack tapped!")
        }
    }
}

/*
 If you run that you’ll find you can tap the “Hello” label and the “World” label, but not the space in between. However, if we use contentShape(Rectangle()) on the VStack then the whole area for the stack becomes tappable, including the spacer:
 */

struct ContentView5: View {
    var body: some View {
        VStack {
            Text("Hello")
            Spacer().frame(height: 100)
            Text("World")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            print("VStack tapped!")
        }
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
        ContentView5()
            .previewDisplayName("ContentView 5")
    }
}
