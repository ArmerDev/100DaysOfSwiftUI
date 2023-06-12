//
//  ContentView.swift
//  DynamicallyFiltering@FetchRequestWithSwiftUI
//
//  Created by James Armer on 12/06/2023.
//

import SwiftUI
import CoreData

/*
 One of the SwiftUI questions I’ve been asked more than any other is this: how can I dynamically change a Core Data @FetchRequest to use a different predicate or sort order? The question arises because fetch requests are created as a property, so if you try to make them reference another property Swift will refuse.

 There is a simple solution here, and it is usually pretty obvious in retrospect because it’s exactly how everything else works: we should carve off the functionality we want into a separate view, then inject values into it.

 I want to demonstrate this with some real code, so I’ve put together the simplest possible example: it adds three singers to Core Data, then uses two buttons to show either singers whose last name ends in A or S.

 Start by creating a new Core Data entity called Singer and give it two string attributes: “firstName” and “lastName”. Use the data model inspector to change its Codegen to Manual/None, then go to the Editor menu and select Create NSManagedObject Subclass so we can get a Singer class we can customize.

 Once Xcode has generated files for us, open Singer+CoreDataProperties.swift and add these two properties that make the class easier to use with SwiftUI (wrappedFirstName and wrappedLastName).
 */

/*
 OK, now onto the real work.

 The first step is to design a view that will host our information. Like I said, this is also going to have two buttons that lets us change the way the view is filtered, and we’re going to have an extra button to insert some testing data so you can see how it works.

 First, add two properties to your ContentView struct so that we have a managed object context we can save objects to, and some state we can use as a filter:

 @Environment(\.managedObjectContext) var moc
 @State private var lastNameFilter = "A"
 For the body of the view, we’re going to use a VStack with three buttons, plus a comment for where we want the List to show matching singers:

 VStack {
     // list of matching singers

     Button("Add Examples") {
         let taylor = Singer(context: moc)
         taylor.firstName = "Taylor"
         taylor.lastName = "Swift"

         let ed = Singer(context: moc)
         ed.firstName = "Ed"
         ed.lastName = "Sheeran"

         let adele = Singer(context: moc)
         adele.firstName = "Adele"
         adele.lastName = "Adkins"

         try? moc.save()
     }

     Button("Show A") {
         lastNameFilter = "A"
     }

     Button("Show S") {
         lastNameFilter = "S"
     }
 }
 So far, so easy. Now for the interesting part: we need to replace that // list of matching singers comment with something real. This isn’t going to use @FetchRequest because we want to be able to create a custom fetch request inside an initializer, but the code we’ll be using instead is almost identical.

 Create a new SwiftUI view called “FilteredList”, and give it this property:

 @FetchRequest var fetchRequest: FetchedResults<Singer>
 That will store our fetch request, so that we can loop over it inside the body. However, we don’t create the fetch request here, because we still don’t know what we’re searching for. Instead, we’re going to create a custom initializer that accepts a filter string and uses that to set the fetchRequest property.

 Add this initializer now:

 init(filter: String) {
     _fetchRequest = FetchRequest<Singer>(sortDescriptors: [], predicate: NSPredicate(format: "lastName BEGINSWITH %@", filter))
 }
 That will run a fetch request using the current managed object context. Because this view will be used inside ContentView, we don’t even need to inject a managed object context into the environment – it will inherit the context from ContentView.

 Did you notice how there’s an underscore at the start of _fetchRequest? That’s intentional. You see, we’re not writing to the fetched results object inside our fetch request, but instead writing a wholly new fetch request.

 To understand this, think about the @State property wrapper. Behind this scenes this is implemented as a struct called State, which contains whatever value we put inside – an integer, for example. If we have an @State property called score and assign the value 10 to it, we mean to put 10 into the integer inside the State property wrapper. However, we can also assign a value to _score – we can write a wholly new State struct in there, if needed.

 So, by assigning to _fetchRequest, we aren’t trying to say “here’s a whole bunch of new results we want you to use,” but instead we’re telling Swift we want to change the whole fetch request itself.

 All that remains is to write the body of the view, so give the view this body:

 var body: some View {
     List(fetchRequest, id: \.self) { singer in
         Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
     }
 }
 As for the preview struct for FilteredList, you can remove it safely.

 Now that the view is complete, we can return to ContentView and replace the comment with some actual code that passes our filter into FilteredList:

 FilteredList(filter: lastNameFilter)
 Now run the program to give it a try: tap the Add Examples button first to create three singer objects, then tap either “Show A” or “Show S” to toggle between surname letters. You should see our List dynamically update with different data, depending on which button you press.

 So, it took a little new knowledge to make this work, but it really wasn’t that hard – as long as you think like SwiftUI, the solution is right there.

 Tip: You might look at our code and think that every time the view is recreated – which is every time any state changes in our container view – we’re also recreating the fetch request, which in turn means reading from the database when nothing else has changed.

 That might seem terribly wasteful, and it would be terribly wasteful if it actually happened. Fortunately, Core Data won’t do anything like this: it will only actually re-run the database query when the filter string changes, even if the view is recreated.
 */

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var lastNameFilter = "A"
    
    var body: some View {
        VStack {
            FilteredList(filter: lastNameFilter)
            
            Button("Add Examples") {
                let taylor = Singer(context: moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"
                
                let ed = Singer(context: moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"
                
                let adele = Singer(context: moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"
                
                try? moc.save()
            }
            
            Button("Show A") {
                lastNameFilter = "A"
            }
            
            Button("Show S") {
                lastNameFilter = "S"
            }
        }
    }
}

/*
 Want to go further?
 
 For more flexibility, we could improve our FilteredList view so that it works with any kind of entity, and can filter on any field. To make this work properly, we need to make a few changes:

 Rather than specifically referencing the Singer class, we’re going to use generics with a constraint that whatever is passed in must be an NSManagedObject.
 We need to accept a second parameter to decide which key name we want to filter on, because we might be using an entity that doesn’t have a lastName attribute.
 Because we don’t know ahead of time what each entity will contain, we’re going to let our containing view decide. So, rather than just using a text view of a singer’s name, we’re instead going to ask for a closure that can be run to configure the view however they want.
 There are two complex parts in there. The first is the closure that decides the content of each list row, because it needs to use two important pieces of syntax. We looked at these towards the end of our earlier technique project on views and modifiers, but if you missed them:

 @ViewBuilder lets our containing view (whatever is using the list) send in multiple views if they want.
 @escaping says the closure will be stored away and used later, which means Swift needs to take care of its memory.
 The second complex part is how we let our container view customize the search key. Previously we controlled the filter value like this:

 NSPredicate(format: "lastName BEGINSWITH %@", filter)
 So you might take an educated guess and write code like this:

 NSPredicate(format: "%@ BEGINSWITH %@", keyName, filter)
 However, that won’t work. You see, when we write %@ Core Data automatically inserts quote marks for us so that the predicate reads correctly. This is helpful, because if our string contains quote marks it will automatically make sure they don’t clash with the quote marks it adds.

 This means when we use %@ for the attribute name we might end up with a predicate like this:

 NSPredicate(format: "'lastName' BEGINSWITH 'S'")
 And that’s not correct: the attribute name should not be in quote marks.

 To resolve this, NSPredicate has a special symbol that can be used to replace attribute names: %K, for “key”. This will insert values we provide, but won’t add quote marks around them. The correct predicate is this:

 NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue)
 So, add an import for CoreData so we can reference NSManagedObject, then replace your current FilteredList struct with this:

 struct FilteredList<T: NSManagedObject, Content: View>: View {
     @FetchRequest var fetchRequest: FetchedResults<T>

     // this is our content closure; we'll call this once for each item in the list
     let content: (T) -> Content

     var body: some View {
         List(fetchRequest, id: \.self) { singer in
             self.content(singer)
         }
     }

     init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
         _fetchRequest = FetchRequest<T>(sortDescriptors: [], predicate: NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue))
         self.content = content
     }
 }
 We can now use that new filtered list by upgrading ContentView like this:

 FilteredList(filterKey: "lastName", filterValue: lastNameFilter) { (singer: Singer) in
     Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
 }
 Notice how I’ve specifically used (singer: Singer) as the closure’s parameter – this is required so that Swift understands how FilteredList is being used. Remember, we said it could be any type of NSManagedObject, but in order for Swift to know exactly what type of managed object it is we need to be explicit.

 Anyway, with that change in place we now use our list with any kind of filter key and any kind of entity – it’s much more useful!
 */


struct ContentView2: View {
    @Environment(\.managedObjectContext) var moc
    @State private var lastNameFilter = "A"
    
    var body: some View {
        VStack {
            AlternativeFilteredList(filterKey: "lastName", filterValue: lastNameFilter) { (singer: Singer) in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }
            
            Button("Add Examples") {
                let taylor = Singer(context: moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"
                
                let ed = Singer(context: moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"
                
                let adele = Singer(context: moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"
                
                try? moc.save()
            }
            
            Button("Show A") {
                lastNameFilter = "A"
            }
            
            Button("Show S") {
                lastNameFilter = "S"
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController()
    
    static var previews: some View {
        Group{
            ContentView()
            ContentView2()
                .previewDisplayName("ContentView 2")
        }
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
