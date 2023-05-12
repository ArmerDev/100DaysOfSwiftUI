//
//  ContentView.swift
//  CreatingExplicitAnimations
//
//  Created by James Armer on 12/05/2023.
//

import SwiftUI

/*
 You’ve seen how SwiftUI lets us create implicit animations by attaching the animation() modifier to a view, and how it also lets us create animated binding changes by adding the animation() modifier to a binding, but there’s a third useful way we can create animations: explicitly asking SwiftUI to animate changes occurring as the result of a state change.

 This still doesn’t mean we create each frame of the animation by hand – that remains SwiftUI’s job, and it continues to figure out the animation by looking at the state of our views before and after the state change was applied.

 Now, though, we’re being explicit that we want an animation to occur when some arbitrary state change occurs: it’s not attached to a binding, and it’s not attached to a view, it’s just us explicitly asking for a particular animation to occur because of a state change.

 To demonstrate this, let’s return to a simple button example again:
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
 When that button is tapped, we’re going to make it spin around with a 3D effect. This requires another new modifier, rotation3DEffect(), which can be given a rotation amount in degrees as well as an axis that determines how the view rotates. Think of this axis like a skewer through your view:

 - If we skewer the view through the X axis (horizontally) then it will be able to spin forwards and backwards.
 - If we skewer the view through the Y axis (vertically) then it will be able to spin left and right.
 - If we skewer the view through the Z axis (depth) then it will be able to rotate left and right.
 
 Making this work requires some state we can modify, and rotation degrees are specified as a Double. So, we need to add a new state property:
 */

struct ContentView2: View {
    @State private var animationAmount = 0.0
    
    // Next, we’re going to ask the button to rotate by animationAmount degrees along its Y axis, which means it will spin left and right. This is achieved using the rotation3DEffect modifier:
    
    var body: some View {
        Button("Tap Me") {
            // do nothing
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
    }
}

/*
 Now for the important part: we’re going to add some code to the button’s action so that it adds 360 to animationAmount every time it’s tapped.

 If we just write animationAmount += 360 then the change will happen immediately, because there is no animation modifier attached to the button. This is where explicit animations come in: if we use a withAnimation() closure then SwiftUI will ensure any changes resulting from the new state will automatically be animated.

 So, put this in the button’s action now:
 */

struct ContentView3: View {
    @State private var animationAmount = 0.0
    
    var body: some View {
        Button("Tap Me") {
            withAnimation {
                animationAmount += 360
            }
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
    }
}

/*
 Run that code now and I think you’ll be impressed by how good it looks – every time you tap the button it spins around in 3D space, and it was so easy to write. If you have time, experiment a little with the axes so you can really understand how they work. In case you were curious, you can use more than one axis at once.

 withAnimation() can be given an animation parameter, using all the same animations you can use elsewhere in SwiftUI. For example, we could make our rotation effect use a spring animation using a withAnimation() call like this:
 */

struct ContentView4: View {
    @State private var animationAmount = 0.0
    
    var body: some View {
        Button("Tap Me") {
            withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                animationAmount += 360
            }
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
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
        
    }
}
