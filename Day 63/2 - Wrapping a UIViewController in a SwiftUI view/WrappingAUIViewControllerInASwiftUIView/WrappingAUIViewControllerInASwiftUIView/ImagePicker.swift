//
//  ImagePicker.swift
//  WrappingAUIViewControllerInASwiftUIView
//
//  Created by James Armer on 18/06/2023.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    //typealias UIViewControllerType = PHPickerViewController
}

/*
 That protocol builds on View, which means the struct we’re defining can be used inside a SwiftUI view hierarchy, however we don’t provide a body property because the view’s body is the view controller itself – it just shows whatever UIKit sends back.

 Conforming to UIViewControllerRepresentable does require us to fill in that struct with two methods: one called makeUIViewController(), which is responsible for creating the initial view controller, and another called updateUIViewController(), which is designed to let us update the view controller when some SwiftUI state changes.

 These methods have really precise signatures, so I’m going to show you a neat shortcut. The reason the methods are long is because SwiftUI needs to know what type of view controller our struct is wrapping, so if we just straight up tell Swift that type Xcode will help us do the rest.

 Add this code to the struct now:

 typealias UIViewControllerType = PHPickerViewController
 That isn’t enough code to compile correctly, but when Xcode shows an error saying “Type ImagePicker does not conform to protocol UIViewControllerRepresentable”, please click the red and white circle to the left of the error and select “Fix”. This will make Xcode write the two methods we actually need, and in fact those methods are actually enough for Swift to figure out the view controller type so you can delete the typealias line.
 */

/*
 We aren’t going to be using updateUIViewController(), so you can just delete the “code” line from there so that the method is empty.

 However, the makeUIViewController() method is important, so please replace its existing “code” line with this:

 var config = PHPickerConfiguration()
 config.filter = .images

 let picker = PHPickerViewController(configuration: config)
 return picker
 That creates a new photo picker configuration, asking it to provide us only images, then uses that to create and return a PHPickerViewController that does the actual work of selecting an image.

 We’ll add some more code to that shortly, but that’s actually all we need to wrap a basic view controller.

 Our ImagePicker struct is a valid SwiftUI view, which means we can now show it in a sheet just like any other SwiftUI view. This particular struct is designed to show an image, so we need an optional Image view to hold the selected image, plus some state that determines whether the sheet is showing or not.

 Go back to ContentView and update it...
 */
