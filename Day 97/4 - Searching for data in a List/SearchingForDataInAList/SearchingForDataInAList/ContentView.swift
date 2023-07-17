//
//  ContentView.swift
//  SearchingForDataInAList
//
//  Created by James Armer on 17/07/2023.
//

import SwiftUI

/*
 Before our List view is done, we’re going to add a SwiftUI modifier that makes our user’s experience a whole lot better without too much work: searchable(). Adding this will allow users to filter the list of resorts we’re showing, making it easy to find the exact thing they’re looking for.

 This takes only four steps, starting with a new @State property in ContentView to store the text the user is searching for:
 */

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var searchText = ""
    
    /*
     Second, we can bind that to our List in ContentView by adding this directly below the existing navigationTitle() modifier:
     
     Third, we need a computed property that will handle the filtering of our data. If our new searchText property is empty then we can just send back all the resorts we loaded, otherwise we’ll use localizedCaseInsensitiveContains() to filter the array based on their search criteria:
     
     And the final step is to use filteredResorts as the data source for our list, like this:
        
         List(filteredResorts) { resort in
     
     And with that we’re done! If you run the app again you’ll see you can drag the resort list gently down to see the search box, and entering something in there will filter the list straight away. Honestly, searchable() is one of the biggest “bang for buck” features in SwiftUI – it’s such an important feature for users, and took us only a few minutes to implement!
     */
    
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
