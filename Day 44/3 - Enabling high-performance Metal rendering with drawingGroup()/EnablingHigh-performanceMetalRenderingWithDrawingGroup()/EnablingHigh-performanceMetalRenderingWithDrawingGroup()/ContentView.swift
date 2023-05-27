//
//  ContentView.swift
//  EnablingHigh-performanceMetalRenderingWithDrawingGroup()
//
//  Created by James Armer on 27/05/2023.
//

import SwiftUI

/*
 SwiftUI uses Core Animation for its rendering by default, which offers great performance out of the box. However, for complex rendering you might find your code starts to slow down – anything below 60 frames per second (FPS) is a problem, but really you ought to aim higher because many iOS devices now render at 120fps.

 To demonstrate this, let’s look at some example code. We’re going to create a color-cycling view that renders concentric circles in a range of colors. The result will look like a radial gradient, but we’re going to add two properties to make it more customizable: one to control how many circles should be drawn, and one to control the color cycle – it will be able to move the gradient start and end colors around.

 We can get a color cycling effect by using the Color(hue:saturation:brightness:) initializer: hue is a value from 0 to 1 controlling the kind of color we see – red is both 0 and 1, with all other hues in between. To figure out the hue for a particular circle we can take our circle number (e.g. 25), divide that by how many circles there are (e.g. 100), then add our color cycle amount (e.g. 0.5). So, if we were circle 25 of 100 with a cycle amount of 0.5, our hue would be 0.75.

 One small complexity here is that hues don’t automatically wrap after we reach 1.0, which means a hue of 1.0 is equal to a hue of 0.0, but a hue of 1.2 is not equal to a hue of 0.2. As a result, we’re going to wrap the hue by hand: if it’s over 1.0 we’ll subtract 1.0, to make sure it always lies in the range of 0.0 to 1.0.

 Here’s the code:
 */

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: Double(value))
                    .strokeBorder(color(for: value, brightness: 1), lineWidth: 2)
            }
        }
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

/*
 We can now use that in a layout, binding its color cycle to a local property controlled by a slider:
 */

struct ContentView: View {
    @State private var colorCycle = 0.0

    var body: some View {
        VStack {
            ColorCyclingCircle(amount: colorCycle)
                .frame(width: 300, height: 300)

            Slider(value: $colorCycle)
        }
    }
}

/*
 If you run the app you’ll see we have a neat color wave effect controlled entirely by dragging around the slider, and it works really smoothly.

 What you’re seeing right now is powered by Core Animation, which means it will turn our 100 circles into 100 individual views being drawn onto the screen. This is computationally expensive, but as you can see it works well enough – we get smooth performance.

 However, if we increase the complexity a little we’ll find things aren’t quite so rosy. Replace the existing strokeBorder() modifier with this one:
 */

struct ColorCyclingCircle2: View {
    var amount = 0.0
    var steps = 100

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: Double(value))
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color(for: value, brightness: 1),
                                color(for: value, brightness: 0.5)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
            }
        }
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ContentView2: View {
    @State private var colorCycle = 0.0

    var body: some View {
        VStack {
            ColorCyclingCircle2(amount: colorCycle)
                .frame(width: 300, height: 300)

            Slider(value: $colorCycle)
        }
    }
}

/*
 That now renders a gentle gradient, showing bright colors at the top of the circle down to darker colors at the bottom. And now when you run the app you’ll find it runs much slower – SwiftUI is struggling to render 100 gradients as part of 100 separate views.

 We can fix this by applying one new modifier, called drawingGroup(). This tells SwiftUI it should render the contents of the view into an off-screen image before putting it back onto the screen as a single rendered output, which is significantly faster. Behind the scenes this is powered by Metal, which is Apple’s framework for working directly with the GPU for extremely fast graphics.

 So, modify the ColorCyclingCircle body to this:
 */

struct ColorCyclingCircle3: View {
    var amount = 0.0
    var steps = 100

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: Double(value))
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color(for: value, brightness: 1),
                                color(for: value, brightness: 0.5)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
            }
        }
        .drawingGroup()
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ContentView3: View {
    @State private var colorCycle = 0.0

    var body: some View {
        VStack {
            ColorCyclingCircle3(amount: colorCycle)
                .frame(width: 300, height: 300)

            Slider(value: $colorCycle)
        }
    }
}

/*
 Now run it again – with that one tiny addition you’ll now find we get everything rendered correctly and we’re also back at full speed even with the gradients.
 
 (Run in the actual simulator rather than Xcode preview)

 Important: The drawingGroup() modifier is helpful to know about and to keep in your arsenal as a way to solve performance problems when you hit them, but you should not use it that often. Adding the off-screen render pass might slow down SwiftUI for simple drawing, so you should wait until you have an actual performance problem before trying to bring in drawingGroup().
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
