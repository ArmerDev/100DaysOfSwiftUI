//
//  ContentView.swift
//  CustomizingAnimationsInSwiftUI
//
//  Created by James Armer on 12/05/2023.
//

import SwiftUI

/*
 When we attach the animation() modifier to a view, SwiftUI will automatically animate any changes that happen to that view using whatever is the default system animation, whenever the value we’re watching changes. In practice, that is an “ease in, ease out” animation, which means iOS will start the animation slow, make it pick up speed, then slow down as it approaches its end.

 We can control the type of animation used by passing in different values to the modifier. For example, we could use .easeOut to make the animation start fast then slow down to a smooth stop:
 */

struct ContentView: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        Button("Tap Me") {
            animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .scaleEffect(animationAmount)
        .blur(radius: (animationAmount - 1) * 3)
        .animation(.easeOut, value: animationAmount)
        
    }
}

/*
 Tip: If you were curious, implicit animations always need to watch a particular value otherwise animations would be triggered for every small change – even rotating the device from portrait to landscape would trigger the animation, which would look strange.
 */
/*

 There are even spring animations, that cause the movement to overshoot then return to settle at its target. You can control the initial stiffness of the spring (which sets its initial velocity when the animation starts), and also how fast the animation should be “damped” – lower values cause the spring to bounce back and forth for longer.

 For example, this makes our button scale up quickly then bounce:
 */

struct ContentView2: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        Button("Tap Me") {
            animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .scaleEffect(animationAmount)
        .blur(radius: (animationAmount - 1) * 3)
        .animation(.interpolatingSpring(stiffness: 50, damping: 1), value: animationAmount)
        
    }
}

/*
 For more precise control, we can customize the animation with a duration specified as a number of seconds. So, we could get an ease-in-out animation that lasts for two seconds like this:
 */

struct ContentView3: View {
    @State private var animationAmount = 1.0

    var body: some View {
        Button("Tap Me") {
            animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .scaleEffect(animationAmount)
        .animation(.easeInOut(duration: 2), value: animationAmount)
    }
}

/*
 When we say .easeInOut(duration: 2) we’re actually creating an instance of an Animation struct that has its own set of modifiers. So, we can attach modifiers directly to the animation to add a delay like this:
 */

struct ContentView4: View {
    @State private var animationAmount = 1.0

    var body: some View {
        Button("Tap Me") {
            animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .scaleEffect(animationAmount)
        .animation(
            .easeInOut(duration: 2)
            .delay(1),
            value: animationAmount
        )
    }
}

/*
 With that in place, tapping the button will now wait for a second before executing a two-second animation.

 We can also ask the animation to repeat a certain number of times, and even make it bounce back and forward by setting autoreverses to true. This creates a one-second animation that will bounce up and down before reaching its final size:
 */

struct ContentView5: View {
    @State private var animationAmount = 1.0

    var body: some View {
        Button("Tap Me") {
            animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .scaleEffect(animationAmount)
        .animation(
            .easeInOut(duration: 2)
            .repeatCount(3, autoreverses: true),
            value: animationAmount
        )
    }
}

/*
 If we had set repeat count to 2 then the button would scale up then down again, then jump immediately back up to its larger scale. This is because ultimately the button must match the state of our program, regardless of what animations we apply – when the animation finishes the button must have whatever value is set in animationAmount.
 
 For continuous animations, there is a repeatForever() modifier that can be used like this:
 */

struct ContentView6: View {
    @State private var animationAmount = 1.0

    var body: some View {
        Button("Tap Me") {
            animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .scaleEffect(animationAmount)
        .animation(
            .easeInOut(duration: 2)
            .repeatForever(autoreverses: true),
            value: animationAmount
        )
    }
}

/*
 We can use these repeatForever() animations in combination with onAppear() to make animations that start immediately and continue animating for the life of the view.

 To demonstrate this, we’re going to remove the animation from the button itself and instead apply it an overlay to make a sort of pulsating circle around the button. Overlays are created using an overlay() modifier, which lets us create new views at the same size and position as the view we’re overlaying.

 So, first add this overlay() modifier to the button before the animation() modifier
 
 That will make a stroked red circle over our button, using an opacity value of 2 - animationAmount so that when animationAmount is 1 the opacity is 1 (it’s opaque) and when animationAmount is 2 the opacity is 0 (it’s transparent).

 After that, remove the scaleEffect() and blur() modifiers from the button and comment out the animationAmount += 1 action part too, because we don’t want that to change any more, and move its animation modifier up to the circle inside the overlay
 
 Finally, add an onAppear() modifier to the button, which will set animationAmount to 2:
 */

struct ContentView7: View {
    @State private var animationAmount = 1.0

    var body: some View {
        Button("Tap Me") {
            // animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(.red)
                .scaleEffect(animationAmount)
                .opacity(2 - animationAmount)
                .animation(
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: false),
                    value: animationAmount
                )
        )
        .onAppear{
            animationAmount = 2
        }
    }
}

/*
 Because the overlay circle uses that for a “repeat forever” animation without autoreversing, you’ll see the overlay circle scale up and fade out continuously.
 
 Given how little work that involves, it creates a remarkably attractive effect!
 */

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
        ContentView6()
            .previewDisplayName("ContentView 6")
        ContentView7()
            .previewDisplayName("ContentView 7")
    }
}
