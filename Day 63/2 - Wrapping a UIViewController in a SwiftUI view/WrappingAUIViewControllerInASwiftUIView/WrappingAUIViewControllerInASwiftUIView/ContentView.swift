//
//  ContentView.swift
//  WrappingAUIViewControllerInASwiftUIView
//
//  Created by James Armer on 18/06/2023.
//

import SwiftUI

/*
 SwiftUI is a really fantastic framework for building apps, but right now it’s far from complete – there are many things it just can’t do, so you need to learn to talk to UIKit if you want to add more advanced functionality. Sometimes this will be to integrate existing code you wrote for UIKit (for example, if you work for a company with an existing UIKit app), but other times it will be because UIKit and Apple’s other frameworks provide us with useful code we want to show inside a SwiftUI layout.

 In this project we’re going to ask users to import a picture from their photo library. Apple’s APIs come with dedicated code for doing just this, but that hasn’t been ported to SwiftUI and so we need to write that bridge ourself. Instead, it’s built into a separate framework called PhotosUI, which was designed to work with UIKit and so requires us to look at the way UIKit works.

 Before we write the code, there are three things you need to know, all of which are a bit like UIKit 101 but if you’ve only used SwiftUI they will be new to you:

 UIKit has a class called UIView, which is the parent class of all views in the layouts. So, labels, buttons, text fields, sliders, and so on – those are all views.

 UIKit has a class called UIViewController, which is designed to hold all the code to bring views to life. Just like UIView, UIViewController has many subclasses that do different kinds of work.

 UIKit uses a design pattern called delegation to decide where work happens. So, when it came to deciding how to respond to a text field changing, we’d create a custom class with our functionality and make that the delegate of our text field.

 All this matters because asking the user to select a photo from their library uses a view controller called PHPickerViewController, and the delegate protocol PHPickerViewControllerDelegate. SwiftUI can’t use these two directly, so we need to wrap them.

 We’re going to start simple and work our way up. Wrapping a UIKit view controller requires us to create a struct that conforms to the UIViewControllerRepresentable protocol.

 So, press Cmd+N to make a new file, choose Swift File, and name it ImagePicker.swift. Add import PhotosUI and import SwiftUI to the top of the new file, then give it this code:

 struct ImagePicker: UIViewControllerRepresentable {

 }
 */

struct ContentView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            
            Button("Select Image") {
                showingImagePicker = true
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker()
        }
    }
}

/*
 Go ahead and run that, either in the simulator or on your real device. When you tap the button the default iOS image picker should slide up letting you browse through all your photos.

 However, nothing will happen when an image is selected, and the Cancel button won’t do anything either. You see, even though we’ve created and presented a valid PHPickerViewController, we haven’t actually told it how to respond to user interactions.

 To make that happens requires a wholly new concept: coordinators.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
