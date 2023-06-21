//
//  ContentView.swift
//  UsingTouchIDAndFaceIDWithSwiftUI
//
//  Created by James Armer on 21/06/2023.
//

import LocalAuthentication
import SwiftUI

/*
 The vast majority of Apple’s devices come with biometric authentication as standard, which means they use fingerprint and facial recognition to unlock. This functionality is available to us too, which means we can make sure that sensitive data can only be read when unlocked by a valid user.
 
 This is another Objective-C API, but it’s only a little bit unpleasant to use with SwiftUI, which is better than we’ve had with some other frameworks we’ve looked at so far.
 
 Before we write any code, you need to add a new key to your project options, explaining to the user why you want access to Face ID. For reasons known only to Apple, we pass the Touch ID request reason in code, and the Face ID request reason in project options.
 
 So, select your current target, go to the Info tab, right-click on an existing key, then choose Add Row. Scroll through the list of keys until you find “Privacy - Face ID Usage Description” and give it the value “We need to unlock your data.”
 
 Then at the top of ContentView.swift, add Import LocalAuthentication:
 
 
 And with that, we’re all set to write some biometrics code.
 
 I mentioned earlier this was “only a little bit unpleasant”, and here’s where it comes in: Swift developers use the Error protocol for representing errors that occur at runtime, but Objective-C uses a special class called NSError. We need to be able to pass that into the function and have it changed inside the function rather than returning a new value – although this was the standard in Objective-C, it’s quite an alien way of working in Swift so we need to mark this behavior specially by using &.
 
 We’re going to write an authenticate() method that isolates all the biometric functionality in a single place. To make that happen requires four steps:
 
 Create instance of LAContext, which allows us to query biometric status and perform the authentication check.
 Ask that context whether it’s capable of performing biometric authentication – this is important because iPod touch has neither Touch ID nor Face ID.
 If biometrics are possible, then we kick off the actual request for authentication, passing in a closure to run when authentication completes.
 When the user has either been authenticated or not, our completion closure will be called and tell us whether it worked or not, and if not what the error was.
 
 Let's add an authenticate method to ContentView:
 */

struct ContentView: View {
    @State private var isUnlocked = false
    
    var body: some View {
        VStack {
            if isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    isUnlocked = true
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
}

/*
 That method by itself won’t do anything, because it’s not connected to SwiftUI at all. To fix that we need to add some state we can adjust when authentication is successful, and also an onAppear() modifier to trigger authentication.

 So, first add this property to ContentView:

 @State private var isUnlocked = false
 
 That simple Boolean will store whether the app is showing its protected data or not, so we’ll flip that to true when authentication succeeds. Replace the // authenticated successfully comment with this:

 isUnlocked = true
 Finally, we can show the current authentication state and begin the authentication process inside the body property, like this:

 VStack {
     if isUnlocked {
         Text("Unlocked")
     } else {
         Text("Locked")
     }
 }
 .onAppear(perform: authenticate)
 If you run the app there’s a good chance you just see “Locked” and nothing else. This is because the simulator isn’t opted in to biometrics by default, and we didn’t provide any error messages, so it fails silently.

 To take Face ID for a test drive, go to the Features menu and choose Face ID > Enrolled, then launch the app again. This time you should see the Face ID prompt appear, and you can trigger successful or failed authentication by going back to the Features menu and choosing Face ID > Matching Face or Non-matching Face.

 All being well you should see the Face ID prompt go away, and underneath it will be the “Unlocked” text view – our app has detected the authentication, and is now open to use.

 Important: When working with biometric authentication, you should always look for a backup plan that lets users authenticate without biometrics. Think about folks who might be wearing a face mask, or perhaps are wearing gloves right now – if you try to force them to use biometrics all the time you’ll just have angry users. So, consider adding a screen that prompts for a passcode, then provide that as a fallback if biometrics fail.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
