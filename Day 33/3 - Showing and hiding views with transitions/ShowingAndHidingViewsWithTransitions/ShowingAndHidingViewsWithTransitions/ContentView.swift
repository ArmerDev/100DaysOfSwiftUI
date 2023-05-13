//
//  ContentView.swift
//  ShowingAndHidingViewsWithTransitions
//
//  Created by James Armer on 13/05/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Tap Me") {
                // do nothing
            }
            
            Rectangle()
                .fill(.red)
                .frame(width: 200, height: 200)
        }
    }
}

/*
 We can make the rectangle appear only when a certain condition is satisfied. First, we add some state we can manipulate, Next we use that state as a condition for showing our rectangle. Finally we can toggle isShowingRed between true and false in the button’s action:
 */

struct ContentView2: View {
    @State private var isShowingRed = false
    
    var body: some View {
        VStack {
            Button("Tap Me") {
                isShowingRed.toggle()
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
            }
        }
    }
}

/*
 If you run the program, you’ll see that pressing the button shows and hides the red square. There’s no animation; it just appears and disappears abruptly.

 We can get SwiftUI’s default view transition by wrapping the state change using withAnimation(), like this:
 */

struct ContentView3: View {
    @State private var isShowingRed = false
    
    var body: some View {
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
            }
        }
    }
}

/*
 With that small change, the app now fades the red rectangle in and out, while also moving the button up to make space. It looks OK, but we can do better with the transition() modifier.
 
 (Note: You may have to run the simulator to see this effect, as the preview doesn't seem to fade the appearance of the the red rectangle)

 For example, we could have the rectangle scale up and down as it is shown just by adding the transition() modifier to it:
 */

struct ContentView4: View {
    @State private var isShowingRed = false
    
    var body: some View {
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.scale)
            }
        }
    }
}

/*
 Now tapping the button looks much better: the rectangle scales up as the button makes space, then scales down when tapped again.

 There are a handful of other transitions you can try if you want to experiment. A useful one is .asymmetric, which lets us use one transition when the view is being shown and another when it’s disappearing. To try it out, replace the rectangle’s existing transition with this:
        .transition(.asymmetric(insertion: .scale, removal: .opacity))
 */

struct ContentView5: View {
    @State private var isShowingRed = false
    
    var body: some View {
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
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
        ContentView4()
            .previewDisplayName("ContentView 4")
        ContentView5()
            .previewDisplayName("ContentView 5")
    }
}
