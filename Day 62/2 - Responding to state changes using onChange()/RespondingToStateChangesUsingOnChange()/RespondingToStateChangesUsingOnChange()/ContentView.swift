//
//  ContentView.swift
//  RespondingToStateChangesUsingOnChange()
//
//  Created by James Armer on 16/06/2023.
//

import SwiftUI

/*
 Because of the way SwiftUI sends binding updates to property wrappers, assigning property observers used with property wrappers often won’t work, which means this kind of code won’t print anything even as the blur radius changes:
 */

struct ContentView: View {
    @State private var blurAmount: CGFloat = 0.0 {
        didSet {
            print("New value is \(blurAmount)")
        }
    }

    var body: some View {
        VStack {
            Text("Hello, World!")
                .blur(radius: blurAmount)

            Slider(value: $blurAmount, in: 0...20)
        }
    }
}

/*
 To fix this we need to use the onChange() modifier, which tells SwiftUI to run a function of our choosing when a particular value changes. SwiftUI will automatically pass in the new value to whatever function you attach, or you can just read the original property if you prefer:
 */

struct ContentView2: View {
    @State private var blurAmount = 0.0
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .blur(radius: blurAmount)
            
            Slider(value: $blurAmount, in: 0...20)
                .onChange(of: blurAmount) { newValue in
                    print("New value is \(newValue)")
                }
        }
    }
}

/*
 Now that code will correctly print out values as the slider changes, because onChange() is watching it. Notice how most other things have stayed the same: we still use @State private var to declare the blurAmount property, and we still use blur(radius: blurAmount) as the modifier for our text view.

 What all this means is that you can do whatever you want inside the onChange() function: you can call methods, run an algorithm to figure out how to apply the change, or whatever else you might need.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
    }
}
