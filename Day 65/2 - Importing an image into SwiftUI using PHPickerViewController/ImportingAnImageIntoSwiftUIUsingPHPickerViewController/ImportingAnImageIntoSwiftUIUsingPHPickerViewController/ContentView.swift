//
//  ContentView.swift
//  ImportingAnImageIntoSwiftUIUsingPHPickerViewController
//
//  Created by James Armer on 19/06/2023.
//

import SwiftUI

/*
 In order to bring this project to life, we need to let the user select a photo from their library, then display it in ContentView. I’ve already shown you how this all works, so if you followed the introductory chapters you’ll already have most of the code you need.
 
 So let's continue and add a new @State Boolean to track whether our image picker is being shown or not:
 
 Second, we need to set that Boolean to true when the big gray rectangle is tapped, so update the // select an image to change the showingImagePicker to true
 
 Third, we need a property that will store the image the user selected. We gave the ImagePicker struct an @Binding property attached to a UIImage, which means when we create the image picker we need to pass in a UIImage for it to link to. When the @Binding property changes, the external value changes as well, which lets us read the value.

 So, add a @State property called inputImage
 
 Fourth, we need a method that will be called when the ImagePicker view has been dismissed. For now this will just place the selected image directly into the UI, so please add this method to ContentView now:
 
 We can then call that whenever our inputImage value changes, by attaching an onChange() modifier somewhere in ContentView – it really doesn’t matter where, but after navigationTitle() would seem sensible.
 
 And finally, we need to add a sheet() modifier somewhere in ContentView. This will use showingImagePicker as its condition, and present an ImagePicker bound to inputImage as its contents.
 */

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    
    @State private var inputImage: UIImage?
    
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
        image = Image(uiImage: inputImage)
    }
}

/*
 That completes all the steps required to wrap a UIKit view controller for use inside SwiftUI. We went over it a little faster this time but hopefully it still all made sense!

 Go ahead and run the app again, and you should be able to tap the gray rectangle to import a picture, and when you’ve found one it will appear inside our UI.

 Tip: The ImagePicker view we just made is completely reusable – you can put that Swift file to one side and use it on other projects easily. If you think about it, all the complexity of wrapping the view is contained inside ImagePicker.swift, which means if you do choose to use it elsewhere it’s just a matter of showing a sheet and binding an image.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
