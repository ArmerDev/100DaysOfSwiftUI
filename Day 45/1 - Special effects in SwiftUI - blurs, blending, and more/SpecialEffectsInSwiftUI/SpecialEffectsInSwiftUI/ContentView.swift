//
//  ContentView.swift
//  SpecialEffectsInSwiftUI
//
//  Created by James Armer on 28/05/2023.
//

import SwiftUI

/*
 SwiftUI gives us extraordinary control over how views are rendered, including the ability to apply real-time blurs, blend modes, saturation adjustment, and more.
 
 Blend modes allow us to control the way one view is rendered on top of another. The default mode is .normal, which just draws the pixels from the new view onto whatever is behind, but there are lots of options for controlling color and opacity.
 
 As an example, we could draw an image inside a ZStack, then add a red rectangle on top that is drawn with the multiply blend mode:
 */

struct ContentView: View {
    var body: some View {
        ZStack {
            Image("Example")
            
            Rectangle()
                .fill(.red)
                .blendMode(.multiply)
        }
    }
}

/*
 “Multiply” is so named because it multiplies each source pixel color with the destination pixel color – in our case, each pixel of the image and each pixel of the rectangle on top. Each pixel has color values for RGBA, ranging from 0 (none of that color) through to 1 (all of that color), so the highest resulting color will be 1x1, and the lowest will be 0x0.
 
 Using multiply with a solid color applies a really common tint effect: blacks stay black (because they have the color value of 0, so regardless of what you put on top multiplying by 0 will produce 0), whereas lighter colors become various shades of the tint.
 
 In fact, multiply is so common that there’s a shortcut modifier that means we can avoid using a ZStack:
 */

struct ContentView2: View {
    var body: some View {
        Image("Example")
            .colorMultiply(.red)
    }
}

/*
 There are lots of other blend modes to choose from, and it’s worth spending some time experimenting to see how they work. Another popular effect is called screen, which does the opposite of multiply: it inverts the colors, performs a multiply, then inverts them again, resulting in a brighter image rather than a darker image.
 
 As an example, we could render three circles at various positions inside a ZStack, then use a slider to control their size and overlap:
 */

struct ContentView3: View {
    @State private var amount = 0.0
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.red)
                    .frame(width: 200 * amount)
                    .offset(x: -50, y: -80)
                    .blendMode(.screen)
                
                Circle()
                    .fill(.green)
                    .frame(width: 200 * amount)
                    .offset(x: 50, y: -80)
                    .blendMode(.screen)
                
                Circle()
                    .fill(.blue)
                    .frame(width: 200 * amount)
                    .blendMode(.screen)
            }
            .frame(width: 300, height: 300)
            
            Slider(value: $amount)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .ignoresSafeArea()
    }
}

/*
 If you’re particularly observant, you might notice that the fully blended color in the center isn’t quite white – it’s a very pale lilac color. The reason for this is that Color.red, Color.green, and Color.blue aren’t fully those colors; you’re not seeing pure red when you use Color.red. Instead, you’re seeing SwiftUI’s adaptive colors that are designed to look good in both dark mode and light mode, so they are a custom blend of red, green, and blue rather than pure shades.

 If you want to see the full effect of blending red, green, and blue, you should use custom colors like these three:

     .fill(Color(red: 1, green: 0, blue: 0))
     .fill(Color(red: 0, green: 1, blue: 0))
     .fill(Color(red: 0, green: 0, blue: 1))
 */

struct ContentView4: View {
    @State private var amount = 0.0
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color(red: 1, green: 0, blue: 0))
                    .frame(width: 200 * amount)
                    .offset(x: -50, y: -80)
                    .blendMode(.screen)
                
                Circle()
                    .fill(Color(red: 0, green: 1, blue: 0))
                    .frame(width: 200 * amount)
                    .offset(x: 50, y: -80)
                    .blendMode(.screen)
                
                Circle()
                    .fill(Color(red: 0, green: 0, blue: 1))
                    .frame(width: 200 * amount)
                    .blendMode(.screen)
            }
            .frame(width: 300, height: 300)
            
            Slider(value: $amount)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .ignoresSafeArea()
    }
}

/*
 There are a host of other real-time effects we can apply, and we already looked at blur() back in project 3. So, let’s look at just one more before we move on: saturation(), which adjusts how much color is used inside a view. Give this a value between 0 (no color, just grayscale) and 1 (full color).

 We could write a little code to demonstrate both blur() and saturation() in the same view, like this:
 */

struct ContentView5: View {
    @State private var amount = 0.0
    
    var body: some View {
        VStack {
            Image("Example")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .saturation(amount)
                .blur(radius: (1 - amount) * 20)
            
            Slider(value: $amount)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .ignoresSafeArea()
    }
}

/*
 With that code, having the slider at 0 means the image is blurred and colorless, but as you move the slider to the right it gains color and becomes sharp – all rendered at lightning-fast speed.
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
