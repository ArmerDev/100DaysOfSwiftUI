//
//  ContentView.swift
//  ShowingAndHidingViews
//
//  Created by James Armer on 18/05/2023.
//

import SwiftUI

/*
 There are several ways of showing views in SwiftUI, and one of the most basic is a sheet: a new view presented on top of our existing one. On iOS this automatically gives us a card-like presentation where the current view slides away into the distance a little and the new view animates in on top.

 Sheets work much like alerts, in that we don’t present them directly with code such as mySheet.present() or similar. Instead, we define the conditions under which a sheet should be shown, and when those conditions become true or false the sheet will either be presented or dismissed respectively.

 Let’s start with a simple example, which will be showing one view from another using a sheet. First, we create the view we want to show inside a sheet, like this:
 */

struct SecondView: View {
    var body: some View {
        Text("Second View")
    }
}

/*
 There’s nothing special about that view at all – it doesn’t know it’s going to be shown in a sheet, and doesn’t need to know it’s going to be shown in a sheet.

 Next we create our initial view, which will show the second view. We’ll make it simple, then add to it:
 */

struct ContentView: View {
    var body: some View {
        Button("Show Sheet") {
            // show the sheet
        }
    }
}

/*
 Filling that in requires four steps, and we’ll tackle them individually.

 First, we need some state to track whether the sheet is showing. Just as with alerts, this can be a simple Boolean, so add a state property to ContentView called showingSheet and set it to false.
 
 Second, we need to toggle that when our button is tapped, so replace the // show the sheet comment with showingSheet.toggle()
 
 Third, we need to attach our sheet somewhere to our view hierarchy. If you remember, we show alerts using isPresented with a two-way binding to our state property, and we use something almost identical here: sheet(isPresented:).

 sheet() is a modifier just like alert(), so please add this modifier to the button, and for the content, we want to create and show and instance of SecondView:
 */

struct ContentView2: View {
    @State private var showingSheet = false
    
    var body: some View {
        Button("Show Sheet") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            // contents of the sheet
            SecondView()
        }
    }
}

/*
 If you run the program now you’ll see you can tap the button to have our second view slide upwards from the bottom, and you can then drag that down to dismiss it.

 When you create a view like this, you can pass in any parameters it needs to work. For example, we could require that SecondView be sent a name it can display, like this:
 */

struct SecondView2: View {
    let name: String
    
    var body: some View {
        Text("Hello, \(name)!")
    }
}

/*
 And now just using SecondView() in our sheet isn’t good enough – we need to pass in a name string to be shown. For example, we could pass in my Twitter username like this:
 */

struct ContentView3: View {
    @State private var showingSheet = false
    
    var body: some View {
        Button("Show Sheet") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            // contents of the sheet
            SecondView2(name: "@twostraws")
        }
    }
}

/*
 Now the sheet will show “Hello, @twostraws”.

 Swift is doing a ton of work on our behalf here: as soon as we said that SecondView has a name property, Swift ensured that our code wouldn’t even build until all instances of SecondView() became SecondView(name: "some name"), which eliminates a whole range of possible errors.

 Before we move on, there’s one more thing I want to demonstrate, which is how to make a view dismiss itself. Yes, you’ve seen that the user can just swipe downwards, but sometimes you will want to dismiss views programmatically – to make the view go away because a button was pressed, for example.

 To dismiss another view we need another property wrapper – and yes, I realize that so often the solution to a problem in SwiftUI is to use another property wrapper.

 Anyway, this new one is called @Environment, and it allows us to create properties that store values provided to us externally. Is the user in light mode or dark mode? Have they asked for smaller or larger fonts? What timezone are they on? All these and more are values that come from the environment, and in this instance we’re going to ask the environment to dismiss our view.

 Yes, we need to ask the environment to dismiss our view, because it might have been presented in any number of different ways. So, we’re effectively saying “hey, figure out how my view was presented, then dismiss it appropriately.”

 To try it out add this property to SecondView, which creates a property called dismiss based on a value from the environment:
 */

struct SecondView3: View {
    @Environment(\.dismiss) var dismiss
    
    let name: String
    
    var body: some View {
        /*
         Now replace the text view in SecondView with this button:
         */
        Button("Dismiss") {
            dismiss()
        }
    }
}

/*
 With that button in place, you should now find you can show and hide the sheet using button presses.
 */


struct ContentView4: View {
    @State private var showingSheet = false
    
    var body: some View {
        Button("Show Sheet") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            // contents of the sheet
            SecondView3(name: "@twostraws")
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
