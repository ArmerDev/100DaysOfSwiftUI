//
//  ContentView.swift
//  CreatingASpirographWithSwiftUI
//
//  Created by James Armer on 28/05/2023.
//

import SwiftUI

/*
 To finish off with something that really goes to town with drawing, I’m going to walk you through creating a simple spirograph with SwiftUI. “Spirograph” is the trademarked name for a toy where you place a pencil inside a circle and spin it around the circumference of another circle, creating various geometric patterns that are known as roulettes – like the casino game.

 This code involves a very specific equation. I’m going to explain it, but it’s totally OK to skip this chapter if you’re not interested – this is just for fun, and no new Swift or SwiftUI is covered here.

 Our algorithm has four inputs:

 - The radius of the inner circle.
 - The radius of the outer circle.
 - The distance of the virtual pen from the center of the outer circle.
 - What amount of the roulette to draw. This is optional, but I think it really helps show what’s happening as the algorithm works.
 
 So, let’s start with that:
 */

struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: Double
    
    /*
     We then prepare three values from that data, starting with the greatest common divisor (GCD) of the inner radius and outer radius. Calculating the GCD of two numbers is usually done with Euclid's algorithm, which in a slightly simplified form looks like this:
     */
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        
        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }
        
        return a
    }
    
    /*
     The other two values are the difference between the inner radius and outer radius, and how many steps we need to perform to draw the roulette – this is 360 degrees multiplied by the outer radius divided by the greatest common divisor, multiplied by our amount input. All our inputs work best when provided as integers, but when it comes to drawing the roulette we need to use Double, so we’re also going to create Double copies of our inputs.
     */
    
    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = Double(outerRadius)
        let innerRadius = Double(innerRadius)
        let distance = Double(distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * Double.pi * outerRadius / Double(divisor)) * amount
        
        // more code to come
        
        /*
         Finally we can draw the roulette itself by looping from 0 to our end point, and placing points at precise X/Y coordinates. Calculating the X/Y coordinates for a given point in that loop (known as “theta”) is where the real mathematics comes in, but honestly I just converted the standard equation to Swift from Wikipedia – this is not something I would dream of memorizing!

         X is equal to the radius difference multiplied by the cosine of theta, added to the distance multiplied by the cosine of the radius difference divided by the outer radius multiplied by theta.
         Y is equal to the radius difference multiplied by the sine of theta, subtracting the distance multiplied by the sine of the radius difference divided by the outer radius multiplied by theta.
         That’s the core algorithm, but we’re going to make two small changes: we’re going to add to X and Y half the width or height of our drawing rectangle respectively so that it’s centered in our drawing space, and if theta is 0 – i.e., if this is the first point in our roulette being drawn – we’ll call move(to:) rather than addLine(to:) for our path.

         Here’s the final code for the path(in:) method
         */
        var path = Path()
        
        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)
            
            x += rect.width / 2
            y += rect.height / 2
            
            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}

/*
 That was a lot of heavy mathematics, but the pay off is about to come: we can now use that shape in a view, adding various sliders to control the inner radius, outer radius, distance, amount, and even color:
 */

struct ContentView: View {
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount = 1.0
    @State private var hue = 0.6
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Spirograph(innerRadius: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
                .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
                .frame(width: 300, height: 300)
            
            Spacer()
            
            Group {
                Text("Inner radius: \(Int(innerRadius))")
                Slider(value: $innerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])
                
                Text("Outer radius: \(Int(outerRadius))")
                Slider(value: $outerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])
                
                Text("Distance: \(Int(distance))")
                Slider(value: $distance, in: 1...150, step: 1)
                    .padding([.horizontal, .bottom])
                
                Text("Amount: \(amount, format: .number.precision(.fractionLength(2)))")
                Slider(value: $amount)
                    .padding([.horizontal, .bottom])
                
                Text("Color")
                Slider(value: $hue)
                    .padding(.horizontal)
                
            }
        }
        
    }
}

/*
 That was a lot of code, but I hope you take the time to run the app and appreciate just how beautiful roulettes are. What you’re seeing is actually only one form of a roulette, known as a hypotrochoid – with small adjustments to the algorithm you can generate epitrochoids and more, which are beautiful in different ways.

 Before I finish, I’d like to remind you that the parametric equations used here are mathematical standards rather than things I just invented – I literally went to Wikipedia’s page on hypotrochoids (https://en.wikipedia.org/wiki/Hypotrochoid) and converted them to Swift.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
