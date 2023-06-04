//
//  CreatingBooksWithCoreDataApp.swift
//  CreatingBooksWithCoreData
//
//  Created by James Armer on 04/06/2023.
//

import SwiftUI

@main
struct CreatingBooksWithCoreDataApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
