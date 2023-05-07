//
//  ContentView.swift
//  CustomModifiers
//
//  Created by James Armer on 07/05/2023.
//

import SwiftUI

/*
 SwiftUI gives us a range of built-in modifiers, such as font(), background(), and clipShape(). However, it’s also possible to create custom modifiers that do something specific.

 To create a custom modifier, create a new struct that conforms to the ViewModifier protocol. This has only one requirement, which is a method called body that accepts whatever content it’s being given to work with, and must return some View.

 For example, we might say that all titles in our app should have a particular style, so first we need to create a custom ViewModifier struct that does what we want:
 */

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

/*
 We can now use that with the modifier() modifier – yes, it’s a modifier called “modifier”, but it lets us apply any sort of modifier to a view, like this:
 */

struct ContentView: View {
    var body: some View {
        Text("Hello World")
            .modifier(Title())
    }
}

/*
 When working with custom modifiers, it’s usually a smart idea to create extensions on View that make them easier to use. For example, we might wrap the Title modifier in an extension such as this:
 */

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

/*
 We can now use the modifier like this:
 */

struct ContentView2: View {
    var body: some View {
        Text("Hello World")
            .titleStyle()
    }
}

/*
 Custom modifiers can do much more than just apply other existing modifiers – they can also create new view structure, as needed. Remember, modifiers return new objects rather than modifying existing ones, so we could create one that embeds the view in a stack and adds another view:
 */

struct Watermark: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(.black)
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}

/*
 With that in place, we can now add a watermark to any view like this:
 */

struct ContentView3: View {
    var body: some View {
        Color.blue
            .frame(width: 300, height: 200)
            .watermarked(with: "Hacking with Swift")
    }
}

/*
 Tip: Often folks wonder when it’s better to add a custom view modifier versus just adding a new method to View, and really it comes down to one main reason: custom view modifiers can have their own stored properties, whereas extensions to View cannot.
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
