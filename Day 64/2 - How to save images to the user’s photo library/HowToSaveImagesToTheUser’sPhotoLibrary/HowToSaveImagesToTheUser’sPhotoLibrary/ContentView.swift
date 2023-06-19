//
//  ContentView.swift
//  HowToSaveImagesToTheUser’sPhotoLibrary
//
//  Created by James Armer on 18/06/2023.
//

import SwiftUI

/*
 Before we’re done with the techniques for this project, there’s one last piece of UIKit joy we need to tackle: once we’ve processed the user’s image we’ll get a UIImage back, but we need a way to save that processed image to the user’s photo library. This uses a UIKit function called UIImageWriteToSavedPhotosAlbum(), which in its simplest form is trivial to use, but in order to make it work usefully you need to wade back into UIKit. At the very least it will make you really appreciate how much better SwiftUI is!

 Before we write any code, we need to do something new: we need to add a configuration option for our project. Every project we build has a whole bunch of these baked right in, describing which interface orientations we support, the version number of our app, and other fixed pieces of data. This isn’t code: these options must all be declared ahead of time, in a separate file, so the system can read them without having to run our app.

 These options all live in a particular place in Xcode, and it’s bizarrely hard to find unless you know what you’re doing:

 In the Project Navigator, select the top item in the tree. It will have your project name, Instafilter.
 You’ll see Instafilter listed under both PROJECT and TARGETS. Please select it under TARGETS.
 Now you’ll see a bunch of tabs across the top, including General, Signing & Capabilities, and more – select Info from there.
 This is where you can add a whole range of configuration options for your project, but right now there’s one specific option we need. You see, writing to the photo library is a protected operation, which means we can’t do it without explicit permission from the user. iOS will take care of asking for permission and checking the response, but we need to provide a short string explaining to users why we want to write images in the first place.

 To add your permission string, right-click on any of the existing options then choose Add Row. You’ll see a dropdown list of options to choose from – I’d like you to scroll down and select “Privacy - Photo Library Additions Usage Description”. For the value on its right, please enter the text “We want to save the filtered photo.”
 
 With that done, we can now use the UIImageWriteToSavedPhotosAlbum() method to write out a picture. We already have this loadImage() method from our previous work:

     func loadImage() {
     guard let inputImage = inputImage else { return }
     image = Image(uiImage: inputImage)
     }
 
 We could modify that so it immediately saves the image that got loaded, effectively creating a duplicate. Add this line to the end of the method:

    UIImageWriteToSavedPhotosAlbum(inputImage, nil, nil, nil)
 
 And that’s it – every time you import an image, our app will save it back to the photo library. The first time you try it, iOS will automatically prompt the user for permission to write the photo and show the string we added to the configuration options.
 */

struct ContentView: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
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
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in loadImage() }
    }
 
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        
        UIImageWriteToSavedPhotosAlbum(inputImage, nil, nil, nil)
    }
}


/*
 Now, you might look at that and think “that was easy!” And you’d be right. But the reason it’s easy is because we did the least possible work: we provided the image to save as the first parameter to UIImageWriteToSavedPhotosAlbum(), then provided nil as the other three.

 Those nil parameters matter, or at least the first two do: they tell Swift what method should be called when saving completes, which in turn will tell us whether the save operation succeeded or failed. If you don’t care about that then you’re done – passing nil for all three is fine. But remember: users can deny access to their photo library, so if you don’t catch the save error they’ll wonder why your app isn’t working properly.

 The reason it takes UIKit two parameters to know which function to call is because this code is old – way older than Swift, and in fact so old it even pre-dates Objective-C’s equivalent of closures. So instead, this uses a completely different way of referring to functions: in place of the first nil we should point to an object, and in place of the second nil we should point to the name of the method that should be called.

 If that sounds bad, I’m afraid you only know half the story. You see, both of those two parameters have their own complexities:

 - The object we provide must be a class, and it must inherit from NSObject. This means we can’t point to a SwiftUI view struct.
 - The method is provided as a method name, not an actual method. This method name was used by Objective-C to find the actual code at runtime, which could then be run. That method needs to have a specific signature (list of parameters) otherwise our code just won’t work.
 
 But wait: there’s more! For performance reasons, Swift prefers not to generate code in a way that Objective-C can read – that whole “look up methods at runtime” thing was really neat, but also really slow. And so, when it comes to writing the method name we need to do two things:

 - Mark the method using a special compiler directive called #selector, which asks Swift to make sure the method name exists where we say it does.
 
 - Add an attribute called @objc to the method, which tells Swift to generate code that can be read by Objective-C.
 
 You know, I wrote UIKit code for over a decade before I switched to SwiftUI, and already writing out all this explanation makes this old API seem like a crime against humanity. Sadly it is what it is, and we’re stuck with it.

 Before I show you the code, I want to mention the fourth parameter. So, the first one is the image to save, the second one is an object that should be notified about the result of the save, the third one is the method on the object that should be run, and then there’s the fourth one. We aren’t going to be using it here, but you need to be aware of what it does: we can provide any sort of data here, and it will be passed back to us when our completion method is called.

 This is what UIKit calls “context”, and it helps you identify one image save operation from another. You can provide literally anything you want here, so UIKit uses the most hands-off type you can imagine: a raw chunk of memory that Swift makes no guarantees about whatsoever. This has its own special type name in Swift: UnsafeRawPointer. Honestly, if it weren’t for the fact that we had to use it here I simply wouldn’t even tell you it existed, because it’s not really useful at this point in your app development career.

 Anyway, that’s more than enough talk. Before you decide to throw this project away and go straight to the next one, let’s get this over and done with.

 As I’ve said, to write an image to the photo library and read the response, we need some sort of class that inherits from NSObject. Inside there we need a method with a precise signature that’s marked with @objc, and we can then call that from UIImageWriteToSavedPhotosAlbum().

 Putting all that together, please create a new Swift file called ImageSaver.swift, change its Foundation import for SwiftUI, then update its code.
 
 - Go to file: ImageSaver.swift
 */

struct ContentView2: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            
            Button("Select Image") {
                showingImagePicker = true
            }
            
            Button("Save Image") {
                guard let inputImage = inputImage else { return }
                
                let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: inputImage)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in loadImage() }
    }
 
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}


/*
 If you run the code now, you should see the “Save finished!” message output as soon as you select an image, but you’ll also see the system prompt you for permission to write to the photo library.

 Yes, that is remarkably little code given how much explanation it needed, but on the bright side that completes the overview for this project so at long (long, long!) last we can get into the actual implementation.

 Please go ahead and put your project back to its default state so we have a clean slate to work from, but I’d like you to keep ImagePicker and ImageSaver – both of those will be used later in this project, and they are also useful in other projects you might create in the future.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
    }
}
