//
//  ContentView.swift
//  ValidatingAndDisablingForms
//
//  Created by James Armer on 29/05/2023.
//

import SwiftUI

/*
 SwiftUI’s Form view lets us store user input in a really fast and convenient way, but sometimes it’s important to go a step further – to check that input to make sure it’s valid before we proceed.

 Well, we have a modifier just for that purpose: disabled(). This takes a condition to check, and if the condition is true then whatever it’s attached to won’t respond to user input – buttons can’t be tapped, sliders can’t be dragged, and so on. You can use simple properties here, but any condition will do: reading a computed property, calling a method, and so on,

 To demonstrate this, here’s a form that accepts a username and email address:
 */

struct ContentView: View {
    @State private var username = ""
    @State private var email = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
            }
            
            Section {
                Button("Create account") {
                    print("Creating account...")
                }
            }
        }
    }
}

/*
 In this example, we don’t want users to create an account unless both fields have been filled in, so we can disable the form section containing the Create Account button by adding the disabled() modifier like this:
 */

struct ContentView2: View {
    @State private var username = ""
    @State private var email = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
            }
            
            Section {
                Button("Create account") {
                    print("Creating account...")
                }
            }
            .disabled(username.isEmpty || email.isEmpty)
        }
    }
}

/*
 That means “this section is disabled if username is empty or email is empty,” which is exactly what we want.

 You might find that it’s worth spinning out your conditions into a separate computed property, such as this:
 */

struct ContentView3: View {
    @State private var username = ""
    @State private var email = ""
    
    var disableForm: Bool {
        username.count < 5 || email.count < 5
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
            }
            
            Section {
                Button("Create account") {
                    print("Creating account...")
                }
            }
            // Now you can just reference that computed property in your modifier:
            .disabled(disableForm)
        }
    }
}

/*
 Regardless of how you do it, I hope you try running the app and seeing how SwiftUI handles a disabled button – when our test fails the button’s text goes gray, but as soon as the test passes the button lights up blue.

 That brings us to the end of the overview for this project, so please put ContentView.swift back to its original state so we can begin building the main project.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
        ContentView3()
            .previewDisplayName("ContentView 3")
    }
}
