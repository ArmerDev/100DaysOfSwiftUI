//
//  ContentView.swift
//  UsingAlert()AndSheet()WithOptionals
//
//  Created by James Armer on 16/07/2023.
//

import SwiftUI

/*
 SwiftUI has two ways of creating alerts and sheets, and so far we’ve mostly only used one: a binding to a Boolean that shows the alert or sheet when the Boolean becomes true.

 The second option allows us to bind an optional to the alert or sheet, and we used it briefly when presenting map pins. If you remember, the key is that we use an optional Identifiable object as the condition for showing the sheet, and the closure hands you the non-optional value that was used for the condition, so you can use it safely.

 To demonstrate this, we could create a trivial User struct that conforms to the Identifiable protocol:
 */

struct User: Identifiable {
    var id = "Taylor Swift"
}

/*
 We could then create a property inside ContentView that tracks which user is selected, set to nil by default:
 */

struct ContentView: View {
    @State private var selectedUser: User? = nil
    
    /*
     Now we can change the body of ContentView so that it sets selectedUser to a value when its text view is tapped, then displays a sheet when selectedUser is given a value:
     */
    var body: some View {
        Text("Hello, World!")
            .onTapGesture {
                selectedUser = User()
            }
            .sheet(item: $selectedUser) { user in
                Text(user.id)
            }
    }
}

/*
 With that simple code, whenever you tap “Hello, World!” a sheet saying “Taylor Swift” appears. As soon as the sheet is dismissed, SwiftUI sets selectedUser back to nil.

 This might seem like a simple piece of functionality, but it’s simpler and safer than the alternative. If we were to rewrite the above code using the old .sheet(isPresented:) modifier it would look like this:
 */

struct ContentView2: View {
    @State private var selectedUser: User? = nil
    @State private var isShowingUser = false

    var body: some View {
        Text("Hello, World!")
            .onTapGesture {
                selectedUser = User()
                isShowingUser = true
            }
            .sheet(isPresented: $isShowingUser) {
                Text(selectedUser?.id ?? "Unknown")
            }
    }
}

/*
 That’s another property, another value to set in the onTapGesture(), and extra code to hand the optional in the sheet() modifier – if you can avoid those things you should.

 Alerts have similar functionality, although you need to pass both the Boolean and optional Identifiable value at the same time. This allows you to show the alert when needed, but also benefit from the same optional unwrapping behavior we have with sheets:
 */

struct ContentView3: View {
    @State private var selectedUser: User? = nil
    @State private var isShowingUser = false

    var body: some View {
        Text("Hello, World!")
            .onTapGesture {
                selectedUser = User()
                isShowingUser = true
            }
            .alert("Welcome", isPresented: $isShowingUser, presenting: selectedUser) { user in
                Button(user.id) { }
            }
    }
}

/*
 With that covered, you now know practically all there is to know about sheets and alerts, but there is one last thing to sneak in to round out your knowledge.

 You see, so far we’ve written lots of alerts like this one:
 */

struct ContentView4: View {
    @State private var selectedUser: User? = nil
    @State private var isShowingUser = false

    var body: some View {
        Text("Hello, World!")
            .onTapGesture {
                selectedUser = User()
                isShowingUser = true
            }
            .alert("Welcome", isPresented: $isShowingUser) {
                Button("OK") { }
            }
    }
}

/*
 That OK button works because all actions dismiss the alert they belong to when they are tapped, and we’ve been using this approach so far because it gives you practice creating alerts and buttons.

 However, I want to show you a neat shortcut. Try this code out:
 */

struct ContentView5: View {
    @State private var selectedUser: User? = nil
    @State private var isShowingUser = false

    var body: some View {
        Text("Hello, World!")
            .onTapGesture {
                selectedUser = User()
                isShowingUser = true
            }
            .alert("Welcome", isPresented: $isShowingUser) { }
    }
}

/*
 When that runs you’ll see something interesting: exactly the same result as before, despite not having a dedicated OK button. SwiftUI spots that we don’t have any actions in the alert, so it adds a default one for us that has the title “OK” and will dismiss the alert when tapped.

 Obviously this doesn’t work in situations where you need other buttons alongside OK, but for simple alerts it’s perfect.
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
