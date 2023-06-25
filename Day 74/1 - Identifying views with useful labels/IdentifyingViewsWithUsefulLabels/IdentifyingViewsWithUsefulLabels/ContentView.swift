//
//  ContentView.swift
//  IdentifyingViewsWithUsefulLabels
//
//  Created by James Armer on 25/06/2023.
//

import SwiftUI

/*
 In the files for this project I have placed four pictures downloaded from Unsplash. Unsplash filenames are made up of a picture ID and the photographer’s name, so if you drag them into your asset catalog you’ll see they have names such as "ales-krivec-15949" and so on. That in itself isn’t a problem, and in fact I think it can be a helpful way of remembering where assets came from. However, it does present a problem for screen readers.
 
 To get started with VoiceOver, we’re going to create a simple view that cycles randomly through the four pictures in our asset catalog. Modify the ContentView struct to this:
 */

struct ContentView: View {
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]
    
    @State private var selectedPicture = Int.random(in: 0...3)
    
    var body: some View {
        Image(pictures[selectedPicture])
            .resizable()
            .scaledToFit()
            .onTapGesture {
                selectedPicture = Int.random(in: 0...3)
            }
    }
}

/*
 There’s nothing complicated there, but it already helps to illustrate two serious problems.
 
 If you haven’t already enabled VoiceOver in the Settings app on your iOS device, please do so now: Settings > Accessibility > VoiceOver, then toggle it on. Alternatively, you can activate Siri at any time and ask to enable or disable VoiceOver.
 
 Important: Immediately below the VoiceOver toggle is instructions for how to use it. The regular taps and swipes you’re used to no longer function the same way, so read those instructions!
 
 Now launch our app on your device, and try tapping once on the picture to activate it. If you listen carefully to VoiceOver you should hear two problems:
 
 Reading out “Kevin Horstmann one four one seven zero five” is not only unhelpful for the user because it doesn’t describe the picture at all, but it’s actually confusing – the long string of numbers does more harm than good.
 After reading the above string, VoiceOver then says “image”. This is true, it is an image, but it’s also acting as a button because we added an onTapGesture() modifier.
 The first of those problems is a side effect of SwiftUI trying to give us sensible behavior out of the box: when given an image, it automatically uses the image’s filename as the text to read out.
 
 We can control what VoiceOver reads for a given view by attaching two modifiers: .accessibilityLabel() and .accessibilityHint(). They both take text containing anything we want, but they serve different purposes:
 
 The label is read immediately, and should be a short piece of text that gets right to the point. If this view deletes an item from the user’s data, it might say “Delete”.
 The hint is read after a short delay, and should provide more details on what the view is there for. It might say “Deletes an email from your inbox”, for example.
 The label is exactly what we need to solve the first of our problems, because it means we can leave the image name as it is while still having VoiceOver read out something that helps users.
 
 First, add this second array of image descriptions as a property for ContentView:
 
 let labels = [
 "Tulips",
 "Frozen tree buds",
 "Sunflowers",
 "Fireworks",
 ]
 
 And now attach this modifier to the image:
 
 .accessibilityLabel(labels[selectedPicture])
 This allows VoiceOver to read the correct label no matter what image is present. Of course, if your image wasn’t randomly changing you could just type your label directly into the modifier.
 
 The second problem is that the image is identified as an image. This is self-evidently true, but it’s also not helpful because we’ve attached a tap gesture to it so it’s effectively a button.
 
 We can fix this second problem using another modifier, .accessibilityAddTraits(). This lets us provide some extra behind the scenes information to VoiceOver that describes how the view works, and in our case we can tell it that our image is also a button by adding this modifier:
 
 .accessibilityAddTraits(.isButton)
 
 If you wanted, you could remove the image trait as well, because it isn’t really adding much:
 
 .accessibilityRemoveTraits(.isImage)
 
 With these changes in place our UI works much better: VoiceOver now reads a useful description of the image’s contents, and also makes users aware the image is also a button.
 */

struct ContentView2: View {
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]
    
    let labels = [
        "Tulips",
        "Frozen tree buds",
        "Sunflowers",
        "Fireworks"
    ]
    
    @State private var selectedPicture = Int.random(in: 0...3)
    
    var body: some View {
        Image(pictures[selectedPicture])
            .resizable()
            .scaledToFit()
            .onTapGesture {
                selectedPicture = Int.random(in: 0...3)
            }
            .accessibilityLabel(labels[selectedPicture])
            .accessibilityAddTraits(.isButton)
            .accessibilityRemoveTraits(.isImage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
        // Improved VoiceOver Support
        ContentView2()
            .previewDisplayName("ContentView 2")
    }
}
