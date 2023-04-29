//
//  ContentView.swift
//  BindingStateToUserInterfaceControls
//
//  Created by James Armer on 29/04/2023.
//

import SwiftUI

/*
 
 SwiftUI’s @State property wrapper lets us modify our view structs freely, which means as our program changes we can update our view properties to match.

 However, things are a little more complex with user interface controls. For example, if you wanted to create an editable text box that users can type into.
 
 Remember, views are a function of their state – the text field can only show something if it reflects a value stored in your program. What SwiftUI wants is a string property in our struct that can be shown inside the text field, and will also store whatever the user types in the text field.
 
 In the case of our text field, Swift needs to make sure whatever is in the text is also in the name property, so that it can fulfill its promise that our views are a function of their state – that everything the user can see is just the visible representation of the structs and properties in our code.

 This is what’s called a two-way binding: we bind the text field so that it shows the value of our property, but we also bind it so that any changes to the text field also update the property.

 In Swift, we mark these two-way bindings with a special symbol so they stand out: we write a dollar sign before them. This tells Swift that it should read the value of the property but also write it back as any changes happen.
 
 
 
 So remember, when you see a dollar sign before a property name, remember that it creates a two-way binding: the value of the property is read, but also written.
 
 */

struct ContentView: View {
    @State private var name = ""
    
    var body: some View {
        Form {
            TextField("Enter your name", text: $name)
            Text("Your name is \(name)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
