//
//  ContentView.swift
//  CreatingPickersInAForm
//
//  Created by James Armer on 30/04/2023.
//

import SwiftUI

/*
 
 SwiftUI’s pickers serve multiple purposes, and exactly how they look depends on which device you’re using and the context where the picker is used.

 In our project we have a form asking users to enter how much their check came to, and we want to add a picker to that so they can select how many people will share the check.

 Pickers, like text fields, need a two-way binding to a property so they can track their value. We already made an @State property for this purpose, called numberOfPeople, so our next job is to loop over all the numbers from 2 through to 99 and show them inside a picker.
 
 This can be seen in ContentView below:
 
 (Note - Updated the Textfields to match iOS 16 way of using Locale currency code)
 
 */

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                    
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                    // Note that the above modifier is only available in iOS 16 and above, and allows the picker selection to be displayed on its own screen.
                }
                
                Section {
                    Text(checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
