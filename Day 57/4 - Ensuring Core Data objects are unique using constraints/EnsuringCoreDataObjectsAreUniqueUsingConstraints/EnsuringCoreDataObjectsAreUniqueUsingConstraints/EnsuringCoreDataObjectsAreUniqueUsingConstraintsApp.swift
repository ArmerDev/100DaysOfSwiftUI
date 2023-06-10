//
//  EnsuringCoreDataObjectsAreUniqueUsingConstraintsApp.swift
//  EnsuringCoreDataObjectsAreUniqueUsingConstraints
//
//  Created by James Armer on 10/06/2023.
//

import SwiftUI

@main
struct EnsuringCoreDataObjectsAreUniqueUsingConstraintsApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
