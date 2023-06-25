//
//  FixingBookwormApp.swift
//  FixingBookworm
//
//  Created by James Armer on 25/06/2023.
//

import SwiftUI

@main
struct FixingBookwormApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

