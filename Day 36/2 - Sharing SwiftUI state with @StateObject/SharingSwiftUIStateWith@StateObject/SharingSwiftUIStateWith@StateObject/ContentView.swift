//
//  ContentView.swift
//  SharingSwiftUIStateWith@StateObject
//
//  Created by James Armer on 18/05/2023.
//

import SwiftUI

/*
 If you want to use a class with your SwiftUI data – which you will want to do if that data should be shared across more than one view – then SwiftUI gives us three property wrappers that are useful: @StateObject, @ObservedObject, and @EnvironmentObject. We’ll be looking at environment objects later on, but for now let’s focus on the first two.

 Here’s some code that creates a User class, and shows that user data in a view:
 */

class User {
    var firstName = "Bilbo"
    var lastName = "Baggins"
}

struct ContentView: View {
    @State private var user = User()
    
    var body: some View {
        VStack {
            Text("Your name is \(user.firstName) \(user.lastName).")
            
            TextField("First name", text: $user.firstName)
            TextField("Last name", text: $user.lastName)
        }
    }
}

/*
 However, that code won’t work as intended: we’ve marked the user property with @State, which is designed to track local structs rather than external classes. As a result, we can type into the text fields but the text view above won’t be updated.

 To fix this, we need to tell SwiftUI when interesting parts of our class have changed. By “interesting parts” I mean parts that should cause SwiftUI to reload any views that are watching our class – it’s possible you might have lots of properties inside your class, but only a few should be exposed to the wider world in this way.

 Our User class has two properties: firstName and lastName. Whenever either of those two changes, we want to notify any views that are watching our class that a change has happened so they can be reloaded. We can do this using the @Published property observer, like this:
 */

class User2 {
    @Published var firstName = "Bilbo"
    @Published var lastName = "Baggins"
}

/*
 @Published is more or less half of @State: it tells Swift that whenever either of those two properties changes, it should send an announcement out to any SwiftUI views that are watching that they should reload.

 How do those views know which classes might send out these notifications? That’s another property wrapper, @StateObject, which is the other half of @State – it tells SwiftUI that we’re creating a new class instance that should be watched for any change announcements.

 So, change the user property to @StateObject. However, once changed our code will no longer compile. It’s not a problem, and in fact it’s expected and easy to fix: the @StateObject property wrapper can only be used on types that conform to the ObservableObject protocol. This protocol has no requirements, and really all it means is “we want other things to be able to monitor this for changes.”
 
 So, modify the User class to conform to ObservableObject:
 */

class User3: ObservableObject {
    @Published var firstName = "Bilbo"
    @Published var lastName = "Baggins"
}

struct ContentView2: View {
    @StateObject var user = User3()
    // ERROR: Generic struct 'StateObject' requires that 'User2' conform to 'ObservableObject'
    
    var body: some View {
        VStack {
            Text("Your name is \(user.firstName) \(user.lastName).")
            
            TextField("First name", text: $user.firstName)
            TextField("Last name", text: $user.lastName)
        }
    }
}

/*
 Our code will now compile again, and, even better, it will now actually work again – you can run the app and see the text view update when either text field is changed.

 As you’ve seen, rather than just using @State to declare local state, we now take three steps:

 Make a class that conforms to the ObservableObject protocol.
 Mark some properties with @Published so that any views using the class get updated when they change.
 Create an instance of our class using the @StateObject property wrapper.
 The end result is that we can have our state stored in an external object, and, even better, we can now use that object in multiple views and have them all point to the same values.

 However, there is a catch. Like I said earlier, @StateObject tells SwiftUI that we’re creating a new class instance that should be watched for any change announcements, but that should only be used when you’re creating the object like we are with our User instance.

 When you want to use a class instance elsewhere – when you’ve created it in view A using @StateObject and want to use that same object in view B – you use a slightly different property wrapper called @ObservedObject. That’s the only difference: when creating the shared data use @StateObject, but when you’re just using it in a different view you should use @ObservedObject instead.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
    }
}
