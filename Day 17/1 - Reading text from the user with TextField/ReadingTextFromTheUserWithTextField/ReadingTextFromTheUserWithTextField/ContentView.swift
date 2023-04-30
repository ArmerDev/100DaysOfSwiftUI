//
//  ContentView.swift
//  ReadingTextFromTheUserWithTextField
//
//  Created by James Armer on 30/04/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var body: some View {
        Form {
            Section {
                // TextField("Amount", text: $checkAmount)
                
                /*
                 
                 The above code will not work because it expects a string for the text argument, but we have passed a double.
                 
                 We could change checkAmount to a string, but the user could enter anything, and we would have to carefully convert that to a number we can work with.
                 
                 Fortunately, there is a better way which lets us pass in a value instead, and also allows us to format the value as a currency.
                 
                 */
                
                TextField("Amount", value: $checkAmount, format: .currency(code: "USD"))

            }
        }
    }
}

/*
 
 This is better, but the above code has one problem. It's hard coded to display USD, but not everyone uses USD.
 
 A better approach would be to ask the system what the currency code of the current user is, if there is one, and to provide a sensible default using nil coalescing when there isn't.
 
 This can be seen in ContentView2 below.
 
 */

struct ContentView2: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var body: some View {
        Form {
            Section {
                TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                
                /*
                 
                 Locale is a massive struct built into iOS that is responsible for storing all the user’s region settings – what calendar they use, how they separate thousands digits in numbers, whether they use the metric system, and more. In our case, we’re asking whether the user has a preferred currency code, and if they don’t we’ll fall back to “USD” so at least we have something.
                 
                 */
            }
        }
    }
}

/*
 
 One of the great things about the @State property wrapper is that it automatically watches for changes, and when something happens it will automatically re-invoke the body property. That’s a fancy way of saying it will reload your UI to reflect the changed state, and it’s a fundamental feature of the way SwiftUI works.
 
 To demonstrate this, we could add a second section with a text view showing the value of checkAmount, like this:
 
 */

struct ContentView3: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var body: some View {
        Form {
            Section {
                TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
            }
            
            Section {
                Text(checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
            }
        }
    }
}

/*
 
 Tap on the check amount text field, then enter an example amount such as 50. What you’ll see is that as you type the text view in the second section automatically and immediately reflects your actions.

 This synchronisation happens because:

 - Our text field has a two-way binding to the checkAmount property.
 - The checkAmount property is marked with @State, which automatically watches for changes in the value.
 - When an @State property changes SwiftUI will re-invoke the body property (i.e., reload our UI)
 - Therefore the text view will get the updated value of checkAmount.
 
 */



/*
 
 There is one last improvement to make before moving on to the next section, and that is the keyboard. When the user taps on the amount, they are presented with the regular alphabetical keyboard.
 
 Fortunately, text fields have a modifier that lets us force a different kind of keyboard: keyboardType(). We can give this a parameter specifying the kind of keyboard we want, and in this instance either .numberPad or .decimalPad are good choices. Both of those keyboards will show the digits 0 through 9 for users to tap on, but .decimalPad also shows a decimal point so users can enter check amount like $32.50 rather than just whole numbers.
 
 You can see this keyboard modifier implemented in ContentView4 below.
 
 */

struct ContentView4: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var body: some View {
        Form {
            Section {
                TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            
            Section {
                Text(checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
            }
        }
    }
}

/*
 
 Tip: The .numberPad and .decimalPad keyboard types tell SwiftUI to show the digits 0 through 9 and optionally also the decimal point, but that doesn’t stop users from entering other values. For example, if they have a hardware keyboard they can type what they like, and if they copy some text from elsewhere they’ll be able to paste that into the text field no matter what is inside that text. That’s OK, though – the text field will automatically filter out bad values when they hit Return.
 
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDisplayName("ContentView")
        ContentView2()
            .previewDisplayName("ContentView2")
        ContentView3()
            .previewDisplayName("ContentView3")
        ContentView4()
            .previewDisplayName("ContentView4")
        
    }
}
