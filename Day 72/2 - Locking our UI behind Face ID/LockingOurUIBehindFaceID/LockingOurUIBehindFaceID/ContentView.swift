//
//  ContentView.swift
//  LockingOurUIBehindFaceID
//
//  Created by James Armer on 24/06/2023.
//

import MapKit
import SwiftUI

/*
 To finish off our app, we’re going to make one last important change: we’re going to require the user to authenticate themselves using either Touch ID or Face ID in order to see all the places they have marked on the app. After all, this is their private data and we should be respectful of that, and of course it gives me a chance to let you use an important skill in a practical context!

 First we need some new state in our view model that tracks whether the app is unlocked or not. So, start by adding a new isUnlocked property to the Extension for ContentView:
 
    @Published var isUnlocked = false
 
 Second, we need to add the Face ID permission request key to our project configuration options, explaining to the user why we want to use Face ID. If you haven’t added this already, go to your target options now, select the Info tab, then right-click on any existing row and add the “Privacy - Face ID Usage Description” key there. You can enter what you like, but “Please authenticate yourself to unlock your places” seems like a good choice.

 Third, we need to add import LocalAuthentication to the top of your view model’s file, so we have access to Apple’s authentication framework.

 And now for the hard part. If you recall, the code for biometric authentication was a teensy bit unpleasant because of its Objective-C roots, so it’s always a good idea to get it far away from the neatness of SwiftUI. So, we’re going to write a dedicated authenticate() method that handles all the biometric work:

 - Creating an LAContext so we have something that can check and perform biometric authentication.
 - Ask it whether the current device is capable of biometric authentication.
 - If it is, start the request and provide a closure to run when it completes.
 - When the request finishes, check the result.
 - If it was successful, we’ll set isUnlocked to true so we can run our app as normal.
 
 Add this method to your view model now:

     func authenticate() {
         let context = LAContext()
         var error: NSError?

         if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
             let reason = "Please authenticate yourself to unlock your places."

             context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

                 if success {
                     self.isUnlocked = true
                 } else {
                     // error
                 }
             }
         } else {
             // no biometrics
         }
     }
 
 Remember, the string in our code is used for Touch ID, whereas the string in Info.plist is used for Face ID.

 And now we need to make an adjustment that is in reality very small, but can be hard to visualize if you’re reading this rather than watching the video. Everything inside the ZStack needs to be indented in by one level, and have this placed before it:

    if viewModel.isUnlocked {
 
 Just before the end of the ZStack add this:

     } else {
         // button here
     }
 
 
 So, it should look something like this:

     ZStack {
         if viewModel.isUnlocked {
             MapView…
             Circle…
             VStack…
         } else {
             // button here
         }
     }
     .sheet(item: $viewModel.selectedPlace) { place in
     
 So now we all we need to do is fill in the // button here comment with an actual button that triggers the authenticate() method. You can design whatever you want, but something like this ought to be enough:

 Button("Unlock Places") {
     viewModel.authenticate()
 }
 .padding()
 .background(.blue)
 .foregroundColor(.white)
 .clipShape(Capsule())
 You can now go ahead and run the app again, because our code is almost done. If this is the first time you’ve used Face ID in the simulator you’ll need to go to the Features menu and choose Face ID > Enrolled, but once you relaunch the app you can authenticate using Features > Face ID > Matching Face.

 However, when it runs you might notice a problem: the app will seem to work just fine, but Xcode is likely to show a warning message in its debug output. More importantly, it will also show a purple warning, which is Xcode’s issue of flagging up runtime issues - when our code does something it really ought not to.

 In this instance, it should point at this line in our view model:

 self.isUnlocked = true
 Next to that it should say “publishing changes from background threads is not allowed”, which translated means “you’re trying to change the UI but you’re not doing it from the main actor and that’s going to cause problems.”

 Now, This might be confusing given that earlier on we specifically added the @MainActor attribute to our whole class, which I said means all the code from the class will be run on the main actor and therefore be safe for UI updates. However, I added an important proviso there: “unless we specifically request otherwise.”

 In this instance we did request otherwise, but it might not be obvious: when we asked Face ID to do the work of authenticating the user, this happens outside of our program – it’s not us doing the actual face check, it’s Apple. When that process completes Apple will call our completion closure to say whether it succeeded or not, but that won’t be called on the main actor despite our @MainActor attribute.

 The solution here is to make sure we change the isUnlocked property on the main actor. This can be done by starting a new task, then calling await MainActor.run() inside there, like this:

     if success {
         Task {
             await MainActor.run {
                 self.isUnlocked = true
             }
         }
     } else {
         // error
     }
 
 That effectively means “start a new background task, then immediately use that background task to queue up some work on the main actor.”

 That works, but we can do better: we can tell Swift that our task’s code needs to run directly on the main actor, by giving the closure itself the @MainActor attribute. So, rather than bouncing to a background task then back to the main actor, the new task will immediately start running on the main actor:

     if success {
         Task { @MainActor in
             self.isUnlocked = true
         }
     } else {
         // error
     }
 
 And with that our code is done, and that’s another app complete – good job!
 */

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())
                            
                            Text(location.name)
                                .fixedSize()
                        }
                        .onTapGesture {
                            viewModel.selectedPlace = location
                        }
                    }
                }
                    .ignoresSafeArea()
                
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            viewModel.addLocation()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .padding()
                        .background(.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                    }
                }
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                EditView(location: place) { newLocation in
                    viewModel.update(location: newLocation)
                }
            }
        } else {
            Button("Unlock Places") {
                viewModel.authenticate()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
