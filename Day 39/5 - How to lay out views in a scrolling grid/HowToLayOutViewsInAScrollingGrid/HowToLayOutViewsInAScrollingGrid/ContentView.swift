//
//  ContentView.swift
//  HowToLayOutViewsInAScrollingGrid
//
//  Created by James Armer on 22/05/2023.
//

import SwiftUI

/*
 SwiftUI’s List view is a great way to show scrolling rows of data, but sometimes you also want columns of data – a grid of information, that is able to adapt to show more data on larger screens.

 In SwiftUI this is accomplished with two views: LazyHGrid for showing horizontal data, and LazyVGrid for showing vertical data. Just like with lazy stacks, the “lazy” part of the name is there because SwiftUI will automatically delay loading the views it contains until the moment they are needed, meaning that we can display more data without chewing through a lot of system resources.

 Creating a grid is done in two steps. First, we need to define the rows or columns we want – we only define one of the two, depending on which kind of grid we want.

 For example, if we have a vertically scrolling grid then we might say we want our data laid out in three columns exactly 80 points wide by adding this property to our view:
 */

struct ContentView: View {
    let layout = [
        GridItem(.fixed(80)),
        GridItem(.fixed(80)),
        GridItem(.fixed(80))
    ]
    
    /*
     Once you have your lay out defined, you should place your grid inside a ScrollView, along with as many items as you want. Each item you create inside the grid is automatically assigned a column in the same way that rows inside a list automatically get placed inside their parent.

     For example, we could render 1000 items inside our three-column grid like this:
     */
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(0..<1000) {
                    Text("Item \($0)")
                }
            }
        }
    }
}

/*
 That works for some situations, but the best part of grids is their ability to work across a variety of screen sizes. This can be done with a different column layout using adaptive sizes, like this:
 */

struct ContentView2: View {
    let layout = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(0..<1000) {
                    Text("Item \($0)")
                }
            }
        }
    }
}

/*
 That tells SwiftUI we’re happy to fit in as many columns as possible, as long as they are at least 80 points in width. You can also specify a maximum range for even more control:
 */

struct ContentView3: View {
    let layout = [
        GridItem(.adaptive(minimum: 80, maximum: 120))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(0..<1000) {
                    Text("Item \($0)")
                }
            }
        }
    }
}

/*
Paul tends to rely on these adaptive layouts the most, because they allow grids that make maximum use of available screen space.

 Before we’re done, let's briefly look at how to make horizontal grids. The process is almost identical, you just need to make your ScrollView work horizontally, then create a LazyHGrid using rows rather than columns:
 */

struct ContentView4: View {
    let layout = [
        GridItem(.adaptive(minimum: 80, maximum: 120))
    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: layout) {
                ForEach(0..<1000) {
                    Text("Item \($0)")
                }
            }
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
    }
}
