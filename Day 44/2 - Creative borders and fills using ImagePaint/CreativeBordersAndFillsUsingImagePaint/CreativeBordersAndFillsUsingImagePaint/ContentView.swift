//
//  ContentView.swift
//  CreativeBordersAndFillsUsingImagePaint
//
//  Created by James Armer on 27/05/2023.
//

import SwiftUI

/*
 \SwiftUI relies heavily on protocols, which can be a bit confusing when working with drawing. For example, we can use Color as a view, but it also conforms to ShapeStyle – a different protocol used for fills, strokes, and borders.
 
 In practice, this means we can modify the default text view so that it has a red background:
 */

struct ContentView: View {
    var body: some View {
        Text("Hello World")
            .frame(width: 300, height: 300)
            .background(.red)
    }
}

/*
 Or a red border:
 */

struct ContentView2: View {
    var body: some View {
        Text("Hello World")
            .frame(width: 300, height: 300)
            .border(.red, width: 30)
    }
}

/*
 In contrast, we can use an image for the background:
 */

struct ContentView3: View {
    var body: some View {
        Text("Hello World")
            .frame(width: 300, height: 300)
            .background(Image("Example"))
    }
}

/*
 But using the same image as a border won’t work:
 */

struct ContentView4: View {
    var body: some View {
        Text("Hello World")
            .frame(width: 300, height: 300)
            // Uncomment to see error.
            //.border(Image("Example"), width: 30)
    }
}

/*
 This makes sense if you think about it – unless the image is the exact right size, you have very little control over how it should look.

 To resolve this, SwiftUI gives us a dedicated type that wraps images in a way that we have complete control over how they should be rendered, which in turn means we can use them for borders and fills without problem.

 The type is called ImagePaint, and it’s created using one to three parameters. At the very least you need to give it an Image to work with as its first parameter, but you can also provide a rectangle within that image to use as the source of your drawing specified in the range of 0 to 1 (the second parameter), and a scale for that image (the third parameter). Those second and third parameters have sensible default values of “the whole image” and “100% scale”, so you can sometimes ignore them.

 As an example, we could render an example image using a scale of 0.2, which means it’s shown at 1/5th the normal size:
 */

struct ContentView5: View {
    var body: some View {
        Text("Hello World")
            .frame(width: 300, height: 300)
            .border(ImagePaint(image: Image("Example"), scale: 0.2), width: 30)
    }
}

/*
 If you want to try using the sourceRect parameter, make sure you pass in a CGRect of relative sizes and positions: 0 means “start” and 1 means “end”. For example, this will show the entire width of our example image, but only the middle half:
 */

struct ContentView6: View {
    var body: some View {
        Text("Hello World")
            .frame(width: 300, height: 300)
            .border(ImagePaint(image: Image("Example"), sourceRect: CGRect(x: 0, y: 0.25, width: 1, height: 0.5), scale: 0.1), width: 30)
    }
}

/*
 It’s worth adding that ImagePaint can be used for view backgrounds and also shape strokes. For example, we could create a capsule with our example image tiled as its stroke:
 */

struct ContentView7: View {
    var body: some View {
        Capsule()
            .strokeBorder(ImagePaint(image: Image("Example"), scale: 0.1), lineWidth: 20)
            .frame(width: 300, height: 200)
    }
}

/*
 ImagePaint will automatically keep tiling its image until it has filled its area – it can work with backgrounds, strokes, borders, and fills of any size.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
        ContentView3()
            .previewDisplayName("ContentView 3")
        ContentView4()
            .previewDisplayName("ContentView 4")
        ContentView5()
            .previewDisplayName("ContentView 5")
        ContentView6()
            .previewDisplayName("ContentView 6")
        ContentView7()
            .previewDisplayName("ContentView 7")
    }
}
