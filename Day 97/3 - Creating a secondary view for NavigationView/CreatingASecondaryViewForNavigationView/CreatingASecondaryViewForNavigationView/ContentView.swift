//
//  ContentView.swift
//  CreatingASecondaryViewForNavigationView
//
//  Created by James Armer on 17/07/2023.
//

import SwiftUI

/*
 Right now our NavigationLink directs the user to some sample text, which is fine for prototyping but obviously not good enough for our actual project. We’re going to replace that with a new ResortView that shows a picture from the resort, some description text, and a list of facilities.

 Important: Like I said earlier, the content in my example JSON is mostly fictional, and this includes the photos – these are just generic ski photos taken from Unsplash. Unsplash photos can be used commercially or non-commercially without attribution, but I’ve included the photo credit in the JSON so you can add it later on. As for the text, this is taken from Wikipedia. If you intend to use the text in your own shipping projects, it’s important you give credit to Wikipedia and its authors and make it clear that the work is licensed under CC-BY-SA available from here: https://creativecommons.org/licenses/by-sa/3.0.

 To start with, our ResortView layout is going to be pretty simple – not much more than a scroll view, a VStack, an Image, and some Text. The only interesting part is that we’re going to show the resort’s facilities as a single text view using resort.facilities.joined(separator: ", ") to get a single string.

 Create a new SwiftUI view called ResortView, and give it this code to start with:
 */

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    var body: some View {
        NavigationView {
            List(resorts) { resort in
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
            
            WelcomeView()
        }
    }
}

/*
 There’s nothing terribly interesting in our code so far, but that’s going to change now because I want to add more details to this screen – how big the resort is, roughly how much it costs, how high it is, and how deep the snow is.

 We could just put all that into a single HStack in ResortView, but that restricts what we can do in the future. So instead we’re going to group them into two views: one for resort information (price and size) and one for ski information (elevation and snow depth).

 The ski view is the easier of the two to implement, so we’ll start there: create a new SwiftUI view called SkiDetailsView and give it this code:
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
