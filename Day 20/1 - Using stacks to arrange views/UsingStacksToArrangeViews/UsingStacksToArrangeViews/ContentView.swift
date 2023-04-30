//
//  ContentView.swift
//  UsingStacksToArrangeViews
//
//  Created by James Armer on 30/04/2023.
//

import SwiftUI

/*
 
 If we want to display multiple things/views, we have various options to do so. But there are three particularly useful ones - VStack, HStack and ZStack.
 
 */

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
            Text("Another text view")
        }
    }
}

/*
 
 By default VStack places some automatic amount of spacing between the two views, but we can control the spacing by providing a parameter when we create the stack
 
 */

struct ContentView2: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, world!")
            Text("Another text view")
        }
    }
}

/*
 
 Just like SwiftUI’s other views, VStack can have a maximum of 10 children – if you want to add more, you should wrap them inside a Group.
 
 
 By default, VStack aligns its views so they are centered, but you can control that with its alignment property. For example, this aligns the text views to their leading edge, which in a left-to-right language such as English will cause them to be aligned to the left:
 
 */

struct ContentView3: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello, world!")
            Text("Another text view")
        }
    }
}

/*
 
 Alongside VStack we have HStack for arranging things horizontally. This has the same syntax as VStack, including the ability to add spacing and alignment:
 
 */

struct ContentView4: View {
    var body: some View {
        HStack(spacing: 20) {
            Text("Hello, world!")
            Text("Another text view")
        }
    }
}

/*
 
 Vertical and horizontal stacks automatically fit their content, and prefer to align themselves to the center of the available space. If you want to change that you can use one or more Spacer views to push the contents of your stack to one side. These automatically take up all remaining space, so if you add one at the end a VStack it will push all your views to the top of the screen:
 
 */

struct ContentView5: View {
    var body: some View {
        VStack {
            Text("First")
            Text("Second")
            Text("Third")
            Spacer()
        }
    }
}

/*
 
 If you add more than one spacer they will divide the available space between them. So, for example we could have one third of the space at the top and two thirds at the bottom, like this:
 
 */

struct ContentView6: View {
    var body: some View {
        VStack {
            Spacer()
            Text("First")
            Text("Second")
            Text("Third")
            Spacer()
            Spacer()
        }
    }
}

/*
 
 We also have ZStack for arranging things by depth – it makes views that overlap. In the case of our two text views, this will make things rather hard to read:
 
 */

struct ContentView7: View {
    var body: some View {
        ZStack {
            Text("Hello, world!")
            Text("This is inside a stack")
        }
    }
}

/*
 
 ZStack doesn’t have the concept of spacing because the views overlap, but it does have alignment. So, if you have one large thing and one small thing inside your ZStack, you can make both views align to the top like this: ZStack(alignment: .top) {.

 ZStack draws its contents from top to bottom, back to front. This means if you have an image then some text ZStack will draw them in that order, placing the text on top of the image.
 
 You can combine these stacks. For example, you can place several horizontal stacks inside a single vertical stack:
 
 */

struct ContentView8: View {
    var body: some View {
        VStack {
            HStack {
                Rectangle()
                Rectangle()
                Rectangle()
            }
            HStack {
                Rectangle()
                Rectangle()
                Rectangle()
            }
            HStack {
                Rectangle()
                Rectangle()
                Rectangle()
            }
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDisplayName("VStack")
        ContentView2()
            .previewDisplayName("VStack Spacing")
        ContentView3()
            .previewDisplayName("VStack Alignment")
        ContentView4()
            .previewDisplayName("HStack Spacing")
        ContentView5()
            .previewDisplayName("Spacer")
        ContentView6()
            .previewDisplayName("Multiple Spacer")
        ContentView7()
            .previewDisplayName("ZStack")
        ContentView8()
            .previewDisplayName("Stacks within Stacks")
    }
}
