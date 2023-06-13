//
//  ContentView.swift
//  CoreDataProject
//
//  Created by James Armer on 13/06/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State private var filterType: FilterType = .contains
    @State private var lastNameFilter = "A"
    
    @State private var sortDescriptors = [SortDescriptor<Singer>]()
    
    var body: some View {
        VStack {
            FilteredList(type: .beginsWith, filterKey: "lastName", filterValue: lastNameFilter, sortDescriptors: sortDescriptors) { (singer: Singer) in
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
            
            Button("Begins with") {
                filterType = .beginsWith
            }

            Button("Contains") {
                filterType = .contains
            }
            
            Button("Sort A-Z") {
                sortDescriptors = [SortDescriptor(\.firstName)]
            }

            Button("Sort Z-A") {
                sortDescriptors = [SortDescriptor(\.firstName, order: .reverse)]
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
