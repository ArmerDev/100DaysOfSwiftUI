//
//  ContentView.swift
//  HowToCombineCoreDataAndSwiftUI
//
//  Created by James Armer on 03/06/2023.
//

import SwiftUI

/*
 SwiftUI and Core Data were introduced almost exactly a decade apart – SwiftUI with iOS 13, and Core Data with iPhoneOS 3; so long ago it wasn’t even called iOS because the iPad wasn’t released yet. Despite their distance in time, Apple put in a ton of work to make sure these two powerhouse technologies work beautifully alongside each other, meaning that Core Data integrates into SwiftUI as if it were always designed that way.

 First, the basics: Core Data is an object graph and persistence framework, which is a fancy way of saying it lets us define objects and properties of those objects, then lets us read and write them from permanent storage.

 On the surface this sounds like using Codable and UserDefaults, but it’s much more advanced than that: Core Data is capable of sorting and filtering of our data, and can work with much larger data – there’s effectively no limit to how much data it can store. Even better, Core Data implements all sorts of more advanced functionality for when you really need to lean on it: data validation, lazy loading of data, undo and redo, and much more.

 In this project we’re going to be using only a small amount of Core Data’s power, but that will expand soon enough – I just want to give you a taste of it at first.

 When you created your Xcode project I asked you to not check the Use Core Data box, because although it gets some of the boring set up code out of the way it also adds a whole bunch of extra example code that is just pointless and just needs to be deleted.

 So, instead you’re going to learn how to set up Core Data by hand. It takes three steps, starting with us defining the data we want to use in our app.

 Previously we described data like this:

 struct Student {
     var id: UUID
     var name: String
 }
 However, Core Data doesn’t work like that. You see, Core Data needs to know ahead of time what all our data types look like, what it contains, and how it relates to each other.

 This is all contained in a new file type called Data Model, which has the file extension “xcdatamodeld”. Let’s create one now: press Cmd+N to make a new file, select Data Model from the list of templates, then name your model Bookworm.xcdatamodeld.

 When you press Create, Xcode will open the new file in its data model editor. Here we define our types as “entities”, then create properties in there as “attributes” – Core Data is responsible for converting that into an actual database layout it can work with at runtime.

 For trial purposes, please press the Add Entity button to create a new entity, then double click on its name to rename it “Student”. Next, click the + button directly below the Attributes table to add two attributes: “id” as a UUID and “name” as a string.

 That tells Core Data everything we need to know to create students and save them, so we can proceed to the second step of setting up Core Data: writing a little Swift code to load that model and prepare it for us to use.

 We’re going to write this in a few small pieces, so I can explain what’s happening in detail. First, create a new Swift file called DataController.swift, and add this just above its import Foundation line:

 import CoreData
 
 
 - Comments continue in DataController file...
 */

//struct Student {
//    var id: UUID
//    var name: String
//}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var students: FetchedResults<Student>
    
    var body: some View {
        VStack {
            List(students) { student in
                Text(student.name ?? "Unknown")
            }
            
            Button("Add") {
                let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
                let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]
                
                let chosenFirstName = firstNames.randomElement()!
                let chosenLastName = lastNames.randomElement()!
                
                let student = Student(context: moc)
                student.id = UUID()
                student.name = "\(chosenFirstName) \(chosenLastName)"
                
                
                try? moc.save()
            }
        }
    }
}

/*
 Did you spot the catch? Yes, student.name is an optional – it might have a value or it might not. This is one area of Core Data that will annoy you greatly: it has the concept of optional data, but it’s an entirely different concept to Swift’s optionals. If we say to Core Data “this thing can’t be optional” (which you can do inside the model editor), it will still generate optional Swift properties, because all Core Data cares about is that the properties have values when they are saved – they can be nil at other times.

 You can run the code if you want to, but there isn’t really much point – the list will be empty because we haven’t added any data yet, so our database is empty. To fix that we’re going to create a button below our list that adds a new random student every time it’s tapped, but first we need a new property to access the managed object context we created earlier.

 Let me back up a little, because this matters. When we defined the “Student” entity, what actually happened was that Core Data created a class for us that inherits from one of its own classes: NSManagedObject. We can’t see this class in our code, because it’s generated automatically when we build our project, just like Core ML’s models. These objects are called managed because Core Data is looking after them: it loads them from the persistent container and writes their changes back too.

 All our managed objects live inside a managed object context, one of which we created earlier. Placing it into the SwiftUI environment meant that it was automatically used for the @FetchRequest property wrapper – it uses whatever managed object context is available in the environment.

 Anyway, when it comes to adding and saving objects, we need access to the managed object context that it is in SwiftUI’s environment. This is another use for the @Environment property wrapper – we can ask it for the current managed object context, and assign it to a property for our use.

 So, add this property to ContentView now:

 @Environment(\.managedObjectContext) var moc
 With that in place, the next step is add a button that generates random students and saves them in the managed object context. To help the students stand out, we’ll assign random names by creating firstNames and lastNames arrays, then using randomElement() to pick one of each.

 Start by adding this button just below the List:

 Button("Add") {
     let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
     let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]

     let chosenFirstName = firstNames.randomElement()!
     let chosenLastName = lastNames.randomElement()!

     // more code to come
 }
 Note: Inevitably there are people that will complain about me force unwrapping those calls to randomElement(), but we literally just hand-created the arrays to have values – it will always succeed. If you desperately hate force unwraps, perhaps replace them with nil coalescing and default values.

 Now for the interesting part: we’re going to create a Student object, using the class Core Data generated for us. This needs to be attached to a managed object context, so the object knows where it should be stored. We can then assign values to it just like we normally would for a struct.

 So, add these three lines to the button’s action closure now:

 let student = Student(context: moc)
 student.id = UUID()
 student.name = "\(chosenFirstName) \(chosenLastName)"
 Finally we need to ask our managed object context to save itself, which means it will write its changes to the persistent store. This is a throwing function call, because in theory it might fail. In practice, nothing about what we’ve done has any chance of failing, so we can call this using try? – we don’t care about catching errors.

 So, add this final line to the button’s action:

 try? moc.save()
 At last, you should now be able to run the app and try it out – click the Add button a few times to generate some random students, and you should see them slide somewhere into our list. Even better, if you relaunch the app you’ll find your students are still there, because Core Data saved them.

 Now, you might think this was an awful lot of learning for not a lot of result, but you now know what persistent stores and managed object contexts are, what entities and attributes are, what managed objects and fetch requests are, and you’ve seen how to save changes too. We’ll be looking at Core Data more later on in this project, as well in the future, but for now you’ve come far.

 This was the last part of the overview for this project, but this time I don’t want you to reset your project fully. Yes, put ContentView.swift back to its original state, then delete the Student entity from Bookworm.xcdatamodeld, but please leave BookwormApp.swift and DataController.swift alone – we’ll be using them in the real project!
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
