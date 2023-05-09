//
//  ContentView.swift
//  EnteringNumbersWithStepper
//
//  Created by James Armer on 09/05/2023.
//

import SwiftUI

/*
 SwiftUI has two ways of letting users enter numbers, and the one we’ll be using here is Stepper: a simple - and + button that can be tapped to select a precise number. The other option is Slider, which we’ll be using later on – it also lets us select from a range of values, but less precisely.

 Steppers are smart enough to work with any kind of number type you like, so you can bind them to Int, Double, and more, and it will automatically adapt. For example, we might create a property like this:
 */

struct ContentView: View {
    @State private var sleepAmount = 8.0
    // We could then bind that to a stepper so that it showed the current value, like this:
    var body: some View {
        Stepper("\(sleepAmount) hours", value: $sleepAmount)
            .padding()
    }
}

/*
 When that code runs you’ll see 8.000000 hours, and you can tap the - and + to step downwards to 7, 6, 5 and into negative numbers, or step upwards to 9, 10, 11, and so on.

 By default steppers are limited only by the range of their storage. We’re using a Double in this example, which means the maximum value of the slider will be absolutely massive.
 
 Stepper lets us limit the values we want to accept by providing an in range, like this:
 */

struct ContentView2: View {
    @State private var sleepAmount = 8.0
    // We could then bind that to a stepper so that it showed the current value, like this:
    var body: some View {
        Stepper("\(sleepAmount) hours", value: $sleepAmount, in: 4...12)
            .padding()
    }
}

/*
 With that change, the stepper will start at 8, then allow the user to move between 4 and 12 inclusive, but not beyond. This allows us to control the sleep range so that users can’t try to sleep for 24 hours, but it also lets us reject impossible values – you can’t sleep for -1 hours, for example.

 There’s a fourth useful parameter for Stepper, which is a step value – how far to move the value each time - or + is tapped. Again, this can be any sort of number, but it needs to match the type used for the binding. So, if you are binding to an integer you can’t then use a Double for the step value.

 In this instance, we might say that users can select any sleep value between 4 and 12, moving in 15 minute increments:
 */

struct ContentView3: View {
    @State private var sleepAmount = 8.0
    // We could then bind that to a stepper so that it showed the current value, like this:
    var body: some View {
        Stepper("\(sleepAmount) hours", value: $sleepAmount, in: 4...12, step: 0.25)
            .padding()
    }
}

/*
 That’s starting to look useful – we have a precise range of reasonable values, a sensible step increment, and users can see exactly what they have chosen each time.

 Before we move on, though, let’s fix that text: it says 8.000000 right now, which is accurate but a little too accurate. To fix this, we can just ask Swift to format the Double using formatted():That’s starting to look useful – we have a precise range of reasonable values, a sensible step increment, and users can see exactly what they have chosen each time.
 
 Before we move on, though, let’s fix that text: it says 8.000000 right now, which is accurate but a little too accurate. To fix this, we can just ask Swift to format the Double using formatted():
 */

struct ContentView4: View {
    @State private var sleepAmount = 8.0
    // We could then bind that to a stepper so that it showed the current value, like this:
    var body: some View {
        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
            .padding()
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
