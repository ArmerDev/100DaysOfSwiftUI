//
//  EditView.swift
//  SortingWikipediaResults
//
//  Created by James Armer on 22/06/2023.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    var onSave: (Location) -> Void
    
    @State private var name: String
    @State private var description: String
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section("Nearby...") {
                    switch loadingState {
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .loading:
                        Text("Loading...")
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
    func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let items = try JSONDecoder().decode(Result.self, from: data)

            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {

            loadingState = .failed
        }
    }
}

/*
 Before we’re done with this screen, we need to replace the Text("Page description here") view with something real. Wikipedia’s JSON data does contain a description, but it’s buried: the terms dictionary might not be there, and if it is there it might not have a description key, and if it has a description key it might be an empty array rather than an array with some text inside.

 We don’t want this mess to plague our SwiftUI code, so again the best thing to do is make a computed property that returns the description if it exists, or a fixed string otherwise. Add this to the Page struct to finish it off:

 var description: String {
     terms?["description"]?.first ?? "No further information"
 }
 With that done you can replace Text("Page description here") with this:

 Text(page.description)
 That completes EditView – it lets us edit the two properties of our annotation views, it downloads and sorts data from Wikipedia, it shows different UI depending on how the network request is going, and it even carefully looks through the Wikipedia content to decide what can be shown.
 */


struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
