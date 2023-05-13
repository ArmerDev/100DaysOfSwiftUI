//
//  ContentView.swift
//  BuildingCustomTransitionsUsingViewModifier
//
//  Created by James Armer on 13/05/2023.
//

import SwiftUI

/*
 It’s possible – and actually surprisingly easy – to create wholly new transitions for SwiftUI, allowing us to add and remove views using entirely custom animations.

 This functionality is made possible by the .modifier transition, which accepts any view modifier we want. The catch is that we need to be able to instantiate the modifier, which means it needs to be one we create ourselves.

 To try this out, we could write a view modifier that lets us mimic the Pivot animation in Keynote – it causes a new slide to rotate in from its top-left corner. In SwiftUI-speak, that means creating a view modifier that causes our view to rotate in from one corner, without escaping the bounds it’s supposed to be in. SwiftUI actually gives us modifiers to do just that: rotationEffect() lets us rotate a view in 2D space, and clipped() stops the view from being drawn outside of its rectangular space.

 rotationEffect() is similar to rotation3DEffect(), except it always rotates around the Z axis. However, it also gives us the ability to control the anchor point of the rotation – which part of the view should be fixed in place as the center of the rotation. SwiftUI gives us a UnitPoint type for controlling the anchor, which lets us specify an exact X/Y point for the rotation or use one of the many built-in options – .topLeading, .bottomTrailing, .center, and so on.

 Let’s put all this into code by creating a CornerRotateModifier struct that has an anchor point to control where the rotation should take place, and an amount to control how much rotation should be applied:
 */

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

/*
 The addition of clipped() there means that when the view rotates the parts that are lying outside its natural rectangle don’t get drawn.

 We can try that straight away using the .modifier transition, but it’s a little unwieldy. A better idea is to wrap that in an extension to AnyTransition, making it rotate from -90 to 0 on its top leading corner:
 */

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: CornerRotateModifier(amount: -90, anchor: .topLeading),
                  identity: CornerRotateModifier(amount: 0, anchor: .topLeading))
    }
}

/*
 With that in place we now attach the pivot animation to any view using this:

 .transition(.pivot)
 For example, we could use the onTapGesture() modifier to make a red rectangle pivot onto the screen, like this:
 */

struct ContentView: View {
    @State private var isShowingRed = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)

            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
