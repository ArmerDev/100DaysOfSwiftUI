//
//  ContentView.swift
//  MakingNavigationViewWorkInLandscape
//
//  Created by James Armer on 17/07/2023.
//

import SwiftUI

/*
 When we use a NavigationView, by default SwiftUI expects us to provide both a primary view and a secondary detail view that can be shown side by side, with the primary view shown on the left and the secondary on the right. This isn’t required – you can force the push/pop NavigationLink behavior if you want by using the navigationViewStyle() modifier – but in this project we actually want the two-view behavior so we aren’t going to use that.

 On landscape iPhones that are big enough – iPhone 13 Pro Max, for example – SwiftUI’s default behavior is to show the secondary view, and provide the primary view as a slide over. It’s always been there, but you might not have realized until recently: try sliding from the left edge of your screen to reveal the ContentView we just made. If you tap rows in there you’ll see the text behind ContentView change as the result of our NavigationLink, and if you tap on the text behind you can dismiss the ContentView slide over.

 Now, there is a problem here, and it’s the same problem you’ve had all along: it’s not immediately obvious to the user that they need to slide from the left to reveal the list of options. In UIKit this can be fixed easily, but SwiftUI doesn’t give us an alternative right now so we’re going to work around the problem: we’ll create a second view to show on the right by default, and use that to help the user discover the left-hand list.

 First, create a new SwiftUI view called WelcomeView, then give it this code:
 */

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    var body: some View {
        NavigationView {
            List(resorts) { resort in
                NavigationLink {
                    Text(resort.name)
                } label: {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black, lineWidth: 1)
                        )

                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Resorts")
            
            WelcomeView()
        }
    }
}

/*
 That’s enough for SwiftUI to understand exactly what we want. Try running the app on several different devices, both in portrait and landscape, to see how SwiftUI responds – on an iPhone 13 Pro you’ll see ContentView in both portrait and landscape, but on an iPhone 13 Pro Max you’ll see ContentView in portrait and WelcomeView in landscape. If you’re using an iPad, you might see several different things depending on the device orientation and whether the app has all the screen to itself as opposed to using split screen.

 Although UIKit lets us control whether the primary view should be shown on iPad portrait, this is not yet possible in SwiftUI. However, we can stop iPhones from using the slide over approach if that’s what you want – try it first and see what you think. If you want it gone, add this extension to your project:
 */

extension View {
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}

/*
 That uses Apple’s UIDevice class to detect whether we are currently running on a phone or a tablet, and if it’s a phone enables the simpler StackNavigationViewStyle approach. We need to use the @ViewBuilder attribute here because the two returned view types are different.

 Once you have that extension, simply add the .phoneOnlyStackNavigationView() modifier to your NavigationView so that iPads retain their default behavior whilst iPhones always use stack navigation. Again, give it a try and see what you think – it’s your app, and it’s important you like how it works.

 Tip: I’m not going to be using this modifier in my own project because I prefer to use Apple’s default behavior where possible, but don’t let that stop you from making your own choice!
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
