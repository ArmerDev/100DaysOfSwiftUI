//
//  ContentView.swift
//  UsingCoordinatorsToManageSwiftUIViewControllers
//
//  Created by James Armer on 18/06/2023.
//

import SwiftUI

/*
 Previously we looked at how we can use UIViewControllerRepresentable to wrap a UIKit view controller so that it can be used inside SwiftUI, in particular focusing on PHPickerViewController. However, we hit a problem: although we could show the image picker, we weren’t able to respond to the user selecting an image or pressing cancel.

 SwiftUI’s solution to this is called coordinators, which is a bit confusing for folks coming from a UIKit background because there we had a design pattern also called coordinators that performed an entirely different role. To be clear, SwiftUI’s coordinators are nothing like the coordinator pattern many developers used with UIKit, so if you’ve used that pattern previously please jettison it from your brain to avoid confusion!

 SwiftUI’s coordinators are designed to act as delegates for UIKit view controllers. Remember, “delegates” are objects that respond to events that occur elsewhere. For example, UIKit lets us attach a delegate object to its text field view, and that delegate will be notified when the user types anything, when they press return, and so on. This meant that UIKit developers could modify the way their text field behaved without having to create a custom text field type of their own.

 Using coordinators in SwiftUI requires you to learn a little about the way UIKit works, which is no surprise given that we’re literally integrating UIKit’s view controllers. So, to demonstrate this we’re going to upgrade our ImagePicker view so that it can report back when the user selects an image or presses Cancel.

 As a reminder, here’s the code we have right now:

 struct ImagePicker: UIViewControllerRepresentable {
     func makeUIViewController(context: Context) -> PHPickerViewController {
         var config = PHPickerConfiguration()
         config.filter = .images

         let picker = PHPickerViewController(configuration: config)
         return picker
     }

     func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

     }
 }
 We’re going to take it step by step, because there’s a lot to take in here – don’t feel bad if it takes you some time to understand, because coordinators really aren’t easy the first time you encounter them.
 
 
- Comments continue in ImagePicker...
 */

struct ContentView: View {
    @State private var image: Image?
    
    // To integrate our ImagePicker view into that we need to start by adding another @State image property that can be passed into the picker
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
            // We can now change our sheet() modifier to pass that property into our image picker, so it will be updated when the image is selected
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in loadImage() }
    }
    
    // Next, we need a method we can call when that property changes. Remember, we can’t use a plain property observer here because Swift will ignore changes to the binding, so instead we’ll write a method that checks whether inputImage has a value, and if it does uses it to assign a new Image view to the image property.
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    // And now we can use an onChange() modifier to call loadImage() whenever a new image is chosen – put this below the sheet() modifier
    
}


/*
 And we’re done! Go ahead and run the app and try it out – you should be able to tap the button, browse through your photo library, and select a picture. When that happens the photo picker should disappear, and your selected image will be shown below.

 I realize at this point you’re probably sick of UIKit and coordinators, but before we move on I want to sum up the complete process:

 - We created a SwiftUI view that conforms to UIViewControllerRepresentable.
 
 - We gave it a makeUIViewController() method that created some sort of UIViewController, which in our example was a PHPickerViewController.
 
 - We added a nested Coordinator class to act as a bridge between the UIKit view controller and our SwiftUI view.
 
 - We gave that coordinator a didFinishPicking method, which will be triggered by iOS when an image was selected.
 
 - Finally, we gave our ImagePicker an @Binding property so that it can send changes back to a parent view.
 
 For what it’s worth, after you’ve used coordinators once, the second and subsequent times are easier, but I wouldn’t blame you if you found the whole system quite baffling for now.

 Don’t worry too much – we’ll be coming back to this again soon, so you’ll have more than enough time to practice. It also means you shouldn’t delete your ImagePicker.swift file, because that’s another useful component you’ll use in this project and in others you make.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
