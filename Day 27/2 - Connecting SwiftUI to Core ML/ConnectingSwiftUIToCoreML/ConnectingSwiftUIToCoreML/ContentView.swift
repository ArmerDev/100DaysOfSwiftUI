//
//  ContentView.swift
//  ConnectingSwiftUIToCoreML
//
//  Created by James Armer on 09/05/2023.
//

import CoreML
import SwiftUI

/*
 In the same way that SwiftUI makes user interface development easy, Core ML makes machine learning easy. How easy? Well, once you have a trained model you can get predictions in just two lines of code – you just need to send in the values that should be used as input, then read what comes back.

 In our case, we already made a Core ML model using Xcode’s Create ML app, so we’re going to use that. You should have saved it on your desktop, so please now drag it into the project navigator in Xcode. When Xcode prompts you to “Copy items if needed”, please make sure that box is checked.

 When you add an .mlmodel file to Xcode, it will automatically create a Swift class of the same name. You can’t see the class, and don’t need to – it’s generated automatically as part of the build process. However, it does mean that if your model file is named oddly then the auto-generated class name will also be named oddly.

 No matter what name your model file has, please rename it to be “SleepCalculator.mlmodel”, thus making the auto-generated class be called SleepCalculator.

 How can we be sure that’s the class name? Well, just select the model file itself and Xcode will show you more information. You’ll see it knows our author, the name of the Swift class that gets made, plus a list of inputs and their types, and an output plus type too – these were encoded in the model file, which is why it was (comparatively!) so big.

 We’re going to start filling in calculateBedtime() in just a moment, but before that can start we need to add an import for CoreML because we’re using functionality outside of SwiftUI.

 So, scroll to the top of ContentView.swift and add import CoreML before the line import SwiftUI:
 
 (Tip: You don’t strictly need to add CoreML before SwiftUI, but keeping your imports in alphabetical order makes them easier to check later on.)
 */



struct ContentView: View {
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
              
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
              
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
        }
    }
    
    
    /*
     Okay, now we can turn to calculateBedtime(). First, we need to create an instance of the SleepCalculator class, like this:
     */
    
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            // More code to come here
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep
            
        } catch {
            // Something went wrong!
        }
        
        /*
         That model instance is the thing that reads in all our data, and will output a prediction. The configuration is there in case you need to enable a handful of what are fairly obscure options – perhaps folks working in machine learning full time need these, but honestly I’d guess only 1 in 1000 folks actually use these.

         I do want you to focus on the do/catch blocks, because using Core ML can throw errors in two places: loading the model as seen above, but also when we ask for predictions. Honestly, I can’t think I’ve ever had a prediction fail in my life, but there’s no harm being safe!

         Anyway, we trained our model with a CSV file containing the following fields:

         “wake”: when the user wants to wake up. This is expressed as the number of seconds from midnight, so 8am would be 8 hours multiplied by 60 multiplied by 60, giving 28800.
         “estimatedSleep”: roughly how much sleep the user wants to have, stored as values from 4 through 12 in quarter increments.
         “coffee”: roughly how many cups of coffee the user drinks per day.
         So, in order to get a prediction out of our model, we need to fill in those values.

         We already have two of them, because our sleepAmount and coffeeAmount properties are mostly good enough – we just need to convert coffeeAmount from an integer to a Double so that Swift is happy.

         But figuring out the wake time requires more thinking, because our wakeUp property is a Date not a Double representing the number of seconds. Helpfully, this is where Swift’s DateComponents type comes in: it stores all the parts required to represent a date as individual values, meaning that we can read the hour and minute components and ignore the rest. All we then need to do is multiply the minute by 60 (to get seconds rather than minutes), and the hour by 60 and 60 (to get seconds rather than hours).

         We can get a DateComponents instance from a Date with a very specific method call: Calendar.current.dateComponents(). We can then request the hour and minute components, and pass in our wake up date. The DateComponents instance that comes back has properties for all its components – year, month, day, timezone, etc – but most of them won’t be set. The ones we asked for – hour and minute – will be set, but will be optional, so we need to unwrap them carefully.

         So, put this in place of the // more code here comment in calculateBedtime():
         
         let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
         let hour = (components.hour ?? 0) * 60 * 60
         let minute = (components.minute ?? 0) * 60
         
         
         That code uses 0 if either the hour or minute can’t be read, but realistically that’s never going to happen so it will result in hour and minute being set to those values in seconds.

         The next step is to feed our values into Core ML and see what comes out. This is done using the prediction() method of our model, which wants the wake time, estimated sleep, and coffee amount values required to make a prediction, all provided as Double values. We just calculated our hour and minute as seconds, so we’ll add those together before sending them in.

         Please add this just below the previous code:

         let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

         // more code here
         With that in place, prediction now contains how much sleep they actually need. This almost certainly wasn’t part of the training data our model saw, but was instead computed dynamically by the Core ML algorithm.

         However, it’s not a helpful value for users – it will be some number in seconds. What we want is to convert that into the time they should go to bed, which means we need to subtract that value in seconds from the time they need to wake up.

         Thanks to Apple’s powerful APIs, that’s just one line of code – you can subtract a value in seconds directly from a Date, and you’ll get back a new Date! So, add this line of code after the prediction:

         let sleepTime = wakeUp - prediction.actualSleep
         And now we know exactly when they should go to sleep.
         */
    }
}


/*
 Our final challenge, for now at least, is to show that to the user. We’ll be doing this with an alert, because you’ve already learned how to do that and could use the practice.

 So, start by adding three properties that determine the title and message of the alert, and whether or not it’s showing:
 */


struct ContentView2: View {
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    /*
     We can immediately use those values in calculateBedtime(). If our calculation goes wrong – if reading a prediction throws an error – we can replace the // something went wrong comment with some code that sets up a useful error message:
     */
    
    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
        }
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            // More code to come here
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
            
            /*
             And regardless of whether or not the prediction worked, we should show the alert. It might contain the results of their prediction or it might contain the error message, but it’s still useful. So, at the end of calculateBedtime(), after the catch block, show the alert:
             */
        }
        
        showingAlert = true
    }
}

/*
 If the prediction worked we create a constant called sleepTime that contains the time they need to go to bed. But this is a Date rather than a neatly formatted string, so we’ll pass it through the formatted() method to make sure it’s human-readable, then assign it to alertMessage.

 So, put these final lines of code into calculateBedtime(), directly after where we set the sleepTime constant:

 alertTitle = "Your ideal bedtime is…"
 alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
 To wrap up this stage of the app, we just need to add an alert() modifier that shows alertTitle and alertMessage when showingAlert becomes true.

 Please add this modifier to our VStack:

 .alert(alertTitle, isPresented: $showingAlert) {
     Button("OK") { }
 } message: {
     Text(alertMessage)
 }
 Now go ahead and run the app – it works! It doesn’t look great, but it works.
 */

struct ContentView3: View {
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            // More code to come here
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is…"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."

        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
        ContentView3()
            .previewDisplayName("ContentView 3")
    }
}
