//
//  ContentView.swift
//  AnimatingComplexShapesWithAnimatablePair
//
//  Created by James Armer on 28/05/2023.
//

import SwiftUI

/*
 SwiftUI uses an animatableData property to let us animate changes to shapes, but what happens when we want two, three, four, or more properties to animate? animatableData is a property, which means it must always be one value, however we get to decide what type of value it is: it might be a single Double, or it might be two values contained in a special wrapper called AnimatablePair.
 
 To try this out, let’s look at a new shape called Checkerboard, which must be created with some number of rows and columns:
 
 
 */

struct Checkerboard: Shape {
    var rows: Int
    var columns: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // figure out how big each row/column needs to be
        let rowSize = rect.height / Double(rows)
        let columnSize = rect.width / Double(columns)
        
        // loop over all rows and columns, making alternating squares coloured
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    // this square should be coloured; add a rectangle here
                    let startX = columnSize * Double(column)
                    let startY = rowSize * Double(row)
                    
                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }
        
        return path
    }
}

/*
 We can now create a 4x4 checkerboard in a SwiftUI view, using some state properties that we can change using a tap gesture:
 */

struct ContentView: View {
    @State private var rows = 4
    @State private var columns = 4
    
    var body: some View {
        Checkerboard(rows: rows, columns: columns)
            .frame(width: 400, height: 400)
            .border(.black)
            .onTapGesture {
                withAnimation(.linear(duration: 3)) {
                    rows = 8
                    columns = 16
                }
            }
    }
}

/*
 When that runs you should be able to tap on the black squares to see the checkerboard jump from being 4x4 to 8x16, without animation even though the change is inside a withAnimation() block.
 
 As with simpler shapes, the solution here is to implement an animatableData property that will be set with intermediate values as the animation progresses. Here, though, there are two catches:
 
 We have two properties that we want to animate, not one.
 Our row and column properties are integers, and SwiftUI can’t interpolate integers.
 To resolve the first problem we’re going to use a new type called AnimatablePair. As its name suggests, this contains a pair of animatable values, and because both its values can be animated the AnimatablePair can itself be animated. We can read individual values from the pair using .first and .second.
 
 To resolve the second problem we’re just going to do some type conversion: we can convert a Double to an Int just by using Int(someDouble), and go the other way by using Double(someInt).
 
 So, to make our checkerboard animate changes in the number of rows and columns, add this property:
 
     var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(Double(rows), Double(columns))
        }
     
        set {
            rows = Int(newValue.first)
            columns = Int(newValue.second)
        }
     }
 
 Now when you run the app you should find the change happens smoothly – or as smoothly as you would expect given that we’re rounding numbers to integers.
 */

struct Checkerboard2: Shape {
    var rows: Int
    var columns: Int
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(Double(rows), Double(columns))
        }
        
        set {
            rows = Int(newValue.first)
            columns = Int(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // figure out how big each row/column needs to be
        let rowSize = rect.height / Double(rows)
        let columnSize = rect.width / Double(columns)
        
        // loop over all rows and columns, making alternating squares coloured
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    // this square should be coloured; add a rectangle here
                    let startX = columnSize * Double(column)
                    let startY = rowSize * Double(row)
                    
                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }
        
        return path
    }
}

struct ContentView2: View {
    @State private var rows = 4
    @State private var columns = 4
    
    var body: some View {
        Checkerboard2(rows: rows, columns: columns)
            .frame(width: 400, height: 400)
            .border(.black)
            .onTapGesture {
                withAnimation(.linear(duration: 3)) {
                    rows = 8
                    columns = 16
                }
            }
    }
}

/*
 Of course, the next question is: how do we animate three properties? Or four?

 To answer that, let me show you the animatableData property for SwiftUI’s EdgeInsets type:

 AnimatablePair<CGFloat, AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>>
 
 Yes, they use three separate animatable pairs, then just dig through them using code such as newValue.second.second.first.

 I’m not going to claim this is the most elegant of solutions, but I hope you can understand why it exists: because SwiftUI can read and write the animatable data for a shape regardless of what that data is or what it means, it doesn’t need to re-invoke the body property of our views 60 or even 120 times a second during an animation – it just changes the parts that actually are changing.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
    }
}
