//
//  ContentView.swift
//  StoringUserSettingsWithUserDefaults
//
//  Created by James Armer on 18/05/2023.
//

import SwiftUI

/*
 Most users pretty much expect apps to store their data so they can create more customized experiences, and as such it’s no surprise that iOS gives us several ways to read and write user data.

 One common way to store a small amount of data is called UserDefaults, and it’s great for simple user preferences. There is no specific number attached to “a small amount”, but everything you store in UserDefaults will automatically be loaded when your app launches – if you store a lot in there your app launch will slow down. To give you at least an idea, you should aim to store no more than 512KB in there.

 Tip: If you’re thinking “512KB? How much is that?” then let me give you a rough estimate: it’s about as much text as all the chapters you’ve read in this book so far.

 UserDefaults is perfect for storing things like when the user last launched the app, which news story they last read, or other passively collected information. Even better, SwiftUI can often wrap up UserDefaults inside a nice and simple property wrapper called @AppStorage – it only supports a subset of functionality right now, but it can be really helpful.

 Enough chat – let’s look at some code. Here’s a view with a button that shows a tap count, and increments that count every time the button is tapped:
 */

struct ContentView: View {
    @State private var tapCount = 0
    
    var body: some View {
        Button("Tap count: \(tapCount)") {
            tapCount += 1
        }
    }
}

/*
 As this is clearly A Very Important App, we want to save the number of taps that the user made, so when they come back to the app in the future they can pick up where they left off.

 To make that happen, we need to write to UserDefaults inside our button’s action closure. So, add this after the tapCount += 1 line:
 */

struct ContentView2: View {
    @State private var tapCount = 0
    
    var body: some View {
        Button("Tap count: \(tapCount)") {
            tapCount += 1
            UserDefaults.standard.set(self.tapCount, forKey: "Tap")
        }
    }
}

/*
 In just that single line of code you can see three things in action:

 We need to use UserDefaults.standard. This is the built-in instance of UserDefaults that is attached to our app, but in more advanced apps you can create your own instances. For example, if you want to share defaults across several app extensions you might create your own UserDefaults instance.
 There is a single set() method that accepts any kind of data – integers, Booleans, strings, and more.
 We attach a string name to this data, in our case it’s the key “Tap”. This key is case-sensitive, just like regular Swift strings, and it’s important – we need to use the same key to read the data back out of UserDefaults.
 Speaking of reading the data back, rather than start with tapCount set to 0 we should instead make it read the value back from UserDefaults like this:
 */

struct ContentView3: View {
    @State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
    
    var body: some View {
        Button("Tap count: \(tapCount)") {
            tapCount += 1
            UserDefaults.standard.set(self.tapCount, forKey: "Tap")
        }
    }
}

/*
 Notice how that uses exactly the same key name, which ensures it reads the same integer value.

 Go ahead and give the app a try and see what you think – you ought to be able tap the button a few times, go back to Xcode, run the app again, and see the number exactly where you left it.

 There are two things you can’t see in that code, but both matter. First, what happens if we don’t have the “Tap” key set? This will be the case the very first time the app is run, but as you just saw it works fine – if the key can’t be found it just sends back 0.

 Sometimes having a default value like 0 is helpful, but other times it can be confusing. With Booleans, for example, you get back false if boolean(forKey:) can’t find the key you asked for, but is that false a value you set yourself, or does it mean there was no value at all?

 Second, it takes iOS a little time to write your data to permanent storage – to actually save that change to the device. They don’t write updates immediately because you might make several back to back, so instead they wait some time then write out all the changes at once. How much time is another number we don’t know, but a couple of seconds ought to do it.

 As a result of this, if you tap the button then quickly relaunch the app from Xcode, you’ll find your most recent tap count wasn’t saved. There used to be a way of forcing updates to be written immediately, but at this point it’s worthless – even if the user immediately started the process of terminating your app after making a choice, your defaults data would be written immediately so nothing will be lost.

 Now, I mentioned that SwiftUI provides an @AppStorage property wrapper around UserDefaults, and in simple situations like this one it’s really helpful. What it does is let us effectively ignore UserDefaults entirely, and just use @AppStorage rather than @State, like this:
 */

struct ContentView4: View {
    @AppStorage("tapCount") private var tapCount = 0

    var body: some View {
        Button("Tap count: \(tapCount)") {
            tapCount += 1
        }
    }
}

/*
 Again, there are three things I want to point out in there:

1 - Our access to the UserDefaults system is through the @AppStorage property wrapper. This works like @State: when the value changes, it will reinvoked the body property so our UI reflects the new data.
2 - We attach a string name, which is the UserDefaults key where we want to store the data. I’ve used “tapCount”, but it can be anything at all – it doesn’t need to match the property name.
3 - The rest of the property is declared as normal, including providing a default value of 0. That will be used if there is no existing value saved inside UserDefaults.
 
 Clearly using @AppStorage is easier than UserDefaults: it’s one line of code rather than two, and it also means we don’t have to repeat the key name each time. However, right now at least @AppStorage doesn’t make it easy to handle storing complex objects such as Swift structs – perhaps because Apple wants us to remember that storing lots of data in there is a bad idea!
 */

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
