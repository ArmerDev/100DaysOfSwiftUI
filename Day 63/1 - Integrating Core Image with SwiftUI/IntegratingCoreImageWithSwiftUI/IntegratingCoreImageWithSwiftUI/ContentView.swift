//
//  ContentView.swift
//  IntegratingCoreImageWithSwiftUI
//
//  Created by James Armer on 17/06/2023.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

/*
 Just like Core Data is Apple’s built-in framework for manipulating data, Core Image is their framework for manipulating images. This isn’t drawing, or at least for the most part it isn’t drawing, but instead it’s about changing existing images: applying sharpening, blurs, vignettes, pixellation, and more. If you ever used all the various photo effects available in Apple’s Photo Booth app, that should give you a good idea of what Core Image is good for!

 However, Core Image doesn’t integrate into SwiftUI very well. In fact, I wouldn’t even say it integrates into UIKit very well – Apple did some work to provide helpers, but it still takes quite a bit of thinking. Stick with me, though: the results are quite brilliant once you understand how it all works, and you’ll find it opens up a whole range of functionality for your apps in the future.

 First, we’re going to put in some code to give us a basic image. I’m going to structure this in a slightly odd way, but it will make sense once we mix in Core Image: we’re going to create the Image view as an optional @State property, force it to be the same width as the screen, then add an onAppear() modifier to actually load the image.

 Add an example image to your asset catalog, then modify your ContentView struct to this:
 */

struct ContentView: View {
    @State private var image: Image?

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }

    func loadImage() {
        image = Image("Example")
    }
}

/*
 First, notice how smoothly SwiftUI handles optional views – it just works! However, notice how I attached the onAppear() modifier to a VStack around the image, because if the optional image is nil then it won’t trigger the onAppear() function.

 Anyway, when that code runs it should show the example image you added, neatly scaled to fit the screen.

 Now for the complex part: what actually is an Image? As you know, it’s a view, which means it’s something we can position and size inside our SwiftUI view hierarchy. It also handles loading images from our asset catalog and SF Symbols, and it’s capable of loading from a handful of other sources too. However, ultimately it is something that gets displayed – we can’t write its contents to disk or otherwise transform them beyond applying a few simple SwiftUI filters.

 If we want to use Core Image, SwiftUI’s Image view is a great end point, but it’s not useful to use elsewhere. That is, if we want to create images dynamically, apply Core Image filters, save them to the user’s photo library, and so on, then SwiftUI’s images aren’t up to the job.

 Apple gives us three other image types to work with, and cunningly we need to use all three if we want to work with Core Image. They might sound similar, but there is some subtle distinction between them, and it’s important that you use them correctly if you want to get anything meaningful out of Core Image.

 Apart from SwiftUI’s Image view, the three other image types are:

 - UIImage, which comes from UIKit. This is an extremely powerful image type capable of working with a variety of image types, including bitmaps (like PNG), vectors (like SVG), and even sequences that form an animation. UIImage is the standard image type for UIKit, and of the three it’s closest to SwiftUI’s Image type.
 
 - CGImage, which comes from Core Graphics. This is a simpler image type that is really just a two-dimensional array of pixels.
 
 - CIImage, which comes from Core Image. This stores all the information required to produce an image but doesn’t actually turn that into pixels unless it’s asked to. Apple calls CIImage “an image recipe” rather than an actual image.
 
 There is some interoperability between the various image types:

 - We can create a UIImage from a CGImage, and create a CGImage from a UIImage.
 
 - We can create a CIImage from a UIImage and from a CGImage, and can create a CGImage from a CIImage.
 
 - We can create a SwiftUI Image from both a UIImage and a CGImage.
 
 I know, I know: it’s confusing, but hopefully once you see the code you’ll feel better. What matters is that these image types are pure data – we can’t place them into a SwiftUI view hierarchy, but we can manipulate them freely then present the results in a SwiftUI Image.

 We’re going to change loadImage() so that it creates a UIImage from our example image, then manipulate it using Core Image. More specifically, we’ll start with two tasks:

 - We need to load our example image into a UIImage, which has an initializer called UIImage(named:) to load images from our asset catalog. It returns an optional UIImage because we might have specified an image that doesn’t exist.
 
 - We’ll convert that into a CIImage, which is what Core Image wants to work with.
 
 So, start by replacing your current loadImage() implementation with this:
 */

struct ContentView2: View {
    @State private var image: Image?

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }

    func loadImage() {
        guard let inputImage = UIImage(named: "Example") else { return }
        let beginImage = CIImage(image: inputImage)
        
        // more code to come
    }
}

/*
 The next step will be to create a Core Image context and a Core Image filter. Filters are the things that do the actual work of transforming image data somehow, such as blurring it, sharpening it, adjusting the colors, and so on, and contexts handle converting that processed data into a CGImage we can work with.

 Both of these data types come from Core Image, so you’ll need to add two imports to make them available to us. So please start by adding these near the top of ContentView.swift:

 import CoreImage
 import CoreImage.CIFilterBuiltins
 Next we’ll create the context and filter. For this example we’re going to use a sepia tone filter, which applies a brown tone that makes a photo look like it was taken a long time ago.

 So, replace the // more code to come comment with this:

 let context = CIContext()
 let currentFilter = CIFilter.sepiaTone()
 */

struct ContentView3: View {
    @State private var image: Image?

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }

    func loadImage() {
        guard let inputImage = UIImage(named: "Example") else { return }
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.sepiaTone()
        
        /*
         We can now customize our filter to change the way it works. Sepia is a simple filter, so it only has two interesting properties: inputImage is the image we want to change, and intensity is how strongly the sepia effect should be applied, specified in the range 0 (original image) and 1 (full sepia).
         */
        
        currentFilter.inputImage = beginImage
        currentFilter.intensity = 1
    }
}

/*
 None of this is terribly hard, but here’s where that changes: we need to convert the output from our filter to a SwiftUI Image that we can display in our view. This is where we need to lean on all four image types at once, because the easiest thing to do is:

 Read the output image from our filter, which will be a CIImage. This might fail, so it returns an optional.
 Ask our context to create a CGImage from that output image. This also might fail, so again it returns an optional.
 Convert that CGImage into a UIImage.
 Convert that UIImage into a SwiftUI Image.
 You can go direct from a CGImage to a SwiftUI Image but it requires extra parameters and it just adds even more complexity!

 Here’s the final code for loadImage():
 */

struct ContentView4: View {
    @State private var image: Image?

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }

    func loadImage() {
        guard let inputImage = UIImage(named: "Example") else { return }
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.sepiaTone()
        
        currentFilter.inputImage = beginImage
        currentFilter.intensity = 1
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        // attempt to get a CGImage from our CIImage
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            // convert that to a UIImage
            let uiImage = UIImage(cgImage: cgimg)
            
            // and convert that to a SwiftUI Image
            image = Image(uiImage: uiImage)
        }
    }
}

/*
 If you run the app again you should see your example image now has a sepia effect applied, all thanks to Core Image.

 Now, you might well think that was a heck of a lot of work just to get a fairly simple result, but now that you have all the basics of Core Image in place it’s relatively easy to switch to different filters.

 That being said, Core Image is a little bit… well… let’s say “creative”. It was introduced way back in iOS 5.0, and by that point Swift was already being developed inside Apple, but you really wouldn’t know it – for the longest time its API was the least Swifty thing you could imagine, and although Apple has slowly chipped away at its cruft sometimes you have no choice but to dig into its underbelly.

 First, let’s look at the modern API – we could replace our sepia tone with a pixellation filter like this:
 */

struct ContentView5: View {
    @State private var image: Image?

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }

    func loadImage() {
        guard let inputImage = UIImage(named: "Example") else { return }
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.pixellate()
        currentFilter.inputImage = beginImage
        currentFilter.scale = 100
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        // attempt to get a CGImage from our CIImage
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            // convert that to a UIImage
            let uiImage = UIImage(cgImage: cgimg)
            
            // and convert that to a SwiftUI Image
            image = Image(uiImage: uiImage)
        }
    }
}

/*
 When that runs you’ll see our image looks pixellated. A scale of 100 should mean the pixels are 100 points across, but because my image is so big the pixels are relatively small.

 Now let’s try a crystal effect like this:
 */

struct ContentView6: View {
    @State private var image: Image?

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }

    func loadImage() {
        guard let inputImage = UIImage(named: "Example") else { return }
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.crystallize()
        currentFilter.inputImage = beginImage
        currentFilter.radius = 200
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        // attempt to get a CGImage from our CIImage
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            // convert that to a UIImage
            let uiImage = UIImage(cgImage: cgimg)
            
            // and convert that to a SwiftUI Image
            image = Image(uiImage: uiImage)
        }
    }
}

/*
 Or we could add a twirl distortion filter like this:
 */

struct ContentView7: View {
    @State private var image: Image?

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }

    func loadImage() {
        guard let inputImage = UIImage(named: "Example") else { return }
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.twirlDistortion()
        currentFilter.inputImage = beginImage
        currentFilter.radius = 1000
        currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        // attempt to get a CGImage from our CIImage
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            // convert that to a UIImage
            let uiImage = UIImage(cgImage: cgimg)
            
            // and convert that to a SwiftUI Image
            image = Image(uiImage: uiImage)
        }
    }
}

/*
 So, there’s a lot we can do using only the modern API. But for this project we’re going to use the older API for setting values such as radius and scale because it lets us set values dynamically – we can literally ask the current filter what values it supports, then send them on in.

 Here’s how that looks:
 */

struct ContentView8: View {
    @State private var image: Image?

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }

    func loadImage() {
        guard let inputImage = UIImage(named: "Example") else { return }
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.twirlDistortion()
        currentFilter.inputImage = beginImage
        
        let amount = 1.0
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
        }
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        // attempt to get a CGImage from our CIImage
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            // convert that to a UIImage
            let uiImage = UIImage(cgImage: cgimg)
            
            // and convert that to a SwiftUI Image
            image = Image(uiImage: uiImage)
        }
    }
}

/*
 With that in place, you can now change the twirl distortion to any other filter and the code will carry on working – each of the adjustment values are sent in only if they are supported.

 Notice how that relies on setting values for keys, which might remind you of the way UserDefaults works. In fact, all those kCIInput keys are all implemented as strings behind the scenes, so it’s even more similar than you might have realized!

 If you’re implementing precise Core Image adjustments you should definitely be using the newer API that uses exact property names and types, but in this project the older API comes in useful because it lets us send in adjustments regardless of what filter is actually used.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView4()
            .previewDisplayName("ContentView 4 - Sepia")
        ContentView5()
            .previewDisplayName("ContentView 5 - Pixellate")
        ContentView6()
            .previewDisplayName("ContentView 6 - Crystallize")
        ContentView7()
            .previewDisplayName("ContentView 7 - Twirl Distortion")
    }
}
