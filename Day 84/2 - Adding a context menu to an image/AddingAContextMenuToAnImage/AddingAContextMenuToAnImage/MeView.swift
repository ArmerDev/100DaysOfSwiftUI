//
//  MeView.swift
//  AddingAContextMenuToAnImage
//
//  Created by James Armer on 02/07/2023.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    @State private var name = "Anonymous"
    @State private var emailAddress = "you@yoursite.com"
    @State private var qrCode = UIImage()

    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                
                TextField("Email Adress", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)
                
                Image(uiImage: qrCode)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .contextMenu {
                        Button {
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: qrCode)
                        } label: {
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                        }
                    }
            }
            .navigationTitle("Your code")
            .onAppear(perform: updateCode)
            .onChange(of: name) { _ in updateCode() }
            .onChange(of: emailAddress) { _ in updateCode() }
        }
    }
    
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
                
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

/*
 In terms of saving the image, we can use the same ImageSaver class we used back in project 13 (Instafilter), because that takes care of all the complex work for us. If you have ImageSaver.swift around from the previous project you can just drag it into your new project now:
 
 When it comes to using that we can just repeat the same code to generate our UIImage, then save that – replace the // save my code comment with this:
 
     let image = generateQRCode(from: "\(name)\n\(emailAddress)")
     let imageSaver = ImageSaver()
     imageSaver.writeToPhotoAlbum(image: image)

 And we’re done!
 */

/*
 We could save a little work by caching the generated QR code, however a more important side effect of that is that we wouldn’t have to pass in the name and email address each time – duplicating that data means if we change one copy in the future we need to change the other too.

 To add this change, first add a new @State property that will store the code we generate:

    @State private var qrCode = UIImage()
 
 Now modify generateQRCode() so that it quietly stores the new code in our cache before sending it back:

     if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
         qrCode = UIImage(cgImage: cgimg)
         return qrCode
     }
     
 And now our context menu button can use the cached code:

     Button {
         let imageSaver = ImageSaver()
         imageSaver.writeToPhotoAlbum(image: qrCode)
     } label: {
         Label("Save to Photos", systemImage: "square.and.arrow.down")
     }
     
 That code will compile cleanly, but I want you to run it and see what happens.

 If everything has gone to plan, Xcode should show a purple warning over your code, saying that we modified our view’s state during a view update, which causes undefined behavior. “Undefined behavior” is a fancy way of saying “this could behave in any number of weird ways, so don’t do it.”

 You see, we’re telling Swift it can load our image by calling the generateQRCode() method, so when SwiftUI calls the body property it will run generateQRCode() as requested. However, while it’s running that method, we then change our new @State property, even though SwiftUI hasn’t actually finished updating the body property yet.

 This is A Very Bad Idea, which is why Xcode is flagging up a large warning. Think about it: if drawing the QR code changes our @State cache property, that will cause body to loaded again, which will cause the QR code to be drawn again, which will change our cache property again, and so on – it’s really messy.

 The smart thing to do here is tell our image to render directly from the cached qrImage property, then call generateQRCode() when the view appears and whenever either name or email address changes.

 First, add this new method to MeView, so we can update our code from several places without having to repeat the exact string:

 func updateCode() {
     qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
 }
 Second, revert the qrCode = UIImage(cgImage: cgimg) line in generateQRCode(), because that’s no longer needed – you can just return the UIImage directly, like before.

 Third, change the QR code image to this:

 Image(uiImage: qrCode)
 Finally, add these new modifiers after navigationTitle():

 .onAppear(perform: updateCode)
 .onChange(of: name) { _ in updateCode() }
 .onChange(of: emailAddress) { _ in updateCode() }
 That will ensure the QR code is updated as soon as the view is shown, or whenever name or emailAddress get changed – perfect for our needs, and much safer than trying to change some state while SwiftUI is updating our view.

 Before you try the context menu yourself, make sure you add the same project option we had for the Instafilter project – you need to add a permission request string to your project’s configuration options.

 In case you’ve forgotten how to do that, here are the steps you need:

 Open your target settings
 Select the Info tab
 Right-click on an existing option
 Choose Add Row
 Select “Privacy - Photo Library Additions Usage Description” for the key name.
 Enter “We want to save your QR code.” as the value.
 And now this step is done – you should be able to run the app, switch to the Me tab, then long press the QR code to bring up your new context menu.
 */

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
