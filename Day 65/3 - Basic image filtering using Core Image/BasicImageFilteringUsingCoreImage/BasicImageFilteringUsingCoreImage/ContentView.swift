//
//  ContentView.swift
//  BasicImageFilteringUsingCoreImage
//
//  Created by James Armer on 19/06/2023.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

/*
 Now that our project has an image the user selected, the next step is to let the user apply varying Core Image filters to it. To start with we’re just going to work with a single filter, but shortly we’ll extend that using a confirmation dialog.

 If we want to use Core Image in our apps, we first need to add two imports to the top of ContentView.swift:

 import CoreImage
 import CoreImage.CIFilterBuiltins
 
 Next we need both a context and a filter. A Core Image context is an object that’s responsible for rendering a CIImage to a CGImage, or in more practical terms an object for converting the recipe for an image into an actual series of pixels we can work with.

 Contexts are expensive to create, so if you intend to render many images it’s a good idea to create a context once and keep it alive. As for the filter, we’ll be using CIFilter.sepiaTone() as our default but because we’ll make it flexible later we’ll make the filter use @State so it can be changed.

 So, add these two properties to ContentView:

 @State private var currentFilter = CIFilter.sepiaTone()
 let context = CIContext()
 With those two in place we can now write a method that will process whatever image was imported – that means it will set our sepia filter’s intensity based on the value in filterIntensity, read the output image back from the filter, ask our CIContext to render it, then place the result into our image property so it’s visible on-screen.

 func applyProcessing() {
     currentFilter.intensity = Float(filterIntensity)

     guard let outputImage = currentFilter.outputImage else { return }

     if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
         let uiImage = UIImage(cgImage: cgimg)
         image = Image(uiImage: uiImage)
     }
 }
 Tip: Sadly the Core Image behind the sepia tone filter wants Float rather than Double for its values. This makes Core Image feel even older, I know, but don’t worry – we’ll make it go away soon!

 The next job is to change the way loadImage() works. Right now that assigns to the image property, but we don’t want that any more. Instead, it should send whatever image was chosen into the sepia tone filter, then call applyProcessing() to make the magic happen.

 Core Image filters have a dedicated inputImage property that lets us send in a CIImage for the filter to work with, but often this is thoroughly broken and will cause your app to crash – it’s much safer to use the filter’s setValue() method with the key kCIInputImageKey.

 So, replace your existing loadImage() method with this:

 func loadImage() {
     guard let inputImage = inputImage else { return }

     let beginImage = CIImage(image: inputImage)
     currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
     applyProcessing()
 }
 If you run the code now you’ll see our basic app flow works great: we can select an image, then see it with a sepia effect applied. But that intensity slider we added doesn’t do anything, even though it’s bound to the same filterIntensity value that our filter is reading from.

 What’s happening here ought not to be too surprising: even though the slider is changing the value of filterIntensity, changing that property won’t automatically trigger our applyProcessing() method again. Instead, we need to do that by hand by telling SwiftUI to watch filterIntensity with onChange().

 Again, these onChange() modifiers can go anywhere in our SwiftUI view hierarchy, but in this situation I do something different: when one specific view is responsible for changing a value I usually add onChange() directly to that view so it’s clear to me later on that adjusting the view triggers a side effect. If multiple views adjust the same value, or if it’s not quite so specific what is changing the value, then I’d add the modifier at the end of the view.

 Anyway, here filterIntensity is being changed by the slider, so let’s add onChange() there:

 Slider(value: $filterIntensity)
     .onChange(of: filterIntensity) { _ in
         applyProcessing()
     }
 You can go ahead and run the app now, but be warned: even though Core Image is extremely fast on all iPhones, it’s usually extremely slow in the simulator. That means you can try it out to make sure everything works, but don’t be surprised if your code runs about as fast as an asthmatic ant carrying a heavy bag of shopping.
 */

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var currentFilter = CIFilter.sepiaTone()
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
                        // change filter
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
        }
    }
    
    func save() {
        
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        currentFilter.intensity = Float(filterIntensity)
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
