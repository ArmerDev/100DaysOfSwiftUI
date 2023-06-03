//
//  HowToCombineCoreDataAndSwiftUIApp.swift
//  HowToCombineCoreDataAndSwiftUI
//
//  Created by James Armer on 03/06/2023.
//

import SwiftUI

@main
struct HowToCombineCoreDataAndSwiftUIApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

/*
 You’ve already met data models, which store definitions of the entities and attributes we want to use, and NSPersistentStoreContainer, which handles loading the actual data we have saved to the user’s device. Well, you just met the third piece of the Core Data puzzle: managed object contexts. These are effectively the “live” version of your data – when you load objects and change them, those changes only exist in memory until you specifically save them back to the persistent store.

 So, the job of the view context is to let us work with all our data in memory, which is much faster than constantly reading and writing data to disk. When we’re ready we still do need to write changes out to persistent store if we want them to be there when our app runs next, but you can also choose to discard changes if you don’t want them.

 At this point we’ve created our Core Data model, we’ve loaded it, and we’ve prepared it for use with SwiftUI. There are still two important pieces of the puzzle left: reading data, and writing it too.

 Retrieving information from Core Data is done using a fetch request – we describe what we want, how it should sorted, and whether any filters should be used, and Core Data sends back all the matching data. We need to make sure that this fetch request stays up to date over time, so that as students are created or removed our UI stays synchronized.

 SwiftUI has a solution for this, and – you guessed it – it’s another property wrapper. This time it’s called @FetchRequest and it takes at least one parameter describing how we want the results to be sorted. It has quite a specific format, so let’s start by adding a fetch request for our students – please add this property to ContentView now:

 @FetchRequest(sortDescriptors: []) var students: FetchedResults<Student>
 Broken down, that creates a fetch request with no sorting, and places it into a property called students that has the the type FetchedResults<Student>.

 From there, we can start using students like a regular Swift array, but there’s one catch as you’ll see. First, some code that puts the array into a List:

 VStack {
     List(students) { student in
         Text(student.name ?? "Unknown")
     }
 }
 
 
 - comment continues in ContentView...
 */
