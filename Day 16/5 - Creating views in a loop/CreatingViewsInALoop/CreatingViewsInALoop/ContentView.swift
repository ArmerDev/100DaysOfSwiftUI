//
//  ContentView.swift
//  CreatingViewsInALoop
//
//  Created by James Armer on 29/04/2023.
//

import SwiftUI

/*
 
 It’s common to want to create several SwiftUI views inside a loop. For example, we might want to loop over an array of names and have each one be a text view, or loop over an array of menu items and have each one be shown as an image.

 SwiftUI gives us a dedicated view type for this purpose, called ForEach. This can loop over arrays and ranges, creating as many views as needed. Even better, ForEach doesn’t get hit by the 10-view limit that would affect us if we had typed the views by hand.

 ForEach will run a closure once for every item it loops over, passing in the current loop item. For example, if we looped from 0 to 100 it would pass in 0, then 1, then 2, and so on.

 */

// For example, this creates a form with 100 rows:
struct ContentView: View {
    var body: some View {
        Form {
            ForEach(0 ..< 100) { number in
                Text("Row \(number)")
            }
        }
    }
}

// Because ForEach passes in a closure, we can use shorthand syntax for the parameter name, like this:
struct ContentView2: View {
    var body: some View {
        Form {
            ForEach(0 ..< 100) {
                Text("Row \($0)")
            }
        }
    }
}

/*
 
 ForEach is particularly useful when working with SwiftUI’s Picker view, which lets us show various options for users to select from.

 To demonstrate this, we’re going to define a view that:

 - Has an array of possible student names.
 - Has an @State property storing the currently selected student.
 - Creates a Picker view asking users to select their favourite, using a two-way binding to the @State property.
 - Uses ForEach to loop over all possible student names, turning them into a text view.
 
 */

// Here's the code for that:
struct ContentView3: View {
    let students = ["Harry", "Hermione", "Ron"]
    @State private var selectedStudent = "Harry"

    var body: some View {
        NavigationView {
            Form {
                Picker("Select your student", selection: $selectedStudent) {
                    ForEach(students, id: \.self) {
                        Text($0)
                    }
                }
            }
            .navigationTitle("Hogwarts Students")
        }
    }
}

/*
 
 There’s not a lot of code in there, but it’s worth clarifying a few things:

 - The students array doesn’t need to be marked with @State because it’s a constant; it isn’t going to change.
 - The selectedStudent property starts with the value “Harry” but can change, which is why it’s marked with @State.
 - The Picker has a label, “Select your student”, which tells users what it does and also provides something descriptive for screen readers to read aloud.
 - The Picker has a two-way binding to selectedStudent, which means it will start showing a selection of “Harry” but update the property when the user selects something else.
 - Inside the ForEach we loop over all the students.
 - For each student we create one text view, showing that student’s name.
 
 The only confusing part in there is this: ForEach(students, id: \.self). That loops over the students array so we can create a text view for each one, but the id: \.self part is important. This exists because SwiftUI needs to be able to identify every view on the screen uniquely, so it can detect when things change.

 For example, if we rearranged our array so that Ron came first, SwiftUI would move its text view at the same time. So, we need to tell SwiftUI how it can identify each item in our string array uniquely – what about each string makes it unique? If we had an array of structs we might say “oh, my struct has a title string that is always unique,” or “my struct has an id integer that is always unique.” Here, though, we just have an array of simple strings, and the only thing unique about the string is the string itself: each string in our array is different, so the strings are naturally unique.

 So, when we’re using ForEach to create many views and SwiftUI asks us what identifier makes each item in our string array unique, our answer is \.self, which means “the strings themselves are unique.” This does of course mean that if you added duplicate strings to the students array you might hit problems, but here it’s just fine.
 
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDisplayName("ContentView1")
        ContentView2()
            .previewDisplayName("ContentView2")
        ContentView3()
            .previewDisplayName("ContentView3")
    }
}
