//
//  EditView.swift
//  DownloadingDataFromWikipedia
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
    
    /*
     Those cover all the states we need to represent our network request.

     Next we’re going to add two properties to EditView: one to represent the loading state, and one to store an array of Wikipedia pages once the fetch has completed. So, add these two now:
     */
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    /*
     Before we tackle the network request itself, we have one last easy job to do: adding to our Form a new section to show pages if they have loaded, or status text views otherwise. We can put these if/else if conditions or a switch statement right into the Section and SwiftUI will figure it out.
     */
    
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
                                Text("Page description here")
                                    .italic()
                            }
                    case .loading:
                        Text("Loading...")
                    case .failed:
                        Text("Please try again later.")
                    }
                }
                
                /*
                 Tip: Notice how we can use + to add text views together? This lets us create larger text views that mix and match different kinds of formatting. That “Page description here” is just temporary – we’ll replace it soon.

                 Now for the part that really brings all this together: we need to fetch some data from Wikipedia, decode it into a Result, assign its pages to our pages property, then set loadingState to .loaded. If the fetch fails, we’ll set loadingState to .failed, and SwiftUI will load the appropriate UI.
                 */
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
            
            // we got some data back!
            let items = try JSONDecoder().decode(Result.self, from: data)
            
            // success - convert the array values to our pages array
            pages = items.query.pages.values.sorted { $0.title < $1.title }
            loadingState = .loaded
        } catch {
            // if we're still here it means the request failed somehow
            loadingState = .failed
        }
    }
    
    /*
     That request should begin as soon as the view appears, so add this task() modifier after the existing toolbar() modifier:
     */
}

/*
 Now go ahead and run the app again – you’ll find that as you drop a pin our EditView screen will slide up and show you all the places nearby. Nice!
 */

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
