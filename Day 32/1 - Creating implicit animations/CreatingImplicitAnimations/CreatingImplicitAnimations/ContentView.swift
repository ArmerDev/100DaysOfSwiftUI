//
//  ContentView.swift
//  CreatingImplicitAnimations
//
//  Created by James Armer on 12/05/2023.
//

import SwiftUI

/*
 In SwiftUI, the simplest type of animation is an implicit one: we tell our views ahead of time “if someone wants to animate you, here’s how you should respond”, and nothing more. SwiftUI will then take care of making sure any changes that do occur follow the animation you requested. In practice this makes animation trivial – it literally could not be any easier.

 Let’s start with an example. This code shows a simple red button with no action, using 50 points of padding and a circular clip shape:
 */

struct ContentView: View {
    var body: some View {
        Button("Tap Me") {
            // do nothing
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
    }
}

/*
 What we want is for that button to get bigger every time it’s tapped, and we can do that with a new modifier called scaleEffect(). You provide this with a value from 0 up, and it will be drawn at that size – a value of 1.0 is equivalent to 100%, i.e. the button’s normal size.

 Because we want to change the scale effect value every time the button is tapped, we need to use an @State property that will store a Double. Then we will use the .scaleEffect modifier and pass in the animationAmount property. Finally, when the button is tapped we want to increase the animation amount by 1, so increase the amount of animationAmount during the Button's action:
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
        
    }
}

/*
 If you run that code you’ll see that you can tap the button repeatedly to have it scale up and up. It won’t get redrawn at increasingly high resolutions, so as the button gets bigger you’ll see it gets a bit blurry, but that’s OK.

 Now, the human eye is highly sensitive to movement – we’re extremely good at detecting when things move or change their appearance, which is what makes animation both so important and so pleasing. So, we can ask SwiftUI to create an implicit animation for our changes so that all the scaling happens smoothly by adding an animation() modifier to the button:
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
        .animation(.default, value: animationAmount)
        
    }
}

/*
 That asks SwiftUI to apply a default animation whenever the value of animationAmount changes, and immediately you’ll see that tapping the button now causes it to scale up with an animation.

 That implicit animation takes effect on all properties of the view that change, meaning that if we attach more animating modifiers to the view then they will all change together. For example, we could add a second new modifier to the button, .blur(), which lets us add a Gaussian blur with a special radius – add this before the animation() modifier:
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
        .blur(radius: (animationAmount - 1) * 3)
        .animation(.default, value: animationAmount)
        
    }
}

/*
 A radius of (animationAmount - 1) * 3 means the blur radius will start at 0 (no blur), but then move to 3 points, 6 points, 9 points, and beyond as you tap the button.

 If you run the app again you’ll see that it now scales and blurs smoothly.

 The point is that nowhere have we said what each frame of the animation should look like, and we haven’t even said when SwiftUI should start and finish the animation. Instead, our animation becomes a function of our state just like the views themselves.
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
    }
}
