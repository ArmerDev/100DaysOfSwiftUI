//
//  DynamicallyFiltering_FetchRequestWithSwiftUIApp.swift
//  DynamicallyFiltering@FetchRequestWithSwiftUI
//
//  Created by James Armer on 12/06/2023.
//

import SwiftUI

@main
struct DynamicallyFiltering_FetchRequestWithSwiftUIApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
