//
//  ContentView.swift
//  ReadingTheValueOfControls
//
//  Created by James Armer on 25/06/2023.
//

import SwiftUI

/*
 By default SwiftUI provides VoiceOver readouts for its user interface controls, and although these are often good sometimes they just don’t fit with what you need. In these situations we can use the accessibilityValue() modifier to separate a control’s value from its label, but we can also specify custom swipe actions using accessibilityAdjustableAction().

 For example, you might build a view that shows some kind of input controlled by various buttons, like a custom stepper
 */

struct ContentView: View {
    @State private var value = 10

    var body: some View {
        VStack {
            Text("Value: \(value)")

            Button("Increment") {
                value += 1
            }

            Button("Decrement") {
                value -= 1
            }
        }
    }
}

/*
 That might work just the way you want with tap interactions, but it’s not a great experience with VoiceOver because all users will hear is “Increment” or “Decrement” every time they tap one of the buttons.

 To fix this we can give iOS specific instructions for how to handle adjustment, by grouping our VStack together using accessibilityElement() and accessibilityLabel(), then by adding the accessibilityValue() and accessibilityAdjustableAction() modifiers to respond to swipes with custom code.

 Adjustable actions hand us the direction the user swiped, and we can respond however we want. There is one proviso: yes, we can choose between increment and decrement swipes, but we also need a special default case to handle unknown future values – Apple has reserved the right to add other kinds of adjustments in the future.

 Here’s how it looks in code:
 */

struct ContentView2: View {
    @State private var value = 10

    var body: some View {
        VStack {
            Text("Value: \(value)")

            Button("Increment") {
                value += 1
            }

            Button("Decrement") {
                value -= 1
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Value")
        .accessibilityValue(String(value))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                value += 1
            case .decrement:
                value -= 1
            default:
                print("Not handled.")
            }
        }
    }
}

/*
 That lets users select the whole VStack to have “Value: 10” read out, but then they can swipe up or down to manipulate the value and have just the numbers read out – it’s a much more natural way of working.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
