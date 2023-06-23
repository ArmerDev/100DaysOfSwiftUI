//
//  ContentView-ViewModel.swift
//  IntroducingMVVMIntoYourSwiftUIProject
//
//  Created by James Armer on 23/06/2023.
//

import MapKit
import Foundation

/*
 We’re going to start with three trivial things, then build our way up from there. First, create a new class that conforms to the ObservableObject protocol, so we’re able to report changes back to any SwiftUI view that’s watching

 Second, I want you to place that new class inside an extension on ContentView.
 
 That way we’re saying this isn’t just any view model, it’s the view model for ContentView. Later on it will be your job to add a second view model to handle EditView, so you can try seeing how the concepts map elsewhere.

 The final small change I’d like you to make is to add a new attribute, @MainActor, to the whole class, like this
 */

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var selectedPlace: Location?
        @Published private(set) var locations: [Location]
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
    }
}

/*
 The main actor is responsible for running all user interface updates, and adding that attribute to the class means we want all its code – any time it runs anything, unless we specifically ask otherwise – to run on that main actor. This is important because it’s responsible for making UI updates, and those must happen on the main actor. In practice this isn’t quite so easy, but we’ll come to that later on.

 Now, we’ve used ObservableObject classes before, but didn’t have @MainActor – how come they worked? Well, behind the scenes whenever we use @StateObject or @ObservedObject Swift was silently inferring the @MainActor attribute for us – it knows that both mean a SwiftUI view is relying on an external object to trigger its UI updates, and so it will make sure all the work automatically happens on the main actor without us asking for it.

 However, that doesn’t provide 100% safety. Yes, Swift will infer this when used from a SwiftUI view, but what if you access your class from somewhere else – from another class, for example? Then the code could run anywhere, which isn’t safe. So, by adding the @MainActor attribute here we’re taking a “belt and braces” approach: we’re telling Swift every part of this class should run on the main actor, so it’s safe to update the UI, no matter where it’s used.

 Now that we have our class in place, we get to choose which pieces of state from our view should be moved into the view model. Some people will tell you to move all of it, others will be more selective, and that’s okay – again, there is no single of what MVVM looks like, so I’m going to provide you with the tools and knowledge to experiment yourself.

 Let’s start with the easy stuff: move all three @State properties in ContentView over to its view model, switching @State private for just @Published – they can’t be private any more, because they explicitly need to be shared with ContentView:
 */


/*
 And now we can replace all those properties in ContentView with a single one:

 @StateObject private var viewModel = ViewModel()
 That will of course break a lot of code, but the fixes are easy – just add viewModel in various places. So, $mapRegion becomes $viewModel.mapRegion, locations becomes viewModel.locations, and so on.

 Once you’ve added that everywhere it’s needed your code will compile again, but you might wonder how this has helped – haven’t we just moved our code from one place to another? Well, yes, but there is an important distinction that will become clearer as your skills grow: having all this functionality in a separate class makes it much easier to write tests for your code.

 Views work best when they handle presentation of data, meaning that manipulation of data is a great candidate for code to move into a view model. With that in mind, if you have a look through your ContentView code you might notice two places our view does more work than it ought to: adding a new location and updating an existing location, both of which root around inside the internal data of our view model.

 Reading data from a view model’s properties is usually fine, but writing it isn’t because the whole point of this exercise is to separate logic from layout. You can find these two places immediately if we clamp down on writing view model data – modify the locations property in your view model to this:

 @Published private(set) var locations = [Location]()
 Now we’ve said that reading locations is fine, but only the class itself can write locations. Immediately Xcode will point out the two places where we need to get code out of the view: adding a new location, and updating an existing one.

 So, we can start by adding a new method to the view model to handle adding a new location:

 func addLocation() {
     let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
     locations.append(newLocation)
 }
 That can then be used from the + button in ContentView:

 Button {
     viewModel.addLocation()
 } label: {
     Image(systemName: "plus")
 }
 The second problematic place is updating a location, so I want you to cut that whole if let index check to your clipboard, then paste it into a new method in the view model, adding in a check that we have a selected place to work with:

 func update(location: Location) {
     guard let selectedPlace = selectedPlace else { return }

     if let index = locations.firstIndex(of: selectedPlace) {
         locations[index] = location
     }
 }
 Make sure and remove the two viewModel references from there – they aren’t needed any more.

 Now the EditView sheet in ContentView can just pass its data onto the view model:

 EditView(location: place) {
     viewModel.update(location: $0)
 }
 At this point the view model has taken over all aspects of ContentView, which is great: the view is there to present data, and the view model is there to manage data. The split isn’t always quite as clean as that, despite what you might hear elsewhere online, and again that’s okay – once you move into more advanced projects you’ll find that “one size fits all” approaches usually fit nobody, so we just do our best with what we have.

 Anyway, in this case now that we have our view model all set up, we can upgrade it to support loading and saving of data. This will look in the documents directory for a particular file, then use either JSONEncoder or JSONDecoder to convert it ready for use.

 Previously I showed you how to find our app’s documents directory with a reusable function, but here we’re going to package it up as an extension on FileManager for easier access in any project.

 Create a new Swift file called FileManager-DocumentsDirectory.swift, then give it this code:

 extension FileManager {
     static var documentsDirectory: URL {
         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         return paths[0]
     }
 }
 Now we can create a URL to a file in our documents directory wherever we want, however I don’t want to do that when both loading and saving files because it means if we ever change our save location we need to remember to update both places.

 So, a better idea is to add a new property to our view model to store the location we’re saving to:

 let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
 And with that in place we can create a new initializer and a new save() method that makes sure our data is saved automatically. Start by adding this to the view model:

 init() {
     do {
         let data = try Data(contentsOf: savePath)
         locations = try JSONDecoder().decode([Location].self, from: data)
     } catch {
         locations = []
     }
 }
 As for saving, previously I showed you how to write a string to disk, but the Data version is even better because it lets us do something quite amazing in just one line of code: we can ask iOS to ensure the file is written with encryption so that it can only be read once the user has unlocked their device. This is in addition to requesting atomic writes – iOS does almost all the work for us.

 Add this method to the view model now:

 func save() {
     do {
         let data = try JSONEncoder().encode(locations)
         try data.write(to: savePath, options: [.atomic, .completeFileProtection])
     } catch {
         print("Unable to save data.")
     }
 }
 Yes, all it takes to ensure that the file is stored with strong encryption is to add .completeFileProtection to the data writing options.

 Using this approach we can write any amount of data in any number of files – it’s much more flexible than UserDefaults, and also allows us to load and save data as needed rather than immediately when the app launches as with UserDefaults.

 Before we’re done with this step, we need to make a handful of small changes to our view model so that uses the code we just wrote.

 First, the locations array no longer needs to be initialized to an empty array, because that’s handled by the initializer. Change it to this:

 @Published private(set) var locations: [Location]
 And second, we need to call the save() method after adding a new location or after updating an existing one, so add save() to the end of both those methods.

 Go ahead and run the app now, and you should find that you can add items freely, then relaunch the app to see them restored just as they were.

 That took quite a bit of code in total, but the end result is that we have loading and saving done really well:

 All the logic is handled outside the view, so later on when you learn to write tests you’ll find the view model is much easier to work with.
 When we write data we’re making iOS encrypt it so the file can’t be read or written until the user unlocks their device.
 The load and save process is almost transparent – we added one modifier and changed another, and that’s all it took.
 Of course, our app isn’t truly secure yet: we’ve ensured our data file is saved out using encryption so that it can only be read once the device has been unlocked, but there’s nothing stopping someone else from reading the data afterwards.
 */
