//
//  AddingACustomStarRatingComponentApp.swift
//  AddingACustomStarRatingComponent
//
//  Created by James Armer on 04/06/2023.
//

import SwiftUI

@main
struct AddingACustomStarRatingComponentApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
