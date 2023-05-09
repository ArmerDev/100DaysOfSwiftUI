//
//  ContentView.swift
//  BuildingABasicLayout
//
//  Created by James Armer on 09/05/2023.
//

import SwiftUI

/*
 This app is going to allow user input with a date picker and two steppers, which combined will tell us when they want to wake up, how much sleep they usually like, and how much coffee they drink.

 So, please start by adding three properties that let us store the information for those controls:
 */

struct ContentView: View {
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    
    /*
     Inside our body we’re going to place three sets of components wrapped in a VStack and a NavigationView, so let’s start with the wake up time. Replace the default “Hello World” text view with this:
     */
    
    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                /*
                 We’ve asked for .hourAndMinute configuration because we care about the time someone wants to wake up and not the day, and with the labelsHidden() modifier we don’t get a second label for the picker – the one above is more than enough.

                 Next we’re going to add a stepper to let users choose roughly how much sleep they want. By giving this thing an in range of 4...12 and a step of 0.25 we can be sure they’ll enter sensible values, but we can combine that with the formatted() method so we see numbers like “8” and not “8.000000”.
                 */
                
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                /*
                 Finally we’ll add one last stepper and label to handle how much coffee they drink. This time we’ll use the range of 1 through 20 (because surely 20 coffees a day is enough for anyone?), but we’ll also display one of two labels inside the stepper to handle pluralization better. If the user has set a coffeeAmount of exactly 1 we’ll show “1 cup”, otherwise we’ll use that amount plus “cups”, all decided using the ternary conditional operator.
                 */
                
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                
                
                /*
                 The final thing we need is a button to let users calculate the best time they should go to sleep. We could do that with a simple button at the end of the VStack, but to spice up this project a little I want to try something new: we’re going to add a button directly to the navigation bar.

                 First we need a method for the button to call, so add an empty calculateBedtime() method below the body, then add the .toolbar modifier on the VStack:
                 */
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
        }
    }
    
    func calculateBedtime() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
