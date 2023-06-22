//
//  EditView.swift
//  SelectingAndEditingMapAnnotations
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
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
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
        }
    }
    
    /*
     That code won’t compile, because we have a conundrum: what initial values should we use for the name and description properties? Previously we’ve used @State with initial values, but we can’t do that here – their initial values should come from what location is being passed in, so the user sees the saved data.

     The solution is to create a new initializer that accepts a location, and uses that to create State structs using the location’s data. This uses the same underscore approach we used when creating a fetch request inside an initializer, which allows us to create an instance of the property wrapper not the data inside the wrapper.

     So, to solve our problem we need to add this initializer to EditView:
     */
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
}

/*
 You’ll need to modify your preview code to use that initializer, which we can just ignore the value in the closure for the preview:
 */
struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}


/*
 That makes the code compile, but we have a second problem: when we’re done editing the location, how can we pass the new location data back? We could use something like @Binding to pass in a remote value, but that creates problems with our optional in ContentView – we want EditView to be bound to a real value rather than an optional value, because otherwise it would get confusing.

 We’re going to take simplest solution we can: we’ll require a function to call where we can pass back whatever new location we want. This means any other SwiftUI can send us some data, and get back some new data to process however we want.

 Start by adding this property to EditView:

 var onSave: (Location) -> Void
 That asks for a function that accepts a single location and returns nothing, which is perfect for our usage. We need to accept that in our initializer, like this:

 init(location: Location, onSave: @escaping (Location) -> Void) {
     self.location = location
     self.onSave = onSave

     _name = State(initialValue: location.name)
     _description = State(initialValue: location.description)
 }
 Remember, @escaping means the function is being stashed away for user later on, rather than being called immediately, and it’s needed here because the onSave function will get called only when the user presses Save.

 Speaking of which, we need to update that Save button to create a new location with the modified details, and send it back with onSave():

 Button("Save") {
     var newLocation = location
     newLocation.name = name
     newLocation.description = description

     onSave(newLocation)
     dismiss()
 }
 By taking a variable copy of the original location, we get access to its existing data – it’s identifier, latitude, and longitude.

 Don’t forget to update your preview code too – just passing in a placeholder closure is fine here:

 EditView(location: Location.example) { newLocation in }
 That completes EditView for now, but there’s still some work to do back in ContentView because we need to present the new UI in our sheet, send in the location that was selected, and also handle updating changes.

 Well, thanks to the way we’ve built our code this only takes a handful of lines of code – place this into the sheet() modifier in ContentView:

 EditView(location: place) { newLocation in
     if let index = locations.firstIndex(of: place) {
         locations[index] = newLocation
     }
 }
 So, that passes the location into EditView, and also passes in a closure to run when the Save button is pressed. That accepts the new location, then looks up where the current location is and replaces it in the array. This will cause our map to update immediately with the new data.

 Go ahead and give the app a try – see if you spot a problem with our code. Hopefully it’s rather glaring: renaming doesn’t actually work!

 The problem here is that we told SwiftUI that two places were identical if their IDs were identical, and that isn’t true any more – when we update a marker so it has a different name, SwiftUI will compare the old marker and new one, see that their IDs are the same, and therefore not bother to change the map.

 The fix here is to make the id property mutable, like this:

 var id: UUID
 
 And now we can adjust that when we create new locations:

 var newLocation = location
 newLocation.id = UUID()
 newLocation.name = name
 newLocation.description = description
 
 There is no hard and fast rule for when it’s better to make a wholly new object from scratch, or just copy an existing one and change the bits you want like we’re doing here; I encourage you to experiment and find an approach you like.

 Anyway, with that you can now run your code again. Sure, it doesn’t save any data yet, but you can now add as many locations as you want and give them meaningful names.

 There is one last thing, though, and it’s entirely possible this might not exist in a future SwiftUI update so try it for yourself: right now I find that giving a location a short name such as “Home”, then changing it to have a long name such as “This is my home”, will cause its label to be clipped until you interact with the map.

 We can fix this with a new modifier called fixedSize(), which forces any view to be given its natural size rather than try to accommodate the amount of space offered by its parent. In this case, the MapAnnotation doesn’t do a great job of handling resizing children, which causes the clipping, but fixedSize() lets us bypass that so the text automatically grows into as much space as needed.

 So, to finish up this step please modify your map annotation content to this:

 Text(location.name)
     .fixedSize()
 
 It’s a small change, and again hopefully it will get resolved in a future SwiftUI release, but it solves our problem for now.
 */
