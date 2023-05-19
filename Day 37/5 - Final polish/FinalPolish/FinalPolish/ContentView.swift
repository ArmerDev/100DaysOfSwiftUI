//
//  ContentView.swift
//  FinalPolish
//
//  Created by James Armer on 19/05/2023.
//

import SwiftUI

/*
 If you try using the app, you’ll soon see it has two problems:

 Adding an expense doesn’t dismiss AddView; it just stays there.
 When you add an expense, you can’t actually see any details about it.
 Before we wrap up this project, let’s fix those to make the whole thing feel a little more polished.

 First, dismissing AddView is done by calling dismiss() on the environment when the time is right. This is controlled by the view’s environment, and links to the isPresented parameter for our sheet – that Boolean gets set to true by us to show AddView, but will be flipped back to false by the environment when we call dismiss().

 Start by adding this property to AddView:

         @Environment(\.dismiss) var dismiss
 
 You’ll notice we don’t specify a type for that – Swift can figure it out thanks to the @Environment property wrapper.

 Next, we need to call dismiss() when we want the view to dismiss itself. This causes the showingAddExpense Boolean in ContentView to go back to false, and hides the AddView. We already have a Save button in AddView that creates a new expense item and appends it to our existing expenses, so add this on the line directly after:

        dismiss()
 
 That solves the first problem, which just leaves the second: we show the name of each expense item but nothing more. This is because the ForEach for our list is trivial:

         ForEach(expenses.items) { item in
             Text(item.name)
         }
 
 We’re going to replace that with a stack within another stack, to make sure all the information looks good on screen. The inner stack will be a VStack showing the expense name and type, then around that will be a HStack with the VStack on the left, then a spacer, then the expense amount. This kind of layout is common on iOS: title and subtitle on the left, and more information on the right.

 Replace the existing ForEach in ContentView with this:

         ForEach(expenses.items) { item in
             HStack {
                 VStack(alignment: .leading) {
                     Text(item.name)
                         .font(.headline)
                     Text(item.type)
                 }

                 Spacer()
                 Text(item.amount, format: .currency(code: "USD"))
             }
         }
 
 Now run the program one last time and try it out – we’re done!
 */

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

class Expenses: ObservableObject{
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            
                            Text(item.type)
                        }
                        
                        Spacer()
                        Text(item.amount, format: .currency(code: "USD"))
                    }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
