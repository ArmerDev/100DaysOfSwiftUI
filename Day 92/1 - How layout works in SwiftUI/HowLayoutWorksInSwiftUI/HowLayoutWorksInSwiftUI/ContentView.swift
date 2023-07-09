//
//  ContentView.swift
//  HowLayoutWorksInSwiftUI
//
//  Created by James Armer on 09/07/2023.
//

import SwiftUI

/*
 All SwiftUI layout happens in three simple steps, and understanding these steps is the key to getting great layouts every time. The steps are:

 - A parent view proposes a size for its child.
 
 - Based on that information, the child then chooses its own size and the parent must respect that choice.
 
 - The parent then positions the child in its coordinate space.
 
 Behind the scenes, SwiftUI performs a fourth step: although it stores positions and sizes as floating-point numbers, when it comes to rendering SwiftUI rounds off any pixels to their nearest values so our graphics remain sharp.

 Those three rules might seem simple, but they allow us to create hugely complicated layouts where every view decides how and when it resizes without the parent having to get involved.

 To demonstrate these rules in action, I’d like you to modify the default SwiftUI template to add a background() modifier, like this:
 */

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .background(.red)
    }
}

/*
 You’ll see the background color sits tightly around the text itself – it takes up only enough space to fit the content we provided.

 Now, think about this question: how big is ContentView? As you can see, the body of ContentView – the thing that it renders – is some text with a background color. And so the size of ContentView is exactly and always the size of its body, no more and no less. This is called being layout neutral: ContentView doesn’t have any size of its own, and instead happily adjusts to fit whatever size is needed.

 Back in project 3 I explained to you that when you apply a modifier to a view we actually get back a new view type called ModifiedContent, which stores both our original view and its modifier. This means when we apply a modifier, the actual view that goes into the hierarchy is the modified view, not the original one.

 In our simple background() example, that means the top-level view inside ContentView is the background, and inside that is the text. Backgrounds are layout neutral just like ContentView, so it will just pass on any layout information as needed – you can end up with a chain of layout information being passed around until a definitive answer comes back.

 If we put this into the three-step layout system, we end up with a conversation a bit like this:

 - SwiftUI: “Hey, ContentView, you have the whole screen to yourself – how much of it do you need?” (Parent view proposes a size)
 
 - ContentView: “I don’t care; I’m layout neutral. Let me ask my child: hey, background, you have the whole screen to yourself – how much of it do you need?” (Parent view proposes a size)
 
 - Background: “I also don’t care; I’m layout neutral too. Let me ask my child: hey, text, you can have the whole screen to yourself – how much of it do you need?” (Parent view proposes a size)
 
 - Text: “Well, I have the letters ‘Hello, World’ in the default font, so I need exactly X pixels width by Y pixels height. I don’t need the whole screen, just that.” (Child chooses its size.)
 
 - Background: “Got it. Hey, ContentView: I need X by Y pixels, please.”
 
 - ContentView: “Right on. Hey, SwiftUI: I need X by Y pixels.”
 
 - SwiftUI: “Nice. Well, that leaves lots of space, so I’m going to put you at your size in the center.” (Parent positions the child in its coordinate space.)
 
 So, when we say Text("Hello, World!").background(.red), the text view becomes a child of its background. SwiftUI effectively works its way from bottom to top when it comes to a view and its modifiers.

 Now consider this layout:
 */

struct ContentView2: View {
    var body: some View {
        Text("Hello, World!")
            .padding(20)
            .background(.red)
    }
}

/*
 This time the conversation is more complicated: padding() no longer offers all its space to its child, because it needs to subtract 20 points from each side to make sure there’s enough space for the padding. Then, when the answer comes back from the text view, padding() adds 20 points on each side to pad it out, as requested.

 So, it’s more like this:

 - SwiftUI: You can have the whole screen, how much of it do you need, ContentView?
 
 - ContentView: You can have the whole screen, how much of it do you need, background?
 
 - Background: You can have the whole screen, how much of it do you need, padding?
 
 - Padding: You can have the whole screen minus 20 points on each side, how much of it do you need, text?
 
 - Text: I need X by Y.
 
 - Padding: I need X by Y plus 20 points on each side.
 
 - Background: I need X by Y plus 20 points on each side.
 
 - ContentView: I need X by Y plus 20 points on each side.
 
 - SwiftUI: OK; I’ll center you.
 
 If you remember, the order of our modifiers matters. That is, this code:
 */

struct ContentView3: View {
    var body: some View {
        Text("Hello, World!")
            .padding()
            .background(.red)
    }
}

/*
 And this code:
 */

struct ContentView4: View {
    var body: some View {
        Text("Hello, World!")
            .background(.red)
            .padding()
    }
}

/*
 Yield two different results. Hopefully now you can see why: background() is layout neutral, so it determines how much space it needs by asking its child how much space it needs and using that same value. If the child of background() is the text view then the background will fit snugly around the text, but if the child is padding() then it receive back the adjusted values that including the padding amount.

 There are two interesting side effects that come as a result of these layout rules.

 First, if your view hierarchy is wholly layout neutral, then it will automatically take up all available space. For example, shapes and colors are layout neutral, so if your view contains a color and nothing else it will automatically fill the screen like this:
 */

struct ContentView5: View {
    var body: some View {
        Color.red
    }
}

/*
 Remember, Color.red is a view in its own right, but because it is layout neutral it can be drawn at any size. When we used it inside background() the abridged layout conversation worked like this:

 - Background: Hey text, you can have the whole screen – how much of that do you want?
 
 - Text: I need X by Y points; I don’t need the rest.
 
 - Background: OK. Hey, Color.red: you can have X by Y points – how much of that do you want?
 
 - Color.red: I don’t care; I’m layout neutral, so X by Y points sounds good to me.
 
 The second interesting side effect is one we faced earlier: if we use frame() on an image that isn’t resizable, we get a larger frame without the image inside changing size. This might have been confusing before, but it makes absolute sense once you think about the frame as being the parent of the image:

 - ContentView offers the frame the whole screen.
 
 - The frame reports back that it wants 300x300.
 
 - The frame then asks the image inside it what size it wants.
 
 - The image, not being resizable, reports back a fixed size of 64x64 (for example).
 
 - The frame then positions that image in the center of itself.
 
 When you listen to Apple’s own SwiftUI engineers talk about modifiers, you’ll hear them refer them to as views – “the frame view”, “the background view”, and so on. I think that’s a great mental model to help understand exactly what’s going on: applying modifiers creates new views rather than just modifying existing views in-place.
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
