//
//  ContentView.swift
//  LoadingAnImageFromARemoteServer
//
//  Created by James Armer on 29/05/2023.
//

import SwiftUI

/*
 SwiftUI’s Image view works great with images in your app bundle, but if you want to load a remote image from the internet you need to use AsyncImage instead. These are created using an image URL rather than a simple asset name, but SwiftUI takes care of all the rest for us – it downloads the image, caches the download, and displays it automatically.

 So, the simplest image we can create looks like this:
 */

struct ContentView: View {
    var body: some View {
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"))
    }
}

/*
 I created that picture to be 1200 pixels high, but when it displays you’ll see it’s much bigger. This gets straight to one of the fundamental complexities of using AsyncImage: SwiftUI knows nothing about the image until our code is run and the image is downloaded, and so it isn’t able to size it appropriately ahead of time.

 If I were to include that 1200px image in my project, I’d actually name it logo@3x.png, then also add an 800px image that was logo@2x.png. SwiftUI would then take care of loading the correct image for us, and making sure it appeared nice and sharp, and at the correct size too. As it is, SwiftUI loads that image as if it were designed to be shown at 1200 pixels high – it will be much bigger than our screen, and will look a bit blurry too.

 To fix this, we can tell SwiftUI ahead of time that we’re trying to load a 3x scale image, like this:
 */

struct ContentView2: View {
    var body: some View {
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"), scale: 3)
    }
}

/*
 When you run the code now you’ll see the resulting image is a much more reasonable size.
 
 And if you wanted to give it a precise size? Well, then you might start by trying this:
 */

struct ContentView3: View {
    var body: some View {
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"))
            .frame(width: 200, height: 200)
    }
}

/*
 That won’t work, but perhaps that won’t even surprise you because it wouldn’t work with a regular Image either. So you might try to make it resizable, like this:
 */
          
struct ContentView4: View {
    var body: some View {
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"))
//            Uncomment to see errors
//            .resizable()
//            .frame(width: 200, height: 200)
    }
}

/*
 …except that won’t work either, and in fact it’s worse because now our code won’t even compile. You see, the modifiers we’re applying here don’t apply directly to the image that SwiftUI downloads – they can’t, because SwiftUI can’t know how to apply them until it has actually fetched the image data.

 Instead, we’re applying modifiers to a wrapper around the image, which is the AsyncImage view. That will ultimately contain our finished image, but it will also contain a placeholder that gets used while the image is loading. You can actually see the placeholder just briefly when your app runs – that 200x200 gray square is it, and it will automatically go away once loading finishes.

 To adjust our image, you need to use a more advanced form of AsyncImage that passes us the final image view once it’s ready, which we can then customize as needed. As a bonus, this also gives us a second closure to customize the placeholder as needed.

 For example, we could make the finished image view be both resizable and scaled to fit, and use Color.red as the placeholder so it’s more obvious while you’re learning.
 */

struct ContentView5: View {
    var body: some View {
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            Color.red
        }
        .frame(width: 200, height: 200)
    }
}

/*
 A resizable image and Color.red both automatically take up all available space, which means the frame() modifier actually works now.

 The placeholder view can be whatever you want. For example, if you replace Color.red with ProgressView() – just that – then you’ll get a little spinner activity indicator instead of a solid color.
 */

struct ContentView6: View {
    var body: some View {
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 200, height: 200)
    }
}

/*
 If you want complete control over your remote image, there’s a third way of creating AsyncImage that tells us whether the image was loaded, hit an error, or hasn’t finished yet. This is particularly useful for times when you want to show a dedicated view when the download fails – if the URL doesn’t exist, or the user was offline, etc.

 Here’s how that looks:
 */

struct ContentView7: View {
    var body: some View {
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                Text("There was an error loading the image.")
            } else {
                ProgressView()
            }
        }
        .frame(width: 200, height: 200)
    }
}

/*
 So, that will show our image if it can, an error message if the download failed for any reason, or a spinning activity indicator while the download is still in progress.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
        ContentView3()
            .previewDisplayName("ContentView 3")
        // ContentView4() ignored because it produces an error.
        ContentView5()
            .previewDisplayName("ContentView 5")
        ContentView6()
            .previewDisplayName("ContentView 6")
        ContentView7()
            .previewDisplayName("ContentView 7")
    }
}
