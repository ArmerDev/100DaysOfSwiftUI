//
//  ContentView.swift
//  BuildingAPrimaryListOfItems
//
//  Created by James Armer on 17/07/2023.
//

import SwiftUI

/*
 In this app we’re going to display two views side by side, just like Apple’s Mail and Notes apps. In SwiftUI this is done by placing two views into a NavigationView, then using a NavigationLink in the primary view to control what’s visible in the secondary view.

 So, we’re going to start off our project by building the primary view for our app, which will show a list of all ski resorts, along with which country they are from and how many ski runs it has – how many pistes you can ski down, sometimes called “trails” or just “slopes”.

 I’ve provided some assets for this project in the GitHub repository for this book, so if you haven’t already downloaded them please do so now. You should drag resorts.json into your project navigator, then copy all the pictures into your asset catalog. You might notice that I’ve included 2x and 3x images for the countries, but only 2x pictures for the resorts. This is intentional: those flags are going to be used for both retina and Super Retina devices, but the resort pictures are designed to fill all the space on an iPad Pro – they are more than big enough for a Super Retina iPhone even at 2x resolution.

 To get our list up and running quickly, we need to define a simple Resort struct that can be loaded from our JSON. That means it needs to conform to Codable, but to make it easier to use in SwiftUI we’ll also make it conform to Identifiable. The actual data itself is mostly just strings and integers, but there’s also a string array called facilities that describe what else there is on the resort – I should add that this data is mostly fictional, so don’t try to use it in a real app!

 Create a new Swift file called Resort.swift, then navigate to that file and update its code.
 (Notes continue in Resort.swift)
 */



/*
 For the body of our view, we’re going to use a NavigationView with a List inside it, showing all our resorts. In each row we’re going to show:

 - A 40x25 flag of which country the resort is in.
 
 - The name of the resort.
 
 - How many runs it has.
 
 40x25 is smaller than our flag source image, and also a different aspect ratio, but we can fix that by using resizable(), scaledToFill(), and a custom frame. To make it look a little better on the screen, we’ll use a custom clip shape and a stroked overlay.

 When the row is tapped we’re going to push to a detail view showing more information about the resort, but we haven’t built that yet so instead we’ll just push to a temporary text view as a placeholder.

 Replace your current body property with this:
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
        }
    }
}

/*
 Go ahead and run the app now and you should see it looks good enough, but if you rotate your iPhone to landscape you might see the screen is almost blank depending on which device you’re using – an iPhone 13 Pro Max will be almost empty, whereas a regular iPhone 13 Pro won’t.

 This happens because SwiftUI wants to show a detail view there, but we haven’t created one yet – let’s fix that next.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
