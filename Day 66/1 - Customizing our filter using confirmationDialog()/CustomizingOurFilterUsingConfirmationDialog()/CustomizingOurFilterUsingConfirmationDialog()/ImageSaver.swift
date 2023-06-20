//
//  ImageSaver.swift
//  CustomizingOurFilterUsingConfirmationDialog()
//
//  Created by James Armer on 20/06/2023.
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
