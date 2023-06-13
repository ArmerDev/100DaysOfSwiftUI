//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by James Armer on 13/06/2023.
//

import SwiftUI
import CoreData

@main
struct CoreDataProjectApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
