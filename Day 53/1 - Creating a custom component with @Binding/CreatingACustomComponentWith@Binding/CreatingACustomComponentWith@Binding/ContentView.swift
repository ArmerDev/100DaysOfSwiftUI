//
//  ContentView.swift
//  CreatingACustomComponentWith@Binding
//
//  Created by James Armer on 03/06/2023.
//

import SwiftUI

/*
 You’ve already seen how SwiftUI’s @State property wrapper lets us work with local value types, and how @StateObject lets us work with shareable reference types. Well, there’s a third option, called @Binding, which lets us connect an @State property of one view to some underlying model data.

 Think about it: when we create a toggle switch we send in some sort of Boolean property that can be changed, like this:

 
         @State private var rememberMe = false

         var body: some View {
             Toggle("Remember Me", isOn: $rememberMe)
         }
 
 
 So, the toggle needs to change our Boolean when the user interacts with it, but how does it remember what value it should change?

 That’s where @Binding comes in: it lets us store a mutable value in a view that actually points to some other value from elsewhere. In the case of Toggle, the switch changes its own local binding to a Boolean, but behind the scenes that’s actually manipulating the @State property in our view.

 This makes @Binding extremely important for whenever you want to create a custom user interface component. At their core, UI components are just SwiftUI views like everything else, but @Binding is what sets them apart: while they might have their local @State properties, they also expose @Binding properties that let them interface directly with other views.

 To demonstrate this, we’re going to look at the code it takes to create a custom button that stays down when pressed. Our basic implementation will all be stuff you’ve seen before: a button with some padding, a linear gradient for the background, a Capsule clip shape, and so on
 */

struct PushButton: View {
    let title: String
    @State var isOn: Bool
    
    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]
    
    var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors : offColors), startPoint: .top, endPoint: .bottom))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}

/*
 The only vaguely exciting thing in there is that I used properties for the two gradient colors so they can be customized by whatever creates the button.

 We can now create one of those buttons as part of our main user interface, like this:
 */

struct ContentView: View {
    @State private var rememberMe = false
    
    var body: some View {
        VStack {
            PushButton(title: "Remember Me", isOn: rememberMe)
            Text(rememberMe ? "On" : "Off")
        }
    }
}

/*
 That has a text view below the button so we can track the state of the button – try running your code and see how it works.

 What you’ll find is that tapping the button does indeed affect the way it appears, but our text view doesn’t reflect that change – it always says “Off”. Clearly something is changing because the button’s appearance changes when it’s pressed, but that change isn’t being reflected in ContentView.

 What’s happening here is that we’ve defined a one-way flow of data: ContentView has its rememberMe Boolean, which gets used to create a PushButton – the button has an initial value provided by ContentView. However, once the button was created it takes over control of the value: it toggles the isOn property between true or false internally to the button, but doesn’t pass that change back on to ContentView.

 This is a problem, because we now have two sources of truth: ContentView is storing one value, and PushButton another. Fortunately, this is where @Binding comes in: it allows us to create a two-way connection between PushButton and whatever is using it, so that when one value changes the other does too.

 To switch over to @Binding we need to make just two changes. First, in PushButton change its isOn property to this:

 @Binding var isOn: Bool
 
 And second, in ContentView change the way we create the button to this:

 PushButton(title: "Remember Me", isOn: $rememberMe)
 
 That adds a dollar sign before rememberMe – we’re passing in the binding itself, not the Boolean inside it.

 Now run the code again, and you’ll find that everything works as expected: toggling the button now correctly updates the text view as well.

 This is the power of @Binding: as far as the button is concerned it’s just toggling a Boolean – it has no idea that something else is monitoring that Boolean and acting upon changes.
 */

struct PushButton2: View {
    let title: String
    @Binding var isOn: Bool
    
    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]
    
    var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors : offColors), startPoint: .top, endPoint: .bottom))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}

struct ContentView2: View {
    @State private var rememberMe = false
    
    var body: some View {
        VStack {
            PushButton2(title: "Remember Me", isOn: $rememberMe)
            Text(rememberMe ? "On" : "Off")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
    }
}
