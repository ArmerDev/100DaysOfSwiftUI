//
//  AddView.swift
//  SharingAnObservedObjectWithANewView
//
//  Created by James Armer on 19/05/2023.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var expenses: Expenses
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
        }
    }
}

/*
 Yes, that always uses US dollars for the currency type – you’ll need to make that smarter in the challenges for this project.

 We’ll come back to the rest of that code in a moment, but first let’s add some code to ContentView so we can show AddView when the + button is tapped.

 In order to present AddView as a new view, we need to make three changes to ContentView. First, we need some state to track whether or not AddView is being shown,
 
 Next, we need to tell SwiftUI to use that Boolean as a condition for showing a sheet – a pop-up window. This is done by attaching the sheet() modifier somewhere to our view hierarchy. You can use the List if you want, but the NavigationView works just as well. Either way, add the sheet modifier to one of the views in ContentView
 
 The third step is to put something inside the sheet. Often that will just be an instance of the view type you want to show, so we will put AddView:
 */

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
