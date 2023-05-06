//
//  ContentView.swift
//  ConditionalModifiers
//
//  Created by James Armer on 06/05/2023.
//

import SwiftUI

/*
 It’s common to want modifiers that apply only when a certain condition is met, and in SwiftUI the easiest way to do that is with the ternary conditional operator.

 As a reminder, to use the ternary operator you write your condition first, then a question mark and what should be used if the condition is true, then a colon followed by what should be used if the condition is false. If you forget this order a lot, remember Scott Michaud’s helpful mnemonic: What do you want to check, True, False, or “WTF” for short.

 For example, if you had a property that could be either true or false, you could use that to control the foreground color of a button like this:
 */

struct ContentView: View {
    @State private var useRedText = false

    var body: some View {
        Button("Hello World") {
            // flip the Boolean between true and false
            useRedText.toggle()
        }
        .foregroundColor(useRedText ? .red : .blue)
    }
}

/*
 So, when useRedText is true the modifier effectively reads .foregroundColor(.red), and when it’s false the modifier becomes .foregroundColor(.blue). Because SwiftUI watches for changes in our @State properties and re-invokes our body property, whenever that property changes the color will immediately update.

 You can often use regular if conditions to return different views based on some state, but this actually creates more work for SwiftUI – rather than seeing one Button being used with different colors, it now sees two different Button views, and when we flip the Boolean condition it will destroy one to create the other rather than just recolor what it has.

 So, this kind of code might look the same, but it’s actually less efficient:
 */

struct ContentView2: View {
    @State private var useRedText = false

    var body: some View {
        if useRedText {
            Button("Hello World") {
                useRedText.toggle()
            }
            .foregroundColor(.red)
        } else {
            Button("Hello World") {
                useRedText.toggle()
            }
            .foregroundColor(.blue)
        }
    }
}

/*
 Sometimes using if statements are unavoidable, but where possible prefer to use the ternary operator instead.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
