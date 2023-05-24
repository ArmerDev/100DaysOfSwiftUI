//
//  ContentView.swift
//  PathsVsShapesInSwiftUI
//
//  Created by James Armer on 24/05/2023.
//

import SwiftUI

/*
 SwiftUI enables custom drawing with two subtly different types: paths and shapes. A path is a series of drawing instructions such as “start here, draw a line to here, then add a circle there”, all using absolute coordinates. In contrast, a shape has no idea where it will be used or how big it will be used, but instead will be asked to draw itself inside a given rectangle.

 Helpfully, shapes are built using paths, so once you understand paths shapes are easy. Also, just like paths, colors, and gradients, shapes are views, which means we can use them alongside text views, images, and so on.

 SwiftUI implements Shape as a protocol with a single required method: given the following rectangle, what path do you want to draw? This will still create and return a path just like using a raw path directly, but because we’re handed the size the shape will be used at we know exactly how big to draw our path – we no longer need to rely on fixed coordinates.

 For example, previously we created a triangle using a Path, but we could wrap that in a shape to make sure it automatically takes up all the space available like this:
 */

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

/*
 That job is made much easier by CGRect, which provides helpful properties such as minX (the smallest X value in the rectangle), maxX (the largest X value in the rectangle), and midX (the mid-point between minX and maxX).

 We could then create a red triangle at a precise size like this:
 */

struct ContentView: View {
    var body: some View {
        Triangle()
            .fill(.red)
            .frame(width: 300, height: 300)
    }
}

/*
 Shapes also support the same StrokeStyle parameter for creating more advanced strokes:
 */

struct ContentView2: View {
    var body: some View {
        Triangle()
            .stroke(.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .frame(width: 300, height: 300)
    }
}

/*
 The key to understanding the difference between Path and Shape is reusability: paths are designed to do one specific thing, whereas shapes have the flexibility of drawing space and can also accept parameters to let us customize them further.

 To demonstrate this, we could create an Arc shape that accepts three parameters: start angle, end angle, and whether to draw the arc clockwise or not. This might seem simple enough, particularly because Path has an addArc() method, but as you’ll see it has a couple of interesting quirks.

 Let’s start with the simplest version of an arc shape:
 */

struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        
        return path
    }
}

/*
 We can now create an arc like this:
 */

struct ContentView3: View {
    var body: some View {
        Arc(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: true)
            .stroke(.blue, lineWidth: 10)
            .frame(width: 300, height: 300)
    }
}

/*
 If you look at the preview of our arc, chances are it looks nothing like you expect. We asked for an arc from 0 degrees to 110 degrees with a clockwise rotation, but we appear to have been given an arc from 90 degrees to 200 degrees with a counterclockwise rotation.

 What’s happening here is two-fold:

 In the eyes of SwiftUI 0 degrees is not straight upwards, but instead directly to the right.
 Shapes measure their coordinates from the bottom-left corner rather than the top-left corner, which means SwiftUI goes the other way around from one angle to the other. This is, in my not very humble opinion, extremely alien.
 We can fix both of those problems with a new path(in:) method that subtracts 90 degrees from the start and end angles, and also flips the direction so SwiftUI behaves the way nature intended:
 */

struct Arc2: Shape {
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

struct ContentView4: View {
    var body: some View {
        Arc2(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: true)
            .stroke(.blue, lineWidth: 10)
            .frame(width: 300, height: 300)
    }
}

/*
 Run that code and see what you think – to me it produces a much more natural way of working, and neatly isolates SwiftUI’s drawing behavior.
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
