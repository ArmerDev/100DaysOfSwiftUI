//
//  ImagePicker.swift
//  UsingCoordinatorsToManageSwiftUIViewControllers
//
//  Created by James Armer on 18/06/2023.
//

import PhotosUI
import SwiftUI

/*
 First, add this nested class inside the ImagePicker struct:

    class Coordinator {
    }
 
 Yes, it needs to be a class as you’ll see in a moment. It doesn’t need to be a nested class, although it’s a good idea because it neatly encapsulates the functionality – without a nested class it would be confusing if you had lots of view controllers and coordinators all mixed up.

 Even though that class is inside a UIViewControllerRepresentable struct, SwiftUI won’t automatically use it for the view’s coordinator. Instead, we need to add a new method called makeCoordinator(), which SwiftUI will automatically call if we implement it. All this needs to do is create and configure an instance of our Coordinator class, then send it back.

 Right now our Coordinator class doesn’t do anything special, so we can just send one back by adding this method to the ImagePicker struct:

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
 
 What we’ve done so far is create an ImagePicker struct that knows how to create a PHPickerViewController, and now we just told ImagePicker that it should have a coordinator to handle communication from that PHPickerViewController.

 The next step is to tell the PHPickerViewController that when something happens it should tell our coordinator. This takes just one line of code in makeUIViewController(), so add this directly before the return picker line:

 picker.delegate = context.coordinator
 That code won’t compile, but before we fix it I want to spend just a moment digging in to what just happened.

 We don’t call makeCoordinator() ourselves; SwiftUI calls it automatically when an instance of ImagePicker is created. Even better, SwiftUI automatically associated the coordinator it created with our ImagePicker struct, which means when it calls makeUIViewController() and updateUIViewController() it will automatically pass that coordinator object to us.

 So, the line of code we just wrote tells Swift to use the coordinator that just got made as the delegate for the PHPickerViewController. This means any time something happens inside the photo picker controller – i.e., when the user selects an image or presses Cancel – it will report that action to our coordinator.

 The reason our code doesn’t compile is that Swift is checking that our coordinator class is capable of acting as a delegate for PHPickerViewController, finding that it isn’t, and so is refusing to build our code any further. To fix this we need to modify our Coordinator class from this:

    class Coordinator {
 
 To this:

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
 
 That does three things:

 - It makes the class inherit from NSObject, which is the parent class for almost everything in UIKit. NSObject allows Objective-C to ask the object what functionality it supports at runtime, which means the photo picker can say things like “hey, the user selected an image, what do you want to do?”
 
 - It makes the class conform to the PHPickerViewControllerDelegate protocol, which is what adds functionality for detecting when the user selects an image. (NSObject lets Objective-C check for the functionality; this protocol is what actually provides it.)
 
 - It stops our code from compiling, because we’ve said that class conforms to PHPickerViewControllerDelegate but we haven’t implemented the one method required by that protocol.
 
 Still, at least now you can see why we needed to use a class for Coordinator: we need to inherit from NSObject so that Objective-C can query our coordinator to see what functionality it supports.

 At this point we have an ImagePicker struct that wraps a PHPickerViewController, and we’ve configured that image picker controller to talk to our Coordinator class when something interesting happens.

 The last step is to implement the one required method of the PHPickerViewControllerDelegate protocol, which will be called when the user has finished making their selection. That might mean we have an image, or that the user pressed cancel, so we need to respond appropriately.

 If we put UIKit to one side for a second and think in pure functionality, what we want is for our ImagePicker to report back that image to whatever used the picker in the first place. We’re presenting ImagePicker inside a sheet in our ContentView struct, so we want that to be given whatever image was selected, then dismiss the sheet.

 What we need here is SwiftUI’s @Binding property wrapper, which allows us to create a binding from ImagePicker up to whatever created it. This means we can set the binding value in our image picker and have it actually update a value being stored somewhere else – in ContentView, for example.

 So, add this property to ImagePicker:

 @Binding var image: UIImage?
 Now, we just added that property to ImagePicker, but we need to access it inside our Coordinator class because that’s the one that will be informed when an image was selected.

 Rather than just pass the data down one level, a better idea is to tell the coordinator what its parent is, so it can modify values there directly. That means adding an ImagePicker property and associated initializer to the Coordinator class, like this:

 var parent: ImagePicker

 init(_ parent: ImagePicker) {
     self.parent = parent
 }
 And now we can modify makeCoordinator() so that it passes the ImagePicker struct into the coordinator, like this:

 func makeCoordinator() -> Coordinator {
     Coordinator(self)
 }
 At this point your entire ImagePicker struct should look like this:

 struct ImagePicker: UIViewControllerRepresentable {
     class Coordinator: NSObject, PHPickerViewControllerDelegate {
         var parent: ImagePicker

         init(_ parent: ImagePicker) {
             self.parent = parent
         }
     }

     @Binding var image: UIImage?

     func makeUIViewController(context: Context) -> PHPickerViewController {
         var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
         config.filter = .images

         let picker = PHPickerViewController(configuration: config)
         picker.delegate = context.coordinator
         return picker
     }

     func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

     }

     func makeCoordinator() -> Coordinator {
         Coordinator(self)
     }
 }
 At long last we’re ready to actually read the response from our PHPickerViewController, which is done by implementing a method with a very specific name. Swift will look for this method in our Coordinator class, as it’s the delegate of the image picker, so make sure and add it there.

 The method name is long and needs to be exactly right in order for UIKit to find it, but helpfully Xcode can help us out with autocomplete. So, click on the red hexagon on the error line, then click “Fix” to add this method stub:

 func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
     code
 }
 That method receives two objects we care about: the picker view controller that the user was interacting with, plus an array of the users selections because it’s possible to let the user select multiple images at once.

 It’s our job to do three things:

 - Tell the picker to dismiss itself.
 
 - Exit if the user made no selection – if they tapped Cancel.
 
 - Otherwise, see if the user’s results includes a UIImage we can actually load, and if so place it into the parent.image property.
 
 So, replace the “code” placeholder with this:

 // Tell the picker to go away
 picker.dismiss(animated: true)

 // Exit if no selection was made
 guard let provider = results.first?.itemProvider else { return }

 // If this has an image we can use, use it
 if provider.canLoadObject(ofClass: UIImage.self) {
     provider.loadObject(ofClass: UIImage.self) { image, _ in
         self.parent.image = image as? UIImage
     }
 }
 Notice how we need the typecast for UIImage – that’s because the data we’re provided could in theory be anything. Yes, I know we specifically asked for photos, but PHPickerViewControllerDelegate calls this same method for any kind of media, which is why we need to be careful.

 At this point I bet you’re really missing the beautiful simplicity of SwiftUI, so you’ll be glad to know that we’re finally done with the ImagePicker struct – it does everything we need now.
 
 
 So, at last we can return to ContentView.swift
 
 */

struct ImagePicker: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // Tell the picker to dismiss
            picker.dismiss(animated: true)
            
            // Exit if no selection was made
            guard let provider = results.first?.itemProvider else { return }
            
            // If this has an image we can use, use it
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
    
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
