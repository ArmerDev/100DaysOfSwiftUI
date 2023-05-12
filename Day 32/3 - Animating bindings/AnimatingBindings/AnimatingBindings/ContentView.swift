//
//  ContentView.swift
//  AnimatingBindings
//
//  Created by James Armer on 12/05/2023.
//

import SwiftUI

/*
 The animation() modifier can be applied to any SwiftUI binding, which causes the value to animate between its current and new value. This even works if the data in question isn’t really something that sounds like it can be animated, such as a Boolean – you can mentally imagine animating from 1.0 to 2.0 because we could do 1.05, 1.1, 1.15, and so on, but going from “false” to “true” sounds like there’s no room for in between values.

 This is best explained with some working code to look at, so here’s a view with a VStack, a Stepper, and a Button:
 */

struct ContentView: View {
    @State private var animationAmount = 1.0

    var body: some View {
        VStack {
            Stepper("Scale amount", value: $animationAmount.animation(), in: 1...10)
                .padding()

            Spacer()

            Button("Tap Me") {
                animationAmount += 1
            }
            .padding(40)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(animationAmount)
        }
    }
}

/*
 As you can see, the stepper can move animationAmount up and down, and tapping the button will add 1 to it – they are both tied to the same data, which in turn causes the size of the button to change. However, tapping the button changes animationCount immediately, so the button will just jump up to its larger size. In contrast, the stepper is bound to $animationAmount.animation(), which means SwiftUI will automatically animate its changes.

 Now, as an experiment I’d like you to change the start of the body to include a print statement that prints out the value of animationAmount. For this to work, you will need to put return in-front of the VStack:
 */

struct ContentView2: View {
    @State private var animationAmount = 1.0

    var body: some View {
        print(animationAmount)
        
        return VStack {
            Stepper("Scale amount", value: $animationAmount.animation(), in: 1...10)
                .padding()

            Spacer()

            Button("Tap Me") {
                animationAmount += 1
            }
            .padding(40)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(animationAmount)
        }
    }
}

/*
 Because we have some non-view code in there, we need to add return before the VStack so Swift understands which part is the view that is being sent back. But adding print(animationAmount) is important, and to see why I’d like you to run the program again and try manipulating the stepper.

 What you should see is that it prints out 2.0, 3.0, 4.0, and so on. At the same time, the button is scaling up or down smoothly – it doesn’t just jump straight to scale 2, 3, and 4. What’s actually happening here is that SwiftUI is examining the state of our view before the binding changes, examining the target state of our views after the binding changes, then applying an animation to get from point A to point B.

 This is why we can animate a Boolean changing: Swift isn’t somehow inventing new values between false and true, but just animating the view changes that occur as a result of the change.

 These binding animations use a similar animation() modifier that we use on views, so you can go to town with animation modifiers if you want to:
 */

struct ContentView3: View {
    @State private var animationAmount = 1.0

    var body: some View {
        print(animationAmount)
        
        return VStack {
            Stepper("Scale amount", value: $animationAmount.animation(
                .easeInOut(duration: 1)
                .repeatCount(3, autoreverses: true)
            ), in: 1...10)
                .padding()

            Spacer()

            Button("Tap Me") {
                animationAmount += 1
            }
            .padding(40)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(animationAmount)
        }
    }
}

/*
 Tip: With this variant of the animation() modifier, we don’t need to specify which value we’re watching for changes – it’s literally attached to the value it should watch!

 These binding animations effectively turn the tables on implicit animations: rather than setting the animation on a view and implicitly animating it with a state change, we now set nothing on the view and explicitly animate it with a state change. In the former, the state change has no idea it will trigger an animation, and in the latter the view has no idea it will be animated – both work and both are important.
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
