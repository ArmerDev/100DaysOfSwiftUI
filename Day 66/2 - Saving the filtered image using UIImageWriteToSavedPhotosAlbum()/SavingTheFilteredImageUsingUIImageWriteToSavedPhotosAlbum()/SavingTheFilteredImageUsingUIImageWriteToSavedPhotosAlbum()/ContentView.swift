//
//  ContentView.swift
//  SavingTheFilteredImageUsingUIImageWriteToSavedPhotosAlbum()
//
//  Created by James Armer on 20/06/2023.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

/*
 To complete this project we’re going to make that Save button do something useful: save the filtered photo to the user’s photo library, so they can edit it further, share it, and so on.

 As I explained previously, the UIImageWriteToSavedPhotosAlbum() function does everything we need, but it has the catch that it needs to be used with some code that really doesn’t fit well with SwiftUI: it needs to be a class that inherits from NSObject, have a callback method that is marked with @objc, then point to that method using the #selector compiler directive.

 Like I showed you in an earlier part of this tutorial, the best way to approach this is to isolate the whole image saving functionality in a separate, reusable class.
 
 We’re going to return back to that in a moment to make it more useful, but first we need to make sure we request photo saving permission from the user correctly: we need to add a permission request string to our project’s configuration options.

 If you deleted the one you added earlier, please re-add it now:

 Open your target settings
 Select the Info tab
 Right-click on an existing option
 Choose Add Row
 Select “Privacy - Photo Library Additions Usage Description” for the key name.
 Enter “We want to save the filtered photo.” as the value.
 With that in place, we can now think about how to save an image using the ImageSaver class. Right now we’re setting our image property like this:

 if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
     let uiImage = UIImage(cgImage: cgimg)
     image = Image(uiImage: uiImage)
 }
 You can actually go straight from a CGImage to a SwiftUI Image view, and previously I said we’re going via UIImage because the CGImage equivalent requires some extra parameters. That’s all true, but there’s an important second reason that now becomes important: we need a UIImage to send to our ImageSaver class, and this is the perfect place to create it.

 So, add a new property to ContentView that will store this intermediate UIImage:

 @State private var processedImage: UIImage?
 And now we can modify the applyProcessing() method so that our UIImage gets stashed away for later:

 if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
     let uiImage = UIImage(cgImage: cgimg)
     image = Image(uiImage: uiImage)
     processedImage = uiImage
 }
 
 And now filling in the save() method is almost trivial:

 func save() {
     guard let processedImage = processedImage else { return }

     let imageSaver = ImageSaver()
     imageSaver.writeToPhotoAlbum(image: processedImage)
 }
 
 Now, we could leave it there, but the whole reason we made ImageSaver into its own class was so that we could read whether the save was successful or not. Right now this gets reported back to us in a method in ImageSaver:

 @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
     // save complete
 }
 
 In order for that result to be useful we need to make it propagate upwards so that our ContentView can use it. However, I don’t want the horrors of @objc to escape our little class, so instead we’re going to isolate that mess where it is and instead report back success or failure using closures – a much friendlier solution for Swift developers.

 First add these two properties to the ImageSaver class, to represent closures handling success and failure:

 var successHandler: (() -> Void)?
 var errorHandler: ((Error) -> Void)?
 Second, fill in the didFinishSavingWithError method so that it checks whether an error was provided, and calls one of those two closures:

 if let error = error {
     errorHandler?(error)
 } else {
     successHandler?()
 }
 And now we can – if we want to – provide one or both of those closures when using the ImageSaver class, like this:

 let imageSaver = ImageSaver()

 imageSaver.successHandler = {
     print("Success!")
 }

 imageSaver.errorHandler = {
     print("Oops: \($0.localizedDescription)")
 }

 imageSaver.writeToPhotoAlbum(image: processedImage)
 Although the code is very different, the concept here is identical to what we did with ImagePicker: we wrapped up some UIKit functionality in such a way that we get all the behavior we want, just in a nicer, more SwiftUI-friendly way. Even better, this gives us another reusable piece of code that we can put into other projects in the future – we’re slowly building a library!

 That final step completes our app, so go ahead and run it again and try it from end to end – import a picture, apply a filter, then save it to your photo library. Well done!
 */

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var showingFilterSheet = false
    
    let context = CIContext()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)

                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)

                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showingImagePicker = true
                }

                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) { _ in
                            applyProcessing()
                        }
                }
                .padding(.vertical)

                HStack {
                    Button("Change Filter") {
                        showingFilterSheet = true
                    }

                    Spacer()

                    Button("Save", action: save)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Button("Crystalize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) {  }
                
            }
        }
    }
    
    func save() {
        guard let processedImage = processedImage else { return }
        
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print("Success!")
        }
        
        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
