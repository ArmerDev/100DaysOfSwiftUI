//
//  ContentView.swift
//  AddingCustomRowSwipeActionsToAList
//
//  Created by James Armer on 30/06/2023.
//

import SwiftUI

/*
 iOS apps have had “swipe to delete” functionality for as long as I can remember, but in more recent years they’ve grown in power so that list rows can have multiple buttons, often on either side of the row. We get this full functionality in SwiftUI using the swipeActions() modifier, which lets us register one or more buttons on one or both sides of a list row.
 
 By default buttons will be placed on the right edge of the row, and won’t have any color, so this will show a single gray button when you swipe from right to left:
 */

struct ContentView: View {
    var body: some View {
        List {
            Text("Taylor Swift")
                .swipeActions {
                    Button {
                        print("Hi")
                    } label: {
                        Label("Send Message", systemImage: "message")
                    }
                }
        }
    }
}

/*
 You can customize the edge where your buttons are placed by providing an edge parameter to your swipeActions() modifier, and you can customize the color of your buttons either by adding a tint() modifier to them with a color of your choosing, or by attaching a button role.

 So, this will display one button on either side of our row:
 */

struct ContentView2: View {
    var body: some View {
        List {
            Text("Taylor Swift")
                .swipeActions {
                    Button(role: .destructive) {
                        print("Hi")
                    } label: {
                        Label("Delete", systemImage: "minus.circle")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        print("Hi")
                    } label: {
                        Label("Pin", systemImage: "pin")
                    }
                    .tint(.orange)
                }
        }
    }
}

/*
 Like context menus, swipe actions are by their very nature hidden to the user by default, so it’s important not to hide important functionality in them. We’ll be using them both in this app, which should hopefully give you the chance to compare and contrast them directly!
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
    }
}
