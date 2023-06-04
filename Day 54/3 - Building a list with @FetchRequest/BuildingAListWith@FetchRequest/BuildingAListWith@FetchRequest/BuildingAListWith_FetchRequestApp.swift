//
//  BuildingAListWith_FetchRequestApp.swift
//  BuildingAListWith@FetchRequest
//
//  Created by James Armer on 04/06/2023.
//

import SwiftUI

@main
struct BuildingAListWith_FetchRequestApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
