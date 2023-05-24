//
//  ContentView.swift
//  CreatingCustomPathsWithSwiftUI
//
//  Created by James Armer on 24/05/2023.
//

import SwiftUI

/*
 SwiftUI gives us a dedicated Path type for drawing custom shapes. It’s very low level, by which I mean you will usually want to wrap it in something else in order for it to be more useful, but as it’s the building block that underlies other work we’ll do we’re going to start there.

 Just like colors, gradients, and shapes, paths are views in their own right. This means we can use them just like text views and images, although as you’ll see it’s a bit clumsy.

 Let’s start with a simple shape: drawing a triangle. There are a few ways of creating paths, including one that accepts a closure of drawing instructions. This closure must accept a single parameter, which is the path to draw into. I realize this can be a bit brain-bending at first, because we’re creating a path and inside the initializer for the path we’re getting passed the path to draw into, but think of it like this: SwiftUI is creating an empty path for us, then giving us the chance to add to it as much as we want.

 Paths have lots of methods for creating shapes with squares, circles, arcs, and lines. For our triangle we need to move to a stating position, then add three lines like this:
 */

struct ContentView: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 200, y: 100))
            path.addLine(to: CGPoint(x: 100, y: 300))
            path.addLine(to: CGPoint(x: 300, y: 300))
            path.addLine(to: CGPoint(x: 200, y: 100))
        }
    }
}

/*
 We haven’t used CGPoint before, but I did sneak in a quick reference to CGSize back in project 6. “CG” is short for Core Graphics, which provides a selection of basic types that lets us reference X/Y coordinates (CGPoint), widths and heights (CGSize), and rectangular frames (CGRect).

 When our triangle code runs, you’ll see a large black triangle. Where you see it relative to your screen depends on what simulator you are using, which is part of the problem of these raw paths: we need to use exact coordinates, so if you want to use a path by itself you either need to accept that sizing across all devices or use something like GeometryReader to scale them relative to their container.

 We’ll look at a better option shortly, but first let’s look at coloring our path. One option is to use the fill() modifier, like this:
 */

struct ContentView2: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 200, y: 100))
            path.addLine(to: CGPoint(x: 100, y: 300))
            path.addLine(to: CGPoint(x: 300, y: 300))
            path.addLine(to: CGPoint(x: 200, y: 100))
        }
        .fill(.blue)
    }
}

/*
 We can also use the stroke() modifier to draw around the path rather than filling it in:
 */

struct ContentView3: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 200, y: 100))
            path.addLine(to: CGPoint(x: 100, y: 300))
            path.addLine(to: CGPoint(x: 300, y: 300))
            path.addLine(to: CGPoint(x: 200, y: 100))
        }
        .stroke(.blue, lineWidth: 10)
    }
}

/*
 That doesn’t look quite right, though – the bottom corners of our triangle are nice and sharp, but the top corner is broken. This happens because SwiftUI makes sure lines connect up neatly with what comes before and after rather than just being a series of individual lines, but our last line has nothing after it so there’s no way to make a connection.

 One way to fix this is ask SwiftUI to close the subpath, which is the shape we’ve drawn inside our path:
 */

struct ContentView4: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 200, y: 100))
            path.addLine(to: CGPoint(x: 100, y: 300))
            path.addLine(to: CGPoint(x: 300, y: 300))
            path.addLine(to: CGPoint(x: 200, y: 100))
            path.closeSubpath()
        }
        .stroke(.blue, lineWidth: 10)
    }
}

/*
 An alternative is to use SwiftUI’s dedicated StrokeStyle struct, which gives us control over how every line should be connected to the line after it (line join) and how every line should be drawn when it ends without a connection after it (line cap). This is particularly useful because one of the options for join and cap is .round, which creates gently rounded shapes:
 */

struct ContentView5: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 200, y: 100))
            path.addLine(to: CGPoint(x: 100, y: 300))
            path.addLine(to: CGPoint(x: 300, y: 300))
            path.addLine(to: CGPoint(x: 200, y: 100))
            path.closeSubpath()
        }
        .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
    }
}

/*
 With that in place you can remove the call to path.closeSubpath(), because it’s no longer needed.
 */

struct ContentView6: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 200, y: 100))
            path.addLine(to: CGPoint(x: 100, y: 300))
            path.addLine(to: CGPoint(x: 300, y: 300))
            path.addLine(to: CGPoint(x: 200, y: 100))
        }
        .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
    }
}

/*
 Using rounded corners solves the problem of our rough edges, but it doesn’t solve the problem of fixed coordinates. For that we need to move on from paths and look at something more complex: shapes.
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
    }
}
