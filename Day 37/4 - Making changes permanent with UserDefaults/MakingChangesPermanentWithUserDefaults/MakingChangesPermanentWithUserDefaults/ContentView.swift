//
//  ContentView.swift
//  MakingChangesPermanentWithUserDefaults
//
//  Created by James Armer on 19/05/2023.
//

import SwiftUI

/*
 At this point, our app’s user interface is functional: you’ve seen we can add and delete items, and now we have a sheet showing a user interface to create new expenses. However, the app is far from working: any data placed into AddView is completely ignored, and even if it weren’t ignored then it still wouldn’t be saved for future times the app is run.

 We’ll tackle those problems in order, starting with actually doing something with the data from AddView. We already have properties that store the values from our form, and previously we added a property to store an Expenses object passed in from the ContentView.

 We need to put those two things together: we need a button that, when tapped, creates an ExpenseItem out of our properties and adds it to the expenses items.

 Add this modifier below navigationTitle() in AddView:

     .toolbar {
         Button("Save") {
             let item = ExpenseItem(name: name, type: type, amount: amount)
             expenses.items.append(item)
         }
     }
 
 */

struct ExpenseItem: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
}

class Expenses: ObservableObject{
    @Published var items = [ExpenseItem]()
}

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    Text(item.name)
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

/*
 Although we have more work to do, I encourage you to run the app now because it’s actually coming together – you can now show the add view, enter some details, press “Save”, then swipe to dismiss, and you’ll see your new item in the list. That means our data synchronization is working perfectly: both the SwiftUI views are reading from the same list of expense items.

 Now try launching the app again, and you’ll immediately hit our second problem: any data you add isn’t stored, meaning that everything starts blank every time you relaunch the app.

 This is obviously a pretty terrible user experience, but thanks to the way we have Expense as a separate class it’s actually not that hard to fix.

 We’re going to leverage four important technologies to help us save and load data in a clean way:

 The Codable protocol, which will allow us to archive all the existing expense items ready to be stored.
 UserDefaults, which will let us save and load that archived data.
 A custom initializer for the Expenses class, so that when we make an instance of it we load any saved data from UserDefaults
 A didSet property observer on the items property of Expenses, so that whenever an item gets added or removed we’ll write out changes.
 Let’s tackle writing the data first. We already have this property in the Expenses class:

 @Published var items = [ExpenseItem]()
 That’s where we store all the expense item structs that have been created, and that’s also where we’re going to attach our property observer to write out changes as they happen.

 This takes four steps in total: we need to create an instance of JSONEncoder that will do the work of converting our data to JSON, we ask that to try encoding our items array, and then we can write that to UserDefaults using the key “Items”.

 Modify the items property to this:

 @Published var items = [ExpenseItem]() {
     didSet {
         if let encoded = try? JSONEncoder().encode(items) {
             UserDefaults.standard.set(encoded, forKey: "Items")
         }
     }
 }
 Tip: Using JSONEncoder().encode() means “create an encoder and use it to encode something,” all in one step, rather than creating the encoder first then using it later.
 
 -----
 
 Now, if you’re following along you’ll notice that code doesn’t actually compile. And if you’re following along closely you’ll have noticed that I said this process takes four steps while only listing three.

 The problem is that the encode() method can only archive objects that conform to the Codable protocol. Remember, conforming to Codable is what asks the compiler to generate code for us able to handle archiving and unarchiving objects, and if we don’t add a conformance for that then our code won’t build.

 Helpfully, we don’t need to do any work other than add Codable to ExpenseItem:
 
 ----
 
 Swift already includes Codable conformances for the UUID, String, and Int properties of ExpenseItem, and so it’s able to make ExpenseItem conform automatically as soon as we ask for it.

 However, you will see a warning that id will not be decoded because we made it a constant and assigned a default value. This is actually the behavior we want, but Swift is trying to be helpful because it’s possible you did plan to decode this value from JSON. To make the warning go away, make the property a variable.
 
 ----
 
 With that change, we’ve written all the code needed to make sure our items are saved when the user adds them. However, it’s not effective by itself: the data might be saved, but it isn’t loaded again when the app relaunches.

 To solve that – and also to make our code compile again – we need to implement a custom initializer. That will:

 Attempt to read the “Items” key from UserDefaults.
 Create an instance of JSONDecoder, which is the counterpart of JSONEncoder that lets us go from JSON data to Swift objects.
 Ask the decoder to convert the data we received from UserDefaults into an array of ExpenseItem objects.
 If that worked, assign the resulting array to items and exit.
 Otherwise, set items to be an empty array.
 Add this initializer to the Expenses class now:

         init() {
             if let savedItems = UserDefaults.standard.data(forKey: "Items") {
                 if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                     items = decodedItems
                     return
                 }
             }

             items = []
         }
 
 The two key parts of that code are the data(forKey: "Items") line, which attempts to read whatever is in “Items” as a Data object, and try? JSONDecoder().decode([ExpenseItem].self, from: savedItems), which does the actual job of unarchiving the Data object into an array of ExpenseItem objects.

 It’s common to do a bit of a double take when you first see [ExpenseItem].self – what does the .self mean? Well, if we had just used [ExpenseItem], Swift would want to know what we meant – are we trying to make a copy of the class? Were we planning to reference a static property or method? Did we perhaps mean to create an instance of the class? To avoid confusion – to say that we mean we’re referring to the type itself, known as the type object – we write .self after it.

 Now that we have both loading and saving in place, you should be able to use the app. It’s not finished quite yet, though – let’s add some final polish!
 */

struct ExpenseItem2: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

class Expenses2: ObservableObject{
    @Published var items = [ExpenseItem2]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem2].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView2: View {
    @StateObject var expenses = Expenses2()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    Text(item.name)
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView2(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
    }
}
