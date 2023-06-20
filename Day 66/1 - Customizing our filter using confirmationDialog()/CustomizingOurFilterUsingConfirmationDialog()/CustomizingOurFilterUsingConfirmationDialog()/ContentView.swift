//
//  ContentView.swift
//  CustomizingOurFilterUsingConfirmationDialog()
//
//  Created by James Armer on 20/06/2023.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

/*
 So far we’ve brought together SwiftUI, PHPickerViewController, and Core Image, but the app still isn’t terribly useful – after all, the sepia tone effect isn’t that interesting.

 To make the whole app better, we’re going to let users customize the filter they want to apply, and we’ll accomplish that using a confirmation dialog. On iPhone this is a list of buttons that slides up from the bottom of the screen, and you can add as many as you want – it can even scroll if you really need it to.

 First we need a property that will store whether the confirmation dialog should be showing or not.
 
 Then we can add our buttons using the confirmationDialog() modifier. This works identically to alert(): we provide a title and condition to monitor, and as soon as the condition becomes true the confirmation dialog will be shown.

 Start by adding this modifier below the sheet():

 .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
     // dialog here
 }
 Now replace the // change filter button action with this:

 showingFilterSheet = true
 In terms of what to show in the confirmation dialog, we can create an array of buttons to show and an optional message. These buttons work just like with alert(): we provide a text title and an action to run when it’s selected.

 For the confirmation dialog in this app, we want users to select from a range of different Core Image filters, and when they choose one it should be activated and immediately applied. To make this work we’re going to write a method that modifies currentFilter to whatever new filter they chose, then calls loadImage() straight away.

 There is a wrinkle in our plan, and it’s a result of the way Apple wrapped the Core Image APIs to make them more Swift-friendly. You see, the underlying Core Image API is entirely stringly typed, so rather than invent all new classes for us to use Apple instead created a series of protocols.

 When we assign CIFilter.sepiaTone() to a property, we get an object of the class CIFilter that happens to conform to a protocol called CISepiaTone. That protocol then exposes the intensity parameter we’ve been using, but internally it will just map it to a call to setValue(_:forKey:).

 This flexibility actually works in our favor because it means we can write code that works across all filters, as long as we’re careful not to send in an invalid value.

 So, let’s start solving the problem. Please change your currentFilter property to this:

 @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
 So, again, CIFilter.sepiaTone() returns a CIFilter object that conforms to the CISepiaTone protocol. Adding that explicit type annotation means we’re throwing away some data: we’re saying that the filter must be a CIFilter but doesn’t have to conform to CISepiaTone any more.

 As a result of this change we lose access to the intensity property, which means this code won’t work any more:

 currentFilter.intensity = filterIntensity
 Instead, we need to replace that with a call to setValue(:_forKey:). This is all the protocol was doing anyway, but it did provide valuable extra type safety.

 Replace that broken line of code with this:

 currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
 kCIInputIntensityKey is another Core Image constant value, and it has the same effect as setting the intensity parameter of the sepia tone filter.

 With that change, we can return to our confirmation dialog: we want to be able to change that filter to something else, then call loadImage(). So, add this method to ContentView:

 func setFilter(_ filter: CIFilter) {
     currentFilter = filter
     loadImage()
 }
 With that in place we can now replace the // dialog here comment with a series of buttons that try out various Core Image filters.

 Put this in its place:

 Button("Crystallize") { setFilter(CIFilter.crystallize()) }
 Button("Edges") { setFilter(CIFilter.edges()) }
 Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
 Button("Pixellate") { setFilter(CIFilter.pixellate()) }
 Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
 Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
 Button("Vignette") { setFilter(CIFilter.vignette()) }
 Button("Cancel", role: .cancel) { }
 I picked out those from the vast range of Core Image filters, but you’re welcome to try using code completion to try something else – type CIFilter. and see what comes up!

 Go ahead and run the app, select a picture, then try changing Sepia Tone to Vignette – this applies a darkening effect around the edges of your photo. (If you’re using the simulator, remember to give it a little time because it’s slow!)

 Now try changing it to Gaussian Blur, which ought to blur the image, but will instead cause our app to crash. By jettisoning the CISepiaTone restriction for our filter, we’re now forced to send values in using setValue(_:forKey:), which provides no safety at all. In this case, the Gaussian Blur filter doesn’t have an intensity value, so the app just crashes.

 To fix this – and also to make our single slider do much more work – we’re going to add some more code that reads all the valid keys we can use with setValue(_:forKey:), and only sets the intensity key if it’s supported by the current filter. Using this approach we can actually query as many keys as we want, and set all the ones that are supported. So, for sepia tone this will set intensity, but for Gaussian blur it will set the radius (size of the blur), and so on.

 This conditional approach will work with any filters you choose to apply, which means you can experiment with others safely. The only thing you need be careful with is to make sure you scale up filterIntensity by a number that makes sense – a 1-pixel blur is pretty much invisible, for example, so I’m going to multiply that by 200 to make it more pronounced.

 Replace this line:

 currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
 With this:

 let inputKeys = currentFilter.inputKeys

 if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
 if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
 if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
 And with that in place you can now run the app safely, import a picture of your choosing, then try out all the various filters – nothing should crash any more. Try experimenting with different filters and keys to see what you can find!
 */

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
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

