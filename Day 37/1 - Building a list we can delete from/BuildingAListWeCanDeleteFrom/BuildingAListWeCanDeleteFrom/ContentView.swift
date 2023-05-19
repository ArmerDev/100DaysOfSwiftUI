//
//  ContentView.swift
//  BuildingAListWeCanDeleteFrom
//
//  Created by James Armer on 19/05/2023.
//

import SwiftUI


/*
 In this project we want a list that can show some expenses, and previously we would have done this using an @State array of objects. Here, though, we’re going to take a different approach: we’re going to create an Expenses class that will be attached to our list using @StateObject.

 This might sound like we’re over-complicating things a little, but it actually makes things much easier because we can make the Expenses class load and save itself seamlessly – it will be almost invisible, as you’ll see.

 First, we need to decide what an expense is – what do we want it to store? In this instance it will be three things: the name of the item, whether it’s business or personal, and its cost as a Double.

 We’ll add more to this later, but for now we can represent all that using a single ExpenseItem struct. You can put this into a new Swift file called ExpenseItem.swift, but you don’t need to – you can just put this into ContentView.swift if you like, as long as you don’t put it inside the ContentView struct itself.

 Regardless of where you put it, this is the code to use:
 */

struct ExpenseItem {
    let name: String
    let type: String
    let amount: Double
}

/*
 Now that we have something that represents a single expense, the next step is to create something to store an array of those expense items inside a single object. This needs to conform to the ObservableObject protocol, and we’re also going to use @Published to make sure change announcements get sent whenever the items array gets modified.

 As with the ExpenseItem struct, this will start off simple and we’ll add to it later, so add this new class now:
 */

class Expenses: ObservableObject{
    @Published var items = [ExpenseItem]()
}

/*
 That finishes all the data required for our main view: we have a struct to represent a single item of expense, and a class to store an array of all those items.

 Let’s now put that into action with our SwiftUI view, so we can actually see our data on the screen. Most of our view will just be a List showing the items in our expenses, but because we want users to delete items they no longer want we can’t just use a simple List – we need to use a ForEach inside the list, so we get access to the onDelete() modifier.

 First, we need to add an @StateObject property in our view, that will create an instance of our Expenses class:
 */

struct ContentView: View {
    @StateObject var expenses = Expenses()
    
    /*
     Remember, using @StateObject here asks SwiftUI to watch the object for any change announcements, so any time one of our @Published properties changes the view will refresh its body. It’s only used when creating a class instance – all other times you ‘ll use @ObservedObject instead.

     Second, we can use that Expenses object with a NavigationView, a List, and a ForEach, to create our basic layout:
     */
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items, id: \.name) { item in
                    Text(item.name)
                }
            }
            .navigationTitle("iExpense")
        }
    }
}

/*
 That tells the ForEach to identify each expense item uniquely by its name, then prints the name out as the list row.

 We’re going to add two more things to our simple layout before we’re done: the ability to add new items for testing purposes, and the ability to delete items with a swipe.

 We’re going to let users add their own items soon, but it’s important to check that our list actually works well before we continue. So, we’re going to add a toolbar button that adds example ExpenseItem instances for us to work with – add this modifier to the List now:
 */

struct ContentView2: View {
    @StateObject var expenses = Expenses()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items, id: \.name) { item in
                    Text(item.name)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
                    expenses.items.append(expense)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

/*
 That brings our app to life: you can launch it now, then press the + button repeatedly to add lots of testing expenses.

 Now that we can add expenses, we can also add code to remove them. This means adding a method capable of deleting an IndexSet of list items, then passing that directly on to our expenses array. And to add that to SwiftUI, we add an onDelete() modifier to our ForEach, like this:
 */

struct ContentView3: View {
    @StateObject var expenses = Expenses()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items, id: \.name) { item in
                    Text(item.name)
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
                    expenses.items.append(expense)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

/*
 Go ahead and run the app now, press + a few times, then swipe to delete the rows.

 Now, remember: when we say id: \.name we’re saying we can identify each item uniquely by its name, which isn’t true here – we have the same name multiple times, and we can’t guarantee our expenses will be unique either.

 Often this will Just Work, but sometimes it will cause bizarre, broken animations in your project, so let’s look at a better solution next.
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
