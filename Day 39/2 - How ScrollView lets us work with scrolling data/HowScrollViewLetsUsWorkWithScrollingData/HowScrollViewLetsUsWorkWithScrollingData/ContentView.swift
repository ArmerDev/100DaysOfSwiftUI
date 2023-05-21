//
//  ContentView.swift
//  HowScrollViewLetsUsWorkWithScrollingData
//
//  Created by James Armer on 21/05/2023.
//

/*
 You’ve seen how List and Form let us create scrolling tables of data, but for times when we want to scroll arbitrary data – i.e., just some views we’ve created by hand – we need to turn to SwiftUI’s ScrollView.

 Scroll views can scroll horizontally, vertically, or in both directions, and you can also control whether the system should show scroll indicators next to them – those are the little scroll bars that appear to give users a sense of how big the content is. When we place views inside scroll views, they automatically figure out the size of that content so users can scroll from one edge to the other.

 As an example, we could create a scrolling list of 100 text views like this:
 */

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(0..<100) {
                    Text("Item \($0)")
                        .font(.title)
                }
            }
        }
    }
}

/*
 If you run that back in the simulator you’ll see that you can drag the scroll view around freely, and if you scroll to the bottom you’ll also see that ScrollView treats the safe area just like List and Form – their content goes under the home indicator, but they add some extra padding so the final views are fully visible.

 You might also notice that it’s a bit annoying having to tap directly in the center – it’s more common to have the whole area scrollable. To get that behavior, we should make the VStack take up more space while leaving the default centre alignment intact, like this:
 */

struct ContentView2: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(0..<100) {
                    Text("Item \($0)")
                        .font(.title)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

/*
 Now you can tap and drag anywhere on the screen, which is much more user-friendly.

 This all seems really straightforward, however there’s an important catch that you need to be aware of: when we add views to a scroll view they get created immediately. To demonstrate this, we can create a simple wrapper around a regular text view, like this:
 */

struct CustomText: View {
    let text: String

    var body: some View {
        Text(text)
    }

    init(_ text: String) {
        print("Creating a new CustomText")
        self.text = text
    }
}

/*
 Now we can use that inside our ForEach:
 */

struct ContentView3: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(0..<100) {
                    CustomText("Item \($0)")
                        .font(.title)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

/*
 The result will look identical, but now when you run the app you’ll see “Creating a new CustomText” printed a hundred times in Xcode’s log – SwiftUI won’t wait until you scroll down to see them, it will just create them immediately.

 If you want to avoid this happening, there’s an alternative for both VStack and HStack called LazyVStack and LazyHStack respectively. These can be used in exactly the same way as regular stacks but will load their content on-demand – they won’t create views until they are actually shown, and so minimize the amount of system resources being used.

 So, in this situation we could swap our VStack for a LazyVStack like this:
 */

struct ContentView4: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(0..<100) {
                    CustomText("Item \($0)")
                        .font(.title)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

/*
 Literally all it takes is to add “Lazy” before “VStack” to have our code run more efficiently – it will now only create the CustomText structs when they are actually needed.

 Although the code to use regular and lazy stacks is the same, there is one important layout difference: lazy stacks always take up as much as room as is available in our layouts, whereas regular stacks take up only as much space as is needed. This is intentional, because it stops lazy stacks having to adjust their size if a new view is loaded that wants more space.

 One last thing: you can make horizontal scrollviews by passing .horizontal as a parameter when you make your ScrollView. Once that’s done, make sure you create a horizontal stack or lazy stack, so your content is laid out as you expect:
 */

struct ContentView5: View {
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(0..<100) {
                    CustomText("Item \($0)")
                        .font(.title)
                }
            }
            .frame(maxWidth: .infinity)
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
    }
}
