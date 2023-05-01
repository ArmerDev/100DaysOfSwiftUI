//
//  ContentView.swift
//  Gradients
//
//  Created by James Armer on 01/05/2023.
//

import SwiftUI

/*
 
 SwiftUI gives us three kinds of gradients to work with, and like colors they are also views that can be drawn in our UI.

 Gradients are made up of several components:

 - An array of colors to show
 - Size and direction information
 - The type of gradient to use
 
 For example, a linear gradient goes in one direction, so we provide it with a start and end point like this:
 
 */

struct ContentView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

/*
 
 The inner Gradient type used there can also be provided with gradient stops, which let you specify both a color and how far along the gradient the color should be used. For example, we could specify that our gradient should be white from the start up to 45% of the available space, then black from 55% of the available space onwards:
 
 */

struct ContentView2: View {
    var body: some View {
        LinearGradient(gradient: Gradient(stops: [
            Gradient.Stop(color: .white, location: 0.45),
            Gradient.Stop(color: .black, location: 0.55),
        ]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

/*
 
 That will create a much sharper gradient – it will be compressed into a small space in the center.

 Tip: Swift knows we’re creating gradient stops here, so as a shortcut we can just write .init rather than Gradient.Stop, like this:
 
 */

struct ContentView3: View {
    var body: some View {
        LinearGradient(gradient: Gradient(stops: [
            .init(color: .white, location: 0.45),
            .init(color: .black, location: 0.55),
        ]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

/*
 
 As an alternative, radial gradients move outward in a circle shape, so instead of specifying a direction we specify a start and end radius – how far from the center of the circle the color should start and stop changing. For example:
 
 */

struct ContentView4: View {
    var body: some View {
        RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 20, endRadius: 200)
            .ignoresSafeArea()
    }
}

/*
 
 The last gradient type is called an angular gradient, although you might have heard it referred to elsewhere as a conic or conical gradient. This cycles colors around a circle rather than radiating outward, and can create some beautiful effects.

 For example, this cycles through a range of colors in a single gradient, centered on the middle of the gradient:
 
 */

struct ContentView5: View {
    var body: some View {
        AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
            .ignoresSafeArea()
    }
}

/*
 
 All of these gradient types can have stops provided rather than simple colors. Plus, they can also work as standalone views in your layouts, or be used as part of a modifier – you can use them as the background for a text view, for example.
 
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
    }
}
