//
//  DataController.swift
//  HowToCombineCoreDataAndSwiftUI
//
//  Created by James Armer on 03/06/2023.
//

import CoreData
import Foundation

/*
 We’re going to start by creating a new class called DataController, making it conform to ObservableObject so that we can use it with the @StateObject property wrapper – we want to create one of these when our app launches, then keep it alive for as long as our app runs.

 Inside this class we’ll add a single property of the type NSPersistentContainer, which is the Core Data type responsible for loading a data model and giving us access to the data inside. From a modern point of view this sounds strange, but the “NS” part is short for “NeXTSTEP”, which was a huge operating system that Apple acquired when they brought Steve Jobs back into the fold in 1997 – Core Data has some really old foundations!

 Anyway, start by adding this to your file:
 */

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Bookworm")
    
    /*
     That tells Core Data we want to use the Bookworm data model. It doesn’t actually load it – we’ll do that in a moment – but it does prepare Core Data to load it. Data models don’t contain our actual data, just the definitions of properties and attributes like we defined a moment ago.

     To actually load the data model we need to call loadPersistentStores() on our container, which tells Core Data to access our saved data according to the data model in Bookworm.xcdatamodeld. This doesn’t load all the data into memory at the same time, because that would be wasteful, but at least Core Data can see all the information we have.

     It’s entirely possible that loading the saved data might go wrong, maybe the data is corrupt, for example. But honestly if it does go wrong there’s not a great deal you can do – the only meaningful thing you can do at this point is show an error message to the user, and hope that relaunching the app clears up the problem.

     Anyway, we’re going to write a small initializer for DataController that loads our stored data immediately. If things go wrong – unlikely, but not impossible – we’ll print a message to the Xcode debug log.

     Add this initializer to DataController now:
     */
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

/*
 That completes DataController, so the final step is to create an instance of DataController and send it into SwiftUI’s environment. You’ve already met @Environment when it came to asking SwiftUI to dismiss our view, but it also stores other useful data such as our time zone, user interface appearance, and more.

 This is relevant to Core Data because most apps work with only one Core Data store at a time, so rather than every view trying to create their own store individually we instead create it once when our app starts, then store it inside the SwiftUI environment so everywhere else in our app can use it.

 To do this, open BookwormApp.swift, and add this property this to the struct:

 @StateObject private var dataController = DataController()
 That creates our data controller, and now we can place it into SwiftUI’s environment by adding a new modifier to the ContentView() line:

 WindowGroup {
     ContentView()
         .environment(\.managedObjectContext, dataController.container.viewContext)
 }
 Tip: If you’re using Xcode’s SwiftUI previews, you should also inject a managed object context into your preview struct for ContentView.
 
 - Comment contiunes in HowToCombineCoreDataAndSwiftUI file...
 */
