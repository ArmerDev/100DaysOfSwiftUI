//
//  ContentView.swift
//  ShowingMultipleOptionsWithConfirmationDialog()
//
//  Created by James Armer on 16/06/2023.
//

import SwiftUI

/*
 SwiftUI gives us alert() for presenting important announcements with one or two buttons, and sheet() for presenting whole views on top of the current view, but it also gives us confirmationDialog(): an alternative to alert() that lets us add many buttons.

 Visually alerts and confirmation dialogs are very different: on iPhones, alerts appear in the center of the screen and must actively be dismissed by choosing a button, whereas confirmation dialogs slide up from the bottom, can contain multiple buttons, and can be dismissed by tapping on Cancel or by tapping outside of the options.

 Although they look very different, confirmation dialogs and alerts are created almost identically:

 Both are created by attaching a modifier to our view hierarchy – alert() for alerts and confirmationDialog() for confirmation dialogs.
 Both get shown automatically by SwiftUI when a condition is true.
 Both can be filled with buttons to take various actions.
 Both can have a second closure attached to provide an extra message.
 To demonstrate confirmation dialogs being used, we first need a basic view that toggles some sort of condition. For example, this shows some text, and tapping the text changes a Boolean:
 */

struct ContentView: View {
    @State private var showingConfirmation = false
    @State private var backgroundColor = Color.white

    var body: some View {
        Text("Hello, World!")
            .frame(width: 300, height: 300)
            .background(backgroundColor)
            .onTapGesture {
                showingConfirmation = true
            }
    }
}

/*
 Now for the important part: we need to add another modifier to the text, creating and showing a confirmation dialog when we’re ready.

 Just like alert(), we have a confirmationDialog() modifier that accepts two parameters: a binding that decides whether the dialog is currently presented or not, and a closure that provides the buttons that should be shown – usually provided as a trailing closure.

 We provide our confirmation dialog with a title and optionally also a message, then an array of buttons. These are stacked up vertically on the screen in the order you provide, and it’s generally a good idea to include a cancel button at the end – yes, you can cancel by tapping elsewhere on the screen, but it’s much better to give users the explicit option.

 */

struct ContentView2: View {
    @State private var showingConfirmation = false
    @State private var backgroundColor = Color.white

    var body: some View {
        Text("Hello, World!")
            .frame(width: 300, height: 300)
            .background(backgroundColor)
            .onTapGesture {
                showingConfirmation = true
            }
            .confirmationDialog("Change Background", isPresented: $showingConfirmation) {
                Button("Red") { backgroundColor = .red }
                    Button("Green") { backgroundColor = .green }
                    Button("Blue") { backgroundColor = .blue }
                    Button("Cancel", role: .cancel) { }
            } message: {
                Text("Select a new color")
            }
    }
}

/*
 When you run the app, you should find that tapping the text causes the confirmation dialog to slide over, and tapping its options should cause the text’s background color to change.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
    }
}
