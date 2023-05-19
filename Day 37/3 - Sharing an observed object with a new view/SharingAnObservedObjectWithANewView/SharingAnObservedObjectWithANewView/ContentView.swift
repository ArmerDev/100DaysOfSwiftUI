//
//  ContentView.swift
//  SharingAnObservedObjectWithANewView
//
//  Created by James Armer on 19/05/2023.
//

import SwiftUI

/*
 Classes that conform to ObservableObject can be used in more than one SwiftUI view, and all of those views will be updated when the published properties of the class change.

 In this app, we’re going to design a view specially for adding new expense items. When the user is ready, we’ll add that to our Expenses class, which will automatically cause the original view to refresh its data so the expense item can be shown.

 To make a new SwiftUI view you can either press Cmd+N or go to the File menu and choose New > File. Either way, you should select “SwiftUI View” under the User Interface category, then name the file AddView.swift. Xcode will ask you where to save the file, so make sure you see a folder icon next to “iExpense”, then click Create to have Xcode show you the new view, ready to edit.

 As with our other views, our first pass at AddView will be simple and we’ll add to it. That means we’re going to add text fields for the expense name and amount, plus a picker for the type, all wrapped up in a form and a navigation view.

 This should all be old news to you by now, so let’s get into the code:
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
                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
                    expenses.items.append(expense)
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
 Here, though, we need something more. You see, we already have the expenses property in our content view, and inside AddView we’re going to be writing code to add expense items. We don’t want to create a second instance of the Expenses class in AddView, but instead want it to share the existing instance from ContentView.

 So, what we’re going to do is add a property to AddView to store an Expenses object. It won’t create the object there, which means we need to use @ObservedObject rather than @StateObject.

 Please add this property to AddView:
    @ObservedObject var expenses: Expenses
 
 After that we can pass our existing Expenses object from one view to another – they will both share the same object, and will both monitor it for changes. Modify your sheet() modifier above to include the parameter argument.
 */


/*
 We’re not quite done with this step yet, for two reasons: our code won’t compile, and even if it did compile it wouldn’t work because our button doesn’t trigger the sheet.

 The compilation failure happens because when we made the new SwiftUI view, Xcode also added a preview provider so we can look at the design of the view while we were coding. If you find that down at the bottom of AddView.swift, you’ll see that it tries to create an AddView instance without providing a value for the expenses property.

 That isn’t allowed any more, but we can just pass in a dummy value instead. So head over to AddView and add that code.
 */


/*
 The second problem is that we don’t actually have any code to show the sheet, because right now the + button in ContentView adds test expenses. Fortunately, the fix is trivial – just replace the existing action with code to toggle our showingAddExpense Boolean
 */

struct ContentView2: View {
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
 If you run the app now the whole sheet should be working as intended – you start with ContentView, tap the + button to bring up an AddView where you can type in the various fields, then can swipe to dismiss.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
    }
}
