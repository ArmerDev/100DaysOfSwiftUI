//
//  ImageSaver.swift
//  HowToSaveImagesToTheUser’sPhotoLibrary
//
//  Created by James Armer on 19/06/2023.
//

import SwiftUI

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save Finished!")
    }
}

/*
 With that in place, we can go back and update our ContentView
 */
