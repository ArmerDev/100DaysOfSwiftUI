//
//  ContentView.swift
//  CustomContainers
//
//  Created by James Armer on 07/05/2023.
//

import SwiftUI

/*
 Although it’s not something you’re likely to do often, I want to at least show you that it’s perfectly possible to create custom containers in your SwiftUI apps. This takes more advanced Swift knowledge because it leverages some of Swift’s power features, so it’s OK to skip this if you find it too much.
 
 To try it out, we’re going to make a new type of stack called a GridStack, which will let us create any number of views inside a fixed grid. What we want to say is that there is a new struct called GridStack that conforms to the View protocol and has a set number of rows and columns, and that inside the grid will be lots of content cells that themselves must conform to the View protocol.
 
 In Swift we’d write this:
 */

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        // more to come
        Text("more to come")
    }
}

/*
 The first line – struct GridStack<Content: View>: View – uses a more advanced feature of Swift called generics, which in this case means “you can provide any kind of content you like, but whatever it is it must conform to the View protocol.” After the colon we repeat View again to say that GridStack itself also conforms to the View protocol.
 
 Take particular note of the let content line – that defines a closure that must be able to accept two integers and return some sort of content we can show.
 
 We need to complete the body property with something that combines multiple vertical and horizontal stacks to create as many cells as was requested. We don’t need to say what’s in each cell, because we can get that by calling our content closure with the appropriate row and column.
 
 So, we might fill it in like this:
 
 */

struct GridStack2<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}


/*
 Tip: When looping over ranges, SwiftUI can use the range directly only if we know for sure the values in the range won’t change over time. Here we’re using ForEach with 0..<rows and 0..<columns, both of which are values that can change over time – we might add more rows, for example. In this situation, we need to add a second parameter to ForEach, id: \.self, to tell SwiftUI how it can identify each view in the loop. We’ll go into more detail on this in project 5.
 
 Now that we have a custom container, we can write a view using it like this:
 */

struct ContentView: View {
    var body: some View {
        GridStack(rows: 4, columns: 4) { row, col in
            Text("R\(row) C\(col)")
        }
    }
}

/*
 Our GridStack is capable of accepting any kind of cell content, as long as it conforms to the View protocol. So, we could give cells a stack of their own if we wanted:
 */

struct ContentView2: View {
    var body: some View {
        GridStack(rows: 4, columns: 4) { row, col in
            HStack {
                Image(systemName: "\(row * 4 + col).circle")
                Text("R\(row) C\(col)")
            }
        }
    }
}

/*
 For more flexibility we could leverage the same @ViewBuilder attribute used by SwiftUI for the body property of its views. Modify the content property of GridStack to this:
 */

struct GridStack3<Content: View>: View {
    let rows: Int
    let columns: Int
    @ViewBuilder let content: (Int, Int) -> Content
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}

/*
 With that in place SwiftUI will now automatically create an implicit horizontal stack inside our cell closure:
 */

struct ContentView3: View {
    var body: some View {
        GridStack3(rows: 4, columns: 4) { row, col in
                Image(systemName: "\(row * 4 + col).circle")
                Text("R\(row) C\(col)")
        }
    }
}

/*
 Both options work, so do whichever you prefer.
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
