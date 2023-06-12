//
//  ContentView.swift
//  OneToManyRelationshipsWithCoreDataSwiftUIAnd@FetchRequest
//
//  Created by James Armer on 12/06/2023.
//

import SwiftUI

/*
 Core Data allows us to link entities together using relationships, and when we use @FetchRequest Core Data sends all that data back to us for use. However, this is one area where Core Data shows its age a little: to get relationships to work well we need to make a custom NSManagedObject subclass that providers wrappers that are more friendly to SwiftUI.

 To demonstrate this, we’re going to build two Core Data entities: one to track candy bars, and one to track countries where those bars come from.

 Relationships come in four forms:

 A one to one relationship means that one object in an entity links to exactly one object in another entity. In our example, this would mean that each type of candy has one country of origin, and each country could make only one type of candy.
 A one to many relationship means that one object in an entity links to many objects in another entity. In our example, this would mean that one type of candy could have been introduced simultaneously in many countries, but that each country still could only make one type of candy.
 A many to one relationship means that many objects in an entity link to one object in another entity. In our example, this would mean that each type of candy has one country of origin, and that each country can make many types of candy.
 A many to many relationship means that many objects in an entity link to many objects in another entity. In our example, this would mean that one type of candy had been introduced simultaneously in many countries, and each country can make many types of candy.
 All of those are used at different times, but in our candy example the many to one relationship makes the most sense – each type of candy was invented in a single country, but each country can have invented many types of candy.

 So, open your data model and add two entities: Candy, with a string attribute called “name”, and Country, with string attributes called “fullName” and “shortName”. Although some types of candy have the same name – see “Smarties” in the US and the UK – countries are definitely unique, so please add a constraint for “shortName”.

 Tip: Don’t worry if you’ve forgotten how to add constraints: select the Country entity, go to the View menu and choose Inspectors > Data Model, click the + button under Constraints, and rename the example to “shortName”.

 Before we’re done with this data model, we need to tell Core Data there’s a one-to-many relationship between Candy and Country:

 With Country selected, press + under the Relationships table. Call the relationship “candy”, change its destination to Candy, then over in the data model inspector change Type to To Many.
 Now select Candy, and add another relationship there. Call the relationship “origin”, change its destination to “Country”, then set its inverse to “candy” so Core Data understands the link goes both ways.
 That completes our entities, the next step is to take a look at the code Xcode generates for us. Remember to press Cmd+S to force Xcode to save your changes.

 Select both Candy and Country and set their Codegen to Manual/None, then go to the Editor menu and choose Create NSManagedObject Subclass to create code for both our entities – remember to save them in the CoreDataProject group and folder.

 As we chose two entities, Xcode will generate four Swift files for us. Candy+CoreDataProperties.swift will be pretty much exactly what you expect, although notice how origin is now a Country. Country+CoreDataProperties.swift is more complex, because Xcode also generated some methods for us to use.

 Previously we looked at how to clean up Core Data’s optionals using NSManagedObject subclasses, but here there’s a bonus complexity: the Country class has a candy property that is an NSSet. This is the older, Objective-C data type that is equivalent to Swift’s Set, but we can’t use it with SwiftUI’s ForEach.

 To fix this we need to modify the files Xcode generated for us, adding convenience wrappers that make SwiftUI work well. For the Candy class this is as easy as just wrapping the name property so that it always returns a string:

 public var wrappedName: String {
     name ?? "Unknown Candy"
 }
 For the Country class we can create the same string wrappers around shortName and fullName, like this:

 public var wrappedShortName: String {
     shortName ?? "Unknown Country"
 }

 public var wrappedFullName: String {
     fullName ?? "Unknown Country"
 }
 However, things are more complicated when it comes to candy. This is an NSSet, which could contain anything at all, because Core Data hasn’t restricted it to just instances of Candy.

 So, to get this thing into a useful form for SwiftUI we need to:

 Convert it from an NSSet to a Set<Candy> – a Swift-native type where we know the types of its contents.
 Convert that Set<Candy> into an array, so that ForEach can read individual values from there.
 Sort that array, so the candy bars come in a sensible order.
 Swift actually lets us perform steps 2 and 3 in one, because sorting a set automatically returns an array. However, sorting the array is harder than you might think: this is an array of custom types, so we can’t just use sorted() and let Swift figure it out. Instead, we need to provide a closure that accepts two candy bars and returns true if the first candy should be sorted before the second.

 So, please add this computed property to Country now:

 public var candyArray: [Candy] {
     let set = candy as? Set<Candy> ?? []
     return set.sorted {
         $0.wrappedName < $1.wrappedName
     }
 }
 That completes our Core Data classes, so now we can write some SwiftUI code to make all this work.

 Open ContentView.swift and give it these two properties:

 @Environment(\.managedObjectContext) var moc
 @FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>
 Notice how we don’t need to specify anything about the relationships in our fetch request – Core Data understands the entities are linked, so it will just fetch them all as needed.

 As for the body of the view, we’re going to use a List with two ForEach views inside it: one to create a section for each country, and one to create the candy inside each country. This List will in turn go inside a VStack so we can add a button below to generate some sample data:

 VStack {
     List {
         ForEach(countries, id: \.self) { country in
             Section(country.wrappedFullName) {
                 ForEach(country.candyArray, id: \.self) { candy in
                     Text(candy.wrappedName)
                 }
             }
         }
     }

     Button("Add") {
         let candy1 = Candy(context: moc)
         candy1.name = "Mars"
         candy1.origin = Country(context: moc)
         candy1.origin?.shortName = "UK"
         candy1.origin?.fullName = "United Kingdom"

         let candy2 = Candy(context: moc)
         candy2.name = "KitKat"
         candy2.origin = Country(context: moc)
         candy2.origin?.shortName = "UK"
         candy2.origin?.fullName = "United Kingdom"

         let candy3 = Candy(context: moc)
         candy3.name = "Twix"
         candy3.origin = Country(context: moc)
         candy3.origin?.shortName = "UK"
         candy3.origin?.fullName = "United Kingdom"

         let candy4 = Candy(context: moc)
         candy4.name = "Toblerone"
         candy4.origin = Country(context: moc)
         candy4.origin?.shortName = "CH"
         candy4.origin?.fullName = "Switzerland"

         try? moc.save()
     }
 }
 Make sure you run that code, because it works really well – all our candy bars are automatically sorted into sections when the Add button is tapped. Even better, because we did all the heavy lifting inside our NSManagedObject subclasses, the resulting SwiftUI code is actually remarkably straightforward – it has no idea that an NSSet is behind the scenes, and is much easier to understand as a result.

 Tip: If you don’t see your candy bars sorted into sections after pressing Add, make sure you haven’t removed the mergePolicy change from the DataController class. As a reminder, it should set to NSMergePolicy.mergeByPropertyObjectTrump.
 */

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>
    
    var body: some View {
        VStack {
            List {
                ForEach(countries, id: \.self) { country in
                    Section(country.wrappedFullName) {
                        ForEach(country.candyArray, id: \.self) { candy in
                            Text(candy.wrappedName)
                        }
                    }
                }
            }
            
            Button("Add Candy") {
                let candy1 = Candy(context: moc)
                candy1.name = "Mars"
                candy1.origin = Country(context: moc)
                candy1.origin?.shortName = "UK"
                candy1.origin?.fullName = "United Kingdom"
                
                let candy2 = Candy(context: moc)
                candy2.name = "KitKat"
                candy2.origin = Country(context: moc)
                candy2.origin?.shortName = "UK"
                candy2.origin?.fullName = "United Kingdom"
                
                let candy3 = Candy(context: moc)
                candy3.name = "Twix"
                candy3.origin = Country(context: moc)
                candy3.origin?.shortName = "UK"
                candy3.origin?.fullName = "United Kingdom"
                
                let candy4 = Candy(context: moc)
                candy4.name = "Toblerone"
                candy4.origin = Country(context: moc)
                candy4.origin?.shortName = "CH"
                candy4.origin?.fullName = "Switzerland"
                
                try? moc.save()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static private var dataController = DataController()
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            
    }
}
