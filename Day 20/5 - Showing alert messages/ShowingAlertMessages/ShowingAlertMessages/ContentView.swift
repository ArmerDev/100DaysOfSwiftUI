//
//  ContentView.swift
//  ShowingAlertMessages
//
//  Created by James Armer on 01/05/2023.
//

import SwiftUI

/*
 
 If something important happens, a common way of notifying the user is using an alert – a pop up window that contains a title, message, and one or two buttons depending on what you need.

 But think about it: when should an alert be shown and how? Views are a function of our program state, and alerts aren’t an exception to that. So, rather than saying “show the alert”, we instead create our alert and set the conditions under which it should be shown.

 A basic SwiftUI alert has a title and a button that dismisses it, but the more interesting part is how we present that alert: we don’t assign the alert to a variable then write something like myAlert.show(), because that would be back to the old “series of events” way of thinking.

 Instead, we create some state that tracks whether our alert is showing. We then attach our alert somewhere to our user interface, telling it to use that state to determine whether the alert is presented or not. SwiftUI will watch showingAlert, and as soon as it becomes true it will show the alert.
 
 Putting that all together, here’s some example code that shows an alert when a button is tapped:
 
 */

struct ContentView: View {
    @State private var showingAlert = false

    var body: some View {
        Button("Show Alert") {
            showingAlert = true
        }
        .alert("Important message", isPresented: $showingAlert) {
            Button("OK") { }
        }
    }
}

/*
 
 That attaches the alert to the button, but honestly it doesn’t matter where the alert() modifier is used – all we’re doing is saying that an alert exists and is shown when showingAlert is true.

 Taking a close look at the alert() modifier, we can see that the first part is the alert title, which is straightforward enough, but there’s also another two-way data binding because SwiftUI will automatically set showingAlert back to false when the alert is dismissed.
 
 When looking at the button, you'll notice that it's an empty closure, meaning that we aren’t assigning any functionality to run when the button is pressed. That doesn’t matter, though, because any button inside an alert will automatically dismiss the alert – that closure is there to let us add any extra functionality beyond just dismissing the alert.
 
 You can add more buttons to your alert, and this is a particularly good place to add roles to make sure it’s clear what each button does:
 
 */

struct ContentView2: View {
    @State private var showingAlert = false

    var body: some View {
        Button("Show Alert") {
            showingAlert = true
        }
        .alert("Important message", isPresented: $showingAlert) {
            Button("Delete", role: .destructive) { }
            Button("Cancel", role: .cancel) { }
        }
    }
}

/*
 
 And finally, you can add message text to go alongside your title with a second trailing closure, like this:
 
 */

struct ContentView3: View {
    @State private var showingAlert = false

    var body: some View {
        Button("Show Alert") {
            showingAlert = true
        }
        .alert("Important message", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please read this.")
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
    }
}
