//
//  ContentView.swift
//  IntroducingList
//
//  Created by James Armer on 10/05/2023.
//

import SwiftUI

/*
 Of all SwiftUI’s view types, List is the one you’ll rely on the most. That doesn’t mean you’ll use it the most – Text or VStack will probably claim that crown – more that it’s such a workhorse that you’ll come back to it time and time again. And this isn’t new: the equivalent of List in UIKit was UITableView, and it got used just as much.
 
 The job of List is to provide a scrolling table of data. In fact, it’s pretty much identical to Form, except it’s used for presentation of data rather than requesting user input. Don’t get me wrong: you’ll use Form quite a lot too, but really it’s just a specialized type of List.
 
 Just like Form, you can provide List a selection of static views to have them rendered in individual rows:
 */

struct ContentView: View {
    var body: some View {
        List {
            Text("Hello World")
            Text("Hello World")
            Text("Hello World")
        }
    }
}

/*
 We can also switch to ForEach in order to create rows dynamically from an array or range:
 */

struct ContentView2: View {
    var body: some View {
        List {
            ForEach(1..<5) {
                Text("Dynamic row \($0)")
            }
        }
    }
}

/*
 Where things get more interesting is the way you can mix static and dynamic rows:
 */

struct ContentView3: View {
    var body: some View {
        List {
            Text("Static Row 1")
            Text("Static Row 2")
            
            ForEach(1..<5) {
                Text("Dynamic row \($0)")
            }
            
            Text("Static Row 3")
            Text("Static Row 4")
        }
    }
}

/*
 And of course we can combine that with sections, to make our list easier to read:
 */

struct ContentView4: View {
    var body: some View {
        List {
            Section("Section 1"){
                Text("Static Row 1")
                Text("Static Row 2")
            }
            
            Section("Section 2"){
                ForEach(1..<5) {
                    Text("Dynamic row \($0)")
                }
            }
            
            Section("Section 3"){
                Text("Static Row 3")
                Text("Static Row 4")
            }
        }
    }
}

/*
 Tip: As you can see, if your section header is just some text you can pass it in directly as a string – it’s a helpful shortcut for times you don’t need anything more advanced.
 
 Being able to have both static and dynamic content side by side lets us recreate something like the Wi-Fi screen in Apple’s Settings app – a toggle to enable Wi-Fi system-wide, then a dynamic list of nearby networks, then some more static cells with options to auto-join hotspots and so on.
 
 You’ll notice that this list looks similar to the form we had previously, but we can adjust how the list looks using the listStyle() modifier, like this:
 */

struct ContentView5: View {
    var body: some View {
        List {
            Section("Section 1"){
                Text("Static Row 1")
                Text("Static Row 2")
            }
            
            Section("Section 2"){
                ForEach(1..<5) {
                    Text("Dynamic row \($0)")
                }
            }
            
            Section("Section 3"){
                Text("Static Row 3")
                Text("Static Row 4")
            }
        }
        .listStyle(.grouped)
    }
}

/*
 Now, everything you’ve seen so far works fine with Form as well as List – even the dynamic content. But one thing List can do that Form can’t is to generate its rows entirely from dynamic content without needing a ForEach.
 
 So, if your entire list is made up of dynamic rows, you can simply write this:
 */

struct ContentView6: View {
    var body: some View {
        List(0..<5) {
            Text("Dynamic row \($0)")
        }
    }
}

/*
 This allows us to create lists really quickly, which is helpful given how common they are.
 
 In this project we’re going to use List slightly differently, because we’ll be making it loop over an array of strings. We’ve used ForEach with ranges a lot, either hard-coded (0..<5) or relying on variable data (0..<students.count), and that works great because SwiftUI can identify each row uniquely based on its position in the range.
 
 When working with an array of data, SwiftUI still needs to know how to identify each row uniquely, so if one gets removed it can simply remove that one rather than having to redraw the whole list. This is where the id parameter comes in, and it works identically in both List and ForEach – it lets us tell SwiftUI exactly what makes each item in the array unique.
 
 When working with arrays of strings and numbers, the only thing that makes those values unique is the values themselves. That is, if we had the array [2, 4, 6, 8, 10], then those numbers themselves are themselves the unique identifiers. After all, we don’t have anything else to work with!
 
 When working with this kind of list data, we use id: \.self like this:
 */

struct ContentView7: View {
    let people = ["Finn", "Leia", "Luke", "Rey"]
    
    var body: some View {
        List(people, id: \.self) {
            Text($0)
        }
    }
}

/*
 That works just the same with ForEach, so if we wanted to mix static and dynamic rows we could have written this instead:
 */


struct ContentView8: View {
    let people = ["Finn", "Leia", "Luke", "Rey"]
    
    var body: some View {
        List {
            Text("Static Row")

            ForEach(people, id: \.self) {
                Text($0)
            }

            Text("Static Row")
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
        ContentView4()
            .previewDisplayName("ContentView 4")
        ContentView5()
            .previewDisplayName("ContentView 5")
        ContentView6()
            .previewDisplayName("ContentView 6")
        ContentView7()
            .previewDisplayName("ContentView 7")
        ContentView8()
            .previewDisplayName("ContentView 8")
    }
}
