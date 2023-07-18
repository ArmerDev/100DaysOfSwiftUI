//
//  ContentView.swift
//  ChangingAViewsLayoutInResponseToSizeClasses
//
//  Created by James Armer on 18/07/2023.
//

import SwiftUI

/*
 SwiftUI gives us two environment values to monitor the current size class of our app, which in practice means we can show one layout when space is restricted and another when space is plentiful.

 For example, in our current layout we’re displaying the resort details and snow details in a HStack, like this:

     HStack {
         ResortDetailsView(resort: resort)
         SkiDetailsView(resort: resort)
     }
 
 Each of those subviews are internally using a Group that doesn’t add any of its own layout, so we end up with all four pieces of text laid out horizontally. This looks great when we have enough space, but when space is limited it would be helpful to switch to a 2x2 grid layout.

 To make this happen we could create copies of ResortDetailsView and SkiDetailsView that handle the alternative layout, but a much smarter solution is to have both those views remain layout neutral – to have them automatically adapt to being placed in a HStack or VStack depending on the parent that places them.

 First, add this new @Environment property to ResortView:

     @Environment(\.horizontalSizeClass) var sizeClass
 
 That will tell us whether we have a regular or compact size class. Very roughly:

 - All iPhones in portrait have compact width and regular height.
 
 - Most iPhones in landscape have compact width and compact height.
 
 - Large iPhones (Plus-sized and Max devices) in landscape have regular width and compact height.
 
 - All iPads in both orientations have regular width and regular height when your app is running with the full screen.
 
 Things get a little more complex for iPad when it comes to split view mode, which is when you have two apps running side by side – iOS will automatically downgrade our app to a compact size class at various points depending on the exact iPad model.

 Fortunately, to begin with all we care about are these two horizontal options: do we have lots of horizontal space (regular) or is space restricted (compact). If we have a regular amount of space, we’re going to keep the current HStack approach so that everything its neatly on one line, but if space is restricted we’ll ditch that and place each of the views into a VStack.

 So, find the HStack that contains ResortDetailsView and SkiDetailsView and replace it with this:

     HStack {
         if sizeClass == .compact {
             VStack(spacing: 10) { ResortDetailsView(resort: resort) }
             VStack(spacing: 10) { SkiDetailsView(resort: resort) }
         } else {
             ResortDetailsView(resort: resort)
             SkiDetailsView(resort: resort)
         }
     }
     .padding(.vertical)
     .background(Color.primary.opacity(0.1))
     
 As you can see, that uses two vertical stacks placed side by side, rather than just having all four views horizontal.

 Is it perfect? Well, no. Sure, there’s a lot more space in compact layouts, which means the user can use larger Dynamic Type sizes without running out of space, but many users won’t have that problem because they’ll be using the default size or even smaller sizes.

 To make this even better we can combine a check for the app’s current horizontal size class with a check for the user’s Dynamic Type setting so that we use the flat horizontal layout unless space really is tight – if the user has a compact size class and a larger Dynamic Type setting.

 First add another property to read the current Dynamic Type setting:

     @Environment(\.dynamicTypeSize) var typeSize
 
 Now modify the size class check to this:

 if sizeClass == .compact && typeSize > .large {
 
 Now finally our layout should look great in both orientations: one single line of text in a regular size class, and two rows of vertical stacks in a compact size class when an increased font size is used. It took a little work, but we got there in the end!

 Our solution didn’t result in code duplication, which is a huge win, but it also left our two child views in a better place – they are now there just to serve up their content without specifying a layout. So, parent views can dynamically switch between HStack and VStack whenever they want, and SwiftUI will take care of the layout for us.

 Before we’re done, I want to show you one useful extra technique: you can limit the range of Dynamic Type sizes supported by a particular view. For example, you might have worked hard to support as wide a range of sizes as possible, but found that anything larger than the “extra extra extra large” setting just looks bad. In that situation you can use the dynamicTypeSize() modifier on a view, like this:

 .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
 
 That’s a one-sided range, meaning that any size up to and including .xxxLarge is fine, but nothing larger. Obviously it’s best to avoid setting these limits where possible, but it’s not a problem if you use it judiciously – both TabView and NavigationView, for example, limit the size of their text labels so the UI doesn’t break.
 */

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var searchText = ""
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
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
            .searchable(text: $searchText, prompt: "Search for a resort")
            
            WelcomeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

