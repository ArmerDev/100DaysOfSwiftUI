//
//  ContentView.swift
//  ColorsAndFrames
//
//  Created by James Armer on 01/05/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Text("Your content")
        }
    }
}

/*

 If we want to put something behind the text, we need to place it above it in the ZStack. But what if we wanted to put some red behind there – how would we do that?

 One option is to use the background() modifier, which can be given a color to draw like this:
 
*/

struct ContentView2: View {
    var body: some View {
        ZStack {
            Text("Your content")
        }
        .background(.red)
    }
}

/*
 
 That might have done what you expected, but there’s a good chance it was a surprise: only the text view had a background color, even though we’ve asked the whole ZStack to have it.

 In fact, there’s no difference between that code and this:
 
 */

struct ContentView3: View {
    var body: some View {
        ZStack {
            Text("Your content")
                .background(.red)
        }
    }
}

/*
 
 If you want to fill in red the whole area behind the text, you should place the color into the ZStack – treat it as a whole view, all by itself:
 
 */

struct ContentView4: View {
    var body: some View {
        ZStack {
            Color.red
            Text("Your content")
        }
    }
}


/*
 
 In fact, Color.red is a view in its own right, which is why it can be used like shapes and text.

 Tip: When we were using the background() modifier, SwiftUI was able to figure out that .red actually meant Color.red. When we’re using the color as a free-standing view Swift has no context to help it figure out what .red means so we need to be specific that we mean Color.red.

 Colors automatically take up all the space available, but you can also use the frame() modifier to ask for specific sizes. For example, we could ask for a 200x200 red square like this:
 
 */

struct ContentView5: View {
    var body: some View {
        ZStack {
            Color.red
                .frame(width: 200, height: 200)
            Text("Your content")
        }
    }
}

/*
 
 You can also specify minimum and maximum widths and heights, depending on the layout you want. For example, we could say we want a color that is no more than 200 points high, but for its width must be at least 200 points wide but can stretch to fill all the available width that’s not used by other stuff:
 
 */

struct ContentView6: View {
    var body: some View {
        ZStack {
            Color.red
                .frame(minWidth: 200, maxWidth: .infinity, maxHeight: 200)
            Text("Your content")
        }
    }
}

/*
 
 SwiftUI gives us a number of built-in colors to work with, such as Color.blue, Color.green, Color.indigo, and more. We also have some semantic colors: colors that don’t say what hue they contain, but instead describe their purpose.

 For example, Color.primary is the default color of text in SwiftUI, and will be either black or white depending on whether the user’s device is running in light mode or dark mode. There’s also Color.secondary, which is also black or white depending on the device, but now has slight transparency so that a little of the color behind it shines through.

 If you need something specific, you can create custom colors by passing in values between 0 and 1 for red, green, and blue, like this:
 
 */


struct ContentView7: View {
    var body: some View {
        ZStack {
            Color(red: 1, green: 0.8, blue: 0)
                .frame(minWidth: 200, maxWidth: .infinity, maxHeight: 200)
            Text("Your content")
        }
    }
}

/*
 
 Even when taking up the full screen, you’ll see that using Color.red will leave some space white.

 How much space is white depends on your device, but on iPhones with Face ID – iPhone 13, for example – you’ll find that both the status bar (the clock area at the top) and the home indicator (the horizontal stripe at the bottom) are left uncolored.

 This space is left intentionally blank, because Apple doesn’t want important content to get obscured by other UI features or by any rounded corners on your device. So, the remaining part – that whole middle space – is called the safe area, and you can draw into it freely without worrying that it might be clipped by the notch on an iPhone.

 If you want your content to go under the safe area, you can use the .ignoresSafeArea() modifier to specify which screen edges you want to run up to, or specify nothing to automatically go edge to edge. For example, this creates a ZStack which fills the screen edge to edge with red then draws some text on top:
 
 */

struct ContentView8: View {
    var body: some View {
        ZStack {
            Color.red
            Text("Your content")
        }
        .ignoresSafeArea()
    }
}

/*
 
 It is critically important that no important content be placed outside the safe area, because it might be hard if not impossible for the user to see. Some views, such as List, allow content to scroll outside the safe area but then add extra insets so the user can scroll things into view.

 If your content is just decorative – like our background color here – then extending it outside the safe area is OK.

 Before we’re done, there’s one more thing I want to mention: as well as using fixed colors such as .red and .green, the background() modifier can also accept materials. These apply a frosted glass effect over whatever comes below them, which allows us to create some beautiful depth effects.

 To see this in action, we could build up our ZStack so that it has two colors inside a VStack, so they split the available space between them. Then, we’ll attach a couple of modifiers to our text view so that it has a gray color, with an ultra thin material behind it:
 
 */

struct ContentView9: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.red
                Color.blue
            }

            Text("Your content")
                .foregroundColor(.secondary)
                .padding(50)
                .background(.ultraThinMaterial)
        }
        .ignoresSafeArea()
    }
}

/*
 
 That uses the thinnest material, which is means we’re letting a lot of the background colors shine through our frosted glass effect. iOS automatically adapts the effect based on whether the user has light or dark mode enabled – our material will either be light-colored or dark-colored, as appropriate.

 There are other material thicknesses available depending on what effect you want, but there’s something even neater I want to show to you. It’s subtle, though, so I’d like you to click the tiny magnifying glass icon at the bottom of your SwiftUI preview so you can get a super close-up look at the “Your content” text.

 Right now you’ll see “Your content” is written in gray, because we’re using a secondary foreground color. However, SwiftUI gives us an alternative that provides a very slightly different effect: change the foregroundColor() modifier to foregroundStyle() – do you see the difference?

 You should be able to see that the text is no longer just gray, but instead allows a little of the red and blue background colors to come through. It’s not a lot, just a hint, but when used effectively this provides a really beautiful effect to make sure text stands out regardless of the background behind it. iOS calls this effect vibrancy, and it’s used a lot throughout the system.
 
 */

struct ContentView10: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.red
                Color.blue
            }

            Text("Your content")
                .foregroundStyle(.secondary)
                .font(.largeTitle.bold())
                .padding(50)
                .background(.ultraThinMaterial)
        }
        .ignoresSafeArea()
    }
}

/*
 
 SwiftUI provides a foregroundStyle() modifier to control the way text, images, and shapes are styled all at once. In its simplest form this is similar to using foregroundColor() with .secondary, but not only does it unlock more of the semantic colors – .tertiary and .quaternary, it also adds support for anything that conforms to ShapeStyle.

 So, here’s an example of an image and some text rendered using quaternary style, which is the lowest of four importance levels for content:
 
 */

struct ContentView11: View {
    var body: some View {
        HStack {
            Image(systemName: "clock.fill")
            Text("Set the time")
        }
        .font(.largeTitle.bold())
        .foregroundStyle(.quaternary)
    }
}

/*
 
 Like I said, anything that conforms to ShapeStyle also works, meaning that we can render our HStack with a red to black linear gradient using the same modifier:
 
 */

struct ContentView12: View {
    var body: some View {
        HStack {
            Image(systemName: "clock.fill")
            Text("Set the time")
        }
        .font(.largeTitle.bold())
        .foregroundStyle(
            .linearGradient(
                colors: [.red, .black],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDisplayName("ContentView")
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
        }
        
        Group {
            ContentView7()
                .previewDisplayName("ContentView 7")
            ContentView8()
                .previewDisplayName("ContentView 8")
            ContentView9()
                .previewDisplayName("ContentView 9")
            ContentView10()
                .previewDisplayName("ContentView 10")
            ContentView11()
                .previewDisplayName("ContentView 11")
            ContentView12()
                .previewDisplayName("ContentView 12")
                .preferredColorScheme(.dark)
        }
        
        
    }
}
