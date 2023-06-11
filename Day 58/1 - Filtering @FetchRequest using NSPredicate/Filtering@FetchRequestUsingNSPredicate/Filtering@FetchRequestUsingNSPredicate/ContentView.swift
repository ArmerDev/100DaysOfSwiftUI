//
//  ContentView.swift
//  Filtering@FetchRequestUsingNSPredicate
//
//  Created by James Armer on 11/06/2023.
//

import CoreData
import SwiftUI

/*
 When we use SwiftUI’s @FetchRequest property wrapper, we can provide an array of sort descriptors to control the ordering of results, but we can also provide an NSPredicate to control which results should be shown. Predicates are simple tests, and the test will be applied to each object in our Core Data entity – only objects that pass the test will be included in the resulting array.

 The syntax for NSPredicate isn’t something you can guess easily, but realistically you’re only ever going to want a few types of predicate so it’s not as bad as you think.

 To try out some predicates, create a new entity called Ship with two string attributes: “name” and “universe”. Then update the ContentView code below:
 */

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate: nil) var ships: FetchedResults<Ship>
    
    var body: some View {
        VStack {
            List(ships, id: \.self) { ship in
                Text(ship.name ?? "Unknown name")
            }
            
            Button("Add Examples") {
                let ship1 = Ship(context: moc)
                ship1.name = "Enterprise"
                ship1.universe = "Star Trek"
                
                let ship2 = Ship(context: moc)
                ship2.name = "Defiant"
                ship2.universe = "Star Trek"
                
                let ship3 = Ship(context: moc)
                ship3.name = "Millennium Falcon"
                ship3.universe = "Star Wars"
                
                let ship4 = Ship(context: moc)
                ship4.name = "Executor"
                ship4.universe = "Star Wars"
                
                try? moc.save()
            }
        }
    }
}

/*
 We can now press the button to inject some sample data into Core Data, but right now we don’t have a predicate. To fix that we need to replace the nil predicate value with some sort of test that can be applied to our objects.
 
 For example, we could ask for ships that are from Star Wars, like this:
 */

struct ContentView2: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "universe == 'Star Wars'")) var ships: FetchedResults<Ship>
    
    var body: some View {
        VStack {
            List(ships, id: \.self) { ship in
                Text(ship.name ?? "Unknown name")
            }
        }
    }
}

/*
 That gets complicated if your data includes quote marks, so it’s more common to use special syntax instead: `%@‘ means “insert some data here”, and allows us to provide that data as a parameter to the predicate rather than inline.

 So, we could instead write this:

 NSPredicate(format: "universe == %@", "Star Wars"))
 */

struct ContentView3: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "universe == %@", "Star Wars")) var ships: FetchedResults<Ship>
    
    var body: some View {
        VStack {
            List(ships, id: \.self) { ship in
                Text(ship.name ?? "Unknown name")
            }
        }
    }
}

/*
 As well as ==, we can also use comparisons such as < and > to filter our objects. For example this will return Defiant, Enterprise, and Executor:
 */

struct ContentView4: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "name < %@", "F")) var ships: FetchedResults<Ship>
    
    var body: some View {
        VStack {
            List(ships, id: \.self) { ship in
                Text(ship.name ?? "Unknown name")
            }
        }
    }
}

/*
 %@ is doing a lot of work behind the scenes, particularly when it comes to converting native Swift types to their Core Data equivalents. For example, we could use an IN predicate to check whether the universe is one of three options from an array, like this:
 */

struct ContentView5: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "universe IN %@", ["Aliens",  "Firefly", "Star Wars"] )) var ships: FetchedResults<Ship>
    
    var body: some View {
        VStack {
            List(ships, id: \.self) { ship in
                Text(ship.name ?? "Unknown name")
            }
        }
    }
}

/*
 We can also use predicates to examine part of a string, using operators such as BEGINSWITH and CONTAINS. For example, this will return all ships that start with a capital E:
 */

struct ContentView6: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "name BEGINSWITH %@", "E")) var ships: FetchedResults<Ship>
    
    var body: some View {
        VStack {
            List(ships, id: \.self) { ship in
                Text(ship.name ?? "Unknown name")
            }
        }
    }
}

/*
 That predicate is case-sensitive; if you want to ignore case you need to modify it to this:
 */

struct ContentView7: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "name BEGINSWITH[c] %@", "e")) var ships: FetchedResults<Ship>
    
    var body: some View {
        VStack {
            List(ships, id: \.self) { ship in
                Text(ship.name ?? "Unknown name")
            }
        }
    }
}

/*
 CONTAINS[c] works similarly, except rather than starting with your substring it can be anywhere inside the attribute.
 */

/*
 Finally, you can flip predicates around using NOT, to get the inverse of their regular behavior. For example, this finds all ships that don’t start with an E:
 */

struct ContentView8: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "NOT name BEGINSWITH[c] %@", "e")) var ships: FetchedResults<Ship>
    
    var body: some View {
        VStack {
            List(ships, id: \.self) { ship in
                Text(ship.name ?? "Unknown name")
            }
        }
    }
}

/*
 If you need more complicated predicates, join them using AND to build up as much precision as you need, or add an import for Core Data and take a look at NSCompoundPredicate – it lets you build one predicate out of several smaller ones.
 */

struct ContentView_Previews: PreviewProvider {
    static private var dataController = DataController()
    
    static var previews: some View {
        Group{
            ContentView()
            ContentView2()
                .previewDisplayName("ContentView 2")
            ContentView3()
                .previewDisplayName("ContentView 3")
            ContentView4()
                .previewDisplayName("ContentView 4")
            ContentView5()
                .previewDisplayName("ContentView 5")
            ContentView6()
                .previewDisplayName("ContentView 6")
            ContentView7()
                .previewDisplayName("ContentView 7")
            ContentView8()
                .previewDisplayName("ContentView 8")
        }
        .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
