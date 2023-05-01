//
//  ContentView.swift
//  ButtonsAndImages
//
//  Created by James Armer on 01/05/2023.
//

import SwiftUI

/*
 
 The simplest way to make a button is when you pass some text as the title of the button, along with a closure that should be run when the button is tapped:
 
 */

struct ContentView: View {
    var body: some View {
        Button("Delete selection") {
            print("Now deleting…")
        }
    }
}

/*
 
 Of course, that could be any function rather than just a closure, so this kind of thing is fine:
 
 */

struct ContentView2: View {
    var body: some View {
        Button("Delete selection", action: executeDelete)
    }

    func executeDelete() {
        print("Now deleting…")
    }
}

/*
 
 There are few different ways we can customize the way buttons look. First, we can attach a role to the button, which iOS can use to adjust its appearance both visually and for screen readers. For example, we could say that our Delete button has a destructive role like this:
 
 */

struct ContentView3: View {
    var body: some View {
        Button("Delete selection", role: .destructive, action: executeDelete)
    }
    
    func executeDelete() {
        print("Now deleting…")
    }
}

/*
 
 Second, we can use one of the built-in styles for buttons: .bordered and .borderedProminent. These can be used by themselves, or in combination with a role:
 
 */

struct ContentView4: View {
    var body: some View {
        VStack {
            Button("Button 1") { }
                .buttonStyle(.bordered)
            Button("Button 2", role: .destructive) { }
                .buttonStyle(.bordered)
            Button("Button 3") { }
                .buttonStyle(.borderedProminent)
            Button("Button 4", role: .destructive) { }
                .buttonStyle(.borderedProminent)
        }
    }
}

/*
 
 If you want to customize the colors used for a bordered button, use the tint() modifier like this:
 
 */

struct ContentView5: View {
    var body: some View {
        Button("Button 1") { }
            .buttonStyle(.borderedProminent)
            .tint(.mint)
    }
}

/*
 
 Important: Apple explicitly recommends against using too many prominent buttons, because when everything is prominent nothing is.

 If you want something completely custom, you can pass a custom label using a second trailing closure:
 
 */

struct ContentView6: View {
    var body: some View {
        Button {
            print("Button was tapped")
        } label: {
            Text("Tap me!")
                .padding()
                .foregroundColor(.white)
                .background(.red)
        }
    }
}

/*
 
 This is particularly common when you want to incorporate images into your buttons.

 SwiftUI has a dedicated Image type for handling pictures in your apps, and there are three main ways you will create them:

 Image("pencil") will load an image called “Pencil” that you have added to your project.
 Image(decorative: "pencil") will load the same image, but won’t read it out for users who have enabled the screen reader. This is useful for images that don’t convey additional important information.
 Image(systemName: "pencil") will load the pencil icon that is built into iOS. This uses Apple’s SF Symbols icon collection, and you can search for icons you like – download Apple’s free SF Symbols app from the web to see the full set.
 By default the screen reader will read your image name if it is enabled, so make sure you give your images clear names if you want to avoid confusing the user. Or, if they don’t actually add information that isn’t already elsewhere on the screen, use the Image(decorative:) initializer.

 Because the longer form of buttons can have any kind of views inside them, you can use images like this:
 
 */

struct ContentView7: View {
    var body: some View {
        Button {
            print("Edit button was tapped")
        } label: {
            Image(systemName: "pencil")
        }
    }
}

/*
 
 If you want both text and image at the same time, SwiftUI has a dedicated type called Label.

 */

struct ContentView8: View {
    var body: some View {
        Button {
            print("Edit button was tapped")
        } label: {
            Label("Edit", systemImage: "pencil")
        }
    }
}

/*
 
 That will show both a pencil icon and the word “Edit” side by side, which on the surface sounds exactly the same as what we’d get by using a simple HStack. However, SwiftUI is really smart: when we use a label it will automatically decide whether to show the icon, the text, or both depending on how they are being used in our layout. This makes Label a fantastic choice in many situations, as you’ll see.

 Tip: If you find that your images have become filled in with a color, for example showing as solid blue rather than your actual picture, this is probably SwiftUI coloring them to show that they are tappable. To fix the problem, use the renderingMode(.original) modifier to force SwiftUI to show the original image rather than the recolored version.
 
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
        ContentView8()
            .previewDisplayName("ContentView 8")
    }
}
