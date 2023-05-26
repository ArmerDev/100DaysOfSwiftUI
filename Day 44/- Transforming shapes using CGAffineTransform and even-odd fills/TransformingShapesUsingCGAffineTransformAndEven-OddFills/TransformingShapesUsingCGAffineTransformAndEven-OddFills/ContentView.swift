//
//  ContentView.swift
//  TransformingShapesUsingCGAffineTransformAndEven-OddFills
//
//  Created by James Armer on 26/05/2023.
//

import SwiftUI

/*
 When you move beyond simple shapes and paths, two useful features of SwiftUI come together to create some beautiful effects with remarkably little work. The first is CGAffineTransform, which describes how a path or view should be rotated, scaled, or sheared; and the second is even-odd fills, which allow us to control how overlapping shapes should be rendered.
 
 To demonstrate both of these, we’re going to create a flower shape out of several rotated ellipse petals, with each ellipse positioned around a circle. The mathematics behind this is relatively straightforward, with one catch: CGAffineTransform measures angles in radians rather than degrees. If it’s been a while since you were at school, the least you need to know is this: 3.141 radians is equal to 180 degrees, so 3.141 radians multiplied by 2 is equal to 360 degrees. And the 3.141 isn’t a coincidence: the actual value is the mathematical constant pi.
 
 So, what we’re going to do is as follows:
 
 - Create a new empty path.
 
 - Count from 0 up to pi multiplied by 2 (360 degrees in radians), counting in one eighth of pi each time – this will give us 16 petals.
 
 - Create a rotation transform equal to the current number.
 
 - Add to that rotation a movement equal to half the width and height of our draw space, so each petal is centered in our shape.
 
 - Create a new path for a petal, equal to an ellipse of a specific size.
 
 - Apply our transform to that ellipse so it’s moved into position.
 
 - Add that petal’s path to our main path.
 
 This will make more sense once you see the code running, but first I want to add three more small things:
 
 - Rotating something then moving it does not produce the same result as moving then rotating, because when you rotate it first the direction it moves will be different from if it were not rotated.
 
 - To really help you understand what’s going on, we’ll be making our petal ellipses use a couple of properties we can pass in externally.
 
 - Ranges such as 1...5 are great if you want to count through numbers one at a time, but if you want to count in 2s, or in our case count in “pi/8”s, you should use stride(from:to:by:) instead.
 
 Alright, enough talk – add this shape to your project now:
 */

struct Flower: Shape {
    // How much to move this petal away from the centre
    var petalOffset: Double = -20
    
    // How wide to make each petal
    var petalWidth: Double = 100
    
    func path(in rect: CGRect) -> Path {
        // The path that will hold all petals
        var path = Path()
        
        // Count from 0 up to pi * 2, moving up pi / 8 each time
        for number in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {
            
            // rotate the petal by the current value of our loop
            let rotation = CGAffineTransform(rotationAngle: number)
            
            // move the petal to be at the center of our view
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            
            // create a path for this petal using our properties plus a fixed Y and height
            let originalPetal = Path(ellipseIn: CGRect(x: petalOffset, y: 0, width: petalWidth, height: rect.width / 2))
            
            // apply our rotation/position transformation to the petal
            let rotatedPetal = originalPetal.applying(position)
            
            // add it to our main path
            path.addPath(rotatedPetal)
        }
        
        // now send the main path back
        return path
    }
}

/*
 That’s quite a lot of code, but hopefully it will become clearer when you try it out.
 */



struct ContentView: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0

    var body: some View {
        VStack {
            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                .stroke(.red, lineWidth: 1)

            Text("Offset")
            Slider(value: $petalOffset, in: -40...40)
                .padding([.horizontal, .bottom])

            Text("Width")
            Slider(value: $petalWidth, in: 0...100)
                .padding(.horizontal)
        }
    }
}

/*
 Now try that out. You should be able to see exactly how the code works once you start dragging the offset and width sliders around – it’s just a series of rotated ellipses, placed in a circular formation.

 That in itself is interesting, but with one small change we can go from interesting to sublime. If you look at the way our ellipses are being drawn, they overlap frequently – sometimes one ellipse is drawn over another, and sometimes over several others.

 If we fill our path using a solid color, we get a fairly unimpressive result. Try it like this:
 */

struct ContentView2: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0

    var body: some View {
        VStack {
            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                .fill(.red)

            Text("Offset")
            Slider(value: $petalOffset, in: -40...40)
                .padding([.horizontal, .bottom])

            Text("Width")
            Slider(value: $petalWidth, in: 0...100)
                .padding(.horizontal)
        }
    }
}

/*
 But as an alternative, we can fill the shape using the even-odd rule, which decides whether part of a path should be colored depending on the overlaps it contains. It works like this:

 If a path has no overlaps it will be filled.
 If another path overlaps it, the overlapping part won’t be filled.
 If a third path overlaps the previous two, then it will be filled.
 …and so on.
 Only the parts that actually overlap are affected by this rule, and it creates some remarkably beautiful results. Even better, Swift UI makes it trivial to use, because whenever we call fill() on a shape we can pass a FillStyle struct that asks for the even-odd rule to be enabled.

 Try it out with this:
 */

struct ContentView3: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0

    var body: some View {
        VStack {
            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                .fill(.red, style: FillStyle(eoFill: true))

            Text("Offset")
            Slider(value: $petalOffset, in: -40...40)
                .padding([.horizontal, .bottom])

            Text("Width")
            Slider(value: $petalWidth, in: 0...100)
                .padding(.horizontal)
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
    }
}
