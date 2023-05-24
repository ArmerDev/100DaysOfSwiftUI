//
//  ContentView.swift
//  AddingStrokeBorder()SupportWithInsettableShape
//
//  Created by James Armer on 24/05/2023.
//

import SwiftUI

/*
 If you create a shape without a specific size, it will automatically expand to occupy all available space. For example, this will create a circle that fills our view, giving it a 40-point blue border:
 */

struct ContentView: View {
    var body: some View {
        Circle()
            .stroke(.blue, lineWidth: 40)
    }
}

/*
 Take a close look at the left and right edges of the border – do you notice how they are cut off?
 
 What you’re seeing here is a side effect of the way SwiftUI draws borders around shapes. If you handed someone a pencil outline of a circle and asked them to draw over that circle with a thick pen, they would trace the exact line of the circle – about half the pen would be inside the line, and half outside. This is what SwiftUI is doing for us, but where our shapes go to the edge of the screen it means the outside part of the border ends up beyond our screen edges.
 
 Now try using this circle instead:
 */

struct ContentView2: View {
    var body: some View {
        Circle()
            .strokeBorder(.blue, lineWidth: 40)
    }
}

/*
 That changes stroke() to strokeBorder() and now we get a better result: all our border is visible, because Swift strokes the inside of the circle rather than centering on the line.
 
 Previously we built an Arc shape like this:
 */

struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        
        return path
    }
}

/*
 Just like Circle, that automatically takes up all available space. However, this kind of code won’t work:
 */


struct ContentView3: View {
    var body: some View {
        Arc(startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
        // UNCOMMENT THE BELOW LINE TO SEE ERROR.
        //.strokeBorder(.blue, lineWidth: 40)
    }
}

/*
 If you open Xcode’s error message you’ll see it says “Value of type 'Arc' has no member 'strokeBorder’” – that is, the strokeBorder() modifier just doesn’t exist on Arc.
 
 There is a small but important difference between SwiftUI’s Circle and our Arc: both conform to the Shape protocol, but Circle also conforms to a second protocol called InsettableShape. This is a shape that can be inset – reduced inwards – by a certain amount to produce another shape. The inset shape it produces can be any other kind of insettable shape, but realistically it should be the same shape just in a smaller rectangle.
 
 To make Arc conform to InsettableShape we need to add one extra method to it: inset(by:). This will be given the inset amount (half the line width of our stroke), and should return a new kind of insettable shape – in our instance that means we should create an inset arc. The problem is, we don’t know the arc’s actual size, because path(in:) hasn’t been called yet.
 
 It turns out the solution is pretty simple: if we give our Arc shape a new insetAmount property that defaults to 0, we can just add to that whenever inset(by:) is called. Adding to the inset allows us to call inset(by:) multiple times if needed, for example if we wanted to call it once by hand then use strokeBorder().
 */

/*
 First, add this new property to Arc:
 
 var insetAmount = 0.0
 
 Then, give it this inset(by:) method:
 
 func inset(by amount: CGFloat) -> some InsettableShape {
 var arc = self
 arc.insetAmount += amount
 return arc
 }
 
 Important: This is one of the very few places where we need to use CGFloat, which is an archaic form of Double that, somewhat bizarrely, wormed its way into SwiftUI. It gets used in many other places too, but mostly Swift lets us use Double instead!
 
 The amount parameter being passed in should be applied to all edges, which in the case of arcs means we should use it to reduce our draw radius. So, change the addArc() call inside path(in:) to be this:
 
 path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
 
 With that change we can now make Arc conform to InsettableShape like this:
 
 struct Arc: InsettableShape {
 
 Note: InsettableShape actually builds upon Shape, so there’s no need to add both there.
 */

struct Arc2: InsettableShape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    var insetAmount = 0.0
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

/*
 Now, we can use the .strokeBorder modifier on our Arc
 */

struct ContentView4: View {
    var body: some View {
        Arc2(startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
            .strokeBorder(.blue, lineWidth: 40)
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
