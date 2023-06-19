//
//  ContentView.swift
//  BuildingOurBasicUI
//
//  Created by James Armer on 19/06/2023.
//

import SwiftUI

/*
 The first step in our project is to build the basic user interface, which for this app will be:

 - A NavigationView so we can show our app’s name at the top.
 
 - A large gray box saying “Tap to select a picture”, over which we’ll place their imported picture.
 
 - An “Intensity” slider that will affect how strongly we apply our Core Image filters, stored as a value from 0.0 to 1.0.
 
 - A “Save” button to write out the modified image to the user’s photo library.
 
 Initially the user won’t have selected an image, so we’ll represent that using an @State optional image property.
 */

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    
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
                    // select an image
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
        }
    }
    
    func save() {
        
    }
}

/*
 I love being able to place optional views right inside a SwiftUI layout, and I think it works particularly well with ZStack because the text below our picture will automatically be obscured when a picture has been loaded by the user.

 Now, as our code was fairly easy here, I want to just briefly explore what it looks like to clean up our body property a little – we have lots of layout code in there, but as you can see we also have a couple of button closures in there too.

 For very small pieces of code I’m usually happy enough to have button actions specified as closures, but that Save button is going to have quite a few lines in there when we’re done so I would suggest spinning it out into its own function.

 Right now that just means adding an empty save() method to ContentView, like this:

 func save() {
 }
 
 We would then call that from the button like so:

 Button("Save", action: save)
 When you’re learning it’s very common to write button actions and similar directly inside your views, but once you get onto real projects it’s a good idea to spend extra time keeping your code cleaned up – it makes your life easier in the long term, trust me!

 I’ll be adding more little cleanup tips like this going forward, so as you start to approach the end of the course you feel increasingly confident that your code is in good shape.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
