//
//  ContentView.swift
//  HidingAndGroupingAccessibilityData
//
//  Created by James Armer on 25/06/2023.
//

import SwiftUI

/*
 If you spend even a few minutes with an active VoiceOver user, you’ll learn two things very quickly: they are remarkably adept at navigating around user interfaces, and they also often set reading speed extremely fast – way faster than you or I would use.

 It’s important to take both of those things into account when we’re designing our UI: these users aren’t just trying VoiceOver out of curiosity, but are instead VoiceOver power users who rely on it to access your app. As a result, it’s important we ensure our UI removes as much clutter as possible so that users can navigate through it quickly and not have to listen to VoiceOver reading unhelpful descriptions.

 Beyond setting labels and hints, there are several ways we can control what VoiceOver reads out. There are three in particular I want to focus on:

 Marking images as being unimportant for VoiceOver.
 Hiding views from the accessibility system.
 Grouping several views as one.
 All of these are simple changes to make, but they result in a big improvement.

 For example, we can tell SwiftUI that a particular image is just there to make the UI look better by using Image(decorative:). Whether it’s a simple bullet point or an animation of your app’s mascot character running around, it doesn’t actually convey any information and so Image(decorative:) tells SwiftUI it should be ignored by VoiceOver.
 */

struct ContentView: View {
    var body: some View {
        Image(decorative: "Character")
    }
}

/*
 This leaves the image as being accessible to VoiceOver if it has some important traits, such as .isButton – it will say “button” when it’s highlighted, and if we attach a tap gesture that works – but it doesn’t read out the image’s filename as the automatic VoiceOver label. If you then add a label or a hint that will be read.

 If you want to go a step further, you can use the .accessibilityHidden() modifier, which makes any view completely invisible to the accessibility system:
 */

struct ContentView2: View {
    var body: some View {
        Image(decorative: "Character")
            .accessibilityHidden(true)
    }
}

/*
 With that modifier the image becomes invisible to VoiceOver regardless of what traits it has. Obviously you should only use this if the view in question really does add nothing – if you had placed a view offscreen so that it wasn’t currently visible to users, you should mark it inaccessible to VoiceOver too.

 The last way to hide content from VoiceOver is through grouping, which lets us control how the system reads several views that are related. As an example, consider this layout:
 */

struct ContentView3: View {
    var body: some View {
        VStack {
            Text("Your score is")
            Text("1000")
                .font(.title)
        }
    }
}

/*
 VoiceOver sees that as two unrelated text views, and so it will either read “Your score is” or “1000” depending on what the user has selected. Both of those are unhelpful, which is where the .accessibilityElement(children:) modifier comes in: we can apply it to a parent view, and ask it to combine children into a single accessibility element.

 For example, this will cause both text views to be read together:
 */

struct ContentView4: View {
    var body: some View {
        VStack {
            Text("Your score is")
            Text("1000")
                .font(.title)
        }
        .accessibilityElement(children: .combine)
    }
}

/*
 That works really well when the child views contain separate information, but in our case the children really should be read as a single entity. So, the better solution here is to use .accessibilityElement(children: .ignore) so the child views are invisible to VoiceOver, then provide a custom label to the parent, like this:
 */

struct ContentView5: View {
    var body: some View {
        VStack {
            Text("Your score is")
            Text("1000")
                .font(.title)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Your score is 1000")
    }
}

/*
 It’s worth trying both of these to see how they differ in practice. Using .combine adds a pause between the two pieces of text, because they aren’t necessarily designed to be read together. Using .ignore and a custom label means the text is read all at once, and is much more natural.

 Tip: .ignore is the default parameter for children, so you can get the same results as .accessibilityElement(children: .ignore) just by saying .accessibilityElement().
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
    }
}
