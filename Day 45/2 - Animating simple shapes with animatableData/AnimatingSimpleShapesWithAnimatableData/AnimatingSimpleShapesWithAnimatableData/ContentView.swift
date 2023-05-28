//
//  ContentView.swift
//  AnimatingSimpleShapesWithAnimatableData
//
//  Created by James Armer on 28/05/2023.
//

import SwiftUI

/*
 We’ve now covered a variety of drawing-related tasks, and back in project 6 we looked at animation, so now I want to look at putting those two things together.
 
 First, let’s build a custom shape we can use for an example – here’s the code for a trapezoid shape, which is a four-sided shape with straight sides where one pair of opposite sides are parallel:
 */

struct Trapezoid: Shape {
    var insetAmount: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        
        return path
    }
}

/*
 We can now use that inside a view, passing in some local state for its inset amount so we can modify the value at runtime:
 */

struct ContentView: View {
    @State private var insetAmount = 50.0
    var body: some View {
        Trapezoid(insetAmount: insetAmount)
            .frame(width: 200, height: 100)
            .onTapGesture {
                insetAmount = Double.random(in: 10...90)
            }
    }
}

/*
 Every time you tap the trapezoid, insetAmount gets set to a new value, causing the shape to be redrawn.

 Wouldn’t it be nice if we could animate the change in inset? Sure it would – try changing the onTapGesture() so that it is wrapped with withAnimation {}:
 */

struct ContentView2: View {
    @State private var insetAmount = 50.0
    var body: some View {
        Trapezoid(insetAmount: insetAmount)
            .frame(width: 200, height: 100)
            .onTapGesture {
                withAnimation {
                    insetAmount = Double.random(in: 10...90)
                }
            }
    }
}

/*
 Now run it again, and… nothing has changed. We’ve asked for animation, but we aren’t getting animation – what gives?

 When looking at animations previously, I asked you to add a call to print() inside the body property, then said this:

 ”What you should see is that it prints out 2.0, 3.0, 4.0, and so on. At the same time, the button is scaling up or down smoothly – it doesn’t just jump straight to scale 2, 3, and 4. What’s actually happening here is that SwiftUI is examining the state of our view before the binding changes, examining the target state of our views after the binding changes, then applying an animation to get from point A to point B.”

 So, as soon as insetAmount is set to a new random value, it will immediately jump to that value and pass it directly into Trapezoid – it won’t pass in lots of intermediate values as the animation happens. This is why our trapezoid jumps from inset to inset; it has no idea an animation is even happening.

 We can fix this in only four lines of code, one of which is just a closing brace. However, even though this code is simple, the way it works might bend your brain.

 First, the code – add this new computed property to the Trapezoid struct now:
 */

struct Trapezoid2: Shape {
    var insetAmount: Double
    
    var animatableData: Double {
        get { insetAmount }
        set { insetAmount = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        
        return path
    }
}

struct ContentView3: View {
    @State private var insetAmount = 50.0
    var body: some View {
        Trapezoid2(insetAmount: insetAmount)
            .frame(width: 200, height: 100)
            .onTapGesture {
                withAnimation {
                    insetAmount = Double.random(in: 10...90)
                }
            }
    }
}

/*
 You can now run the app again and see our trapezoid changing shape with a smooth animation.

 What’s happening here is quite complex: when we use withAnimation(), SwiftUI immediately changes our state property to its new value, but behind the scenes it’s also keeping track of the changing value over time as part of the animation. As the animation progresses, SwiftUI will set the animatableData property of our shape to the latest value, and it’s down to us to decide what that means – in our case we assign it directly to insetAmount, because that’s the thing we want to animate.

 Remember, SwiftUI evaluates our view state before an animation was applied and then again after. It can see we originally had code that evaluated to Trapezoid(insetAmount: 50), but then after a random number was chosen we ended up with (for example) Trapezoid(insetAmount: 62). So, it will interpolate between 50 and 62 over the length of our animation, each time setting the animatableData property of our shape to be that latest interpolated value – 51, 52, 53, and so on, until 62 is reached.
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
