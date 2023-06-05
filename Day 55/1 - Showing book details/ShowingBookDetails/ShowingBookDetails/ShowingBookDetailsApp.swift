//
//  ShowingBookDetailsApp.swift
//  ShowingBookDetails
//
//  Created by James Armer on 05/06/2023.
//

import SwiftUI

@main
struct ShowingBookDetailsApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
