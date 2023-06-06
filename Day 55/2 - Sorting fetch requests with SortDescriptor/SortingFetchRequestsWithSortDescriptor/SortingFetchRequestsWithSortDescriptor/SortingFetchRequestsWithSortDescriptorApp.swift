//
//  SortingFetchRequestsWithSortDescriptorApp.swift
//  SortingFetchRequestsWithSortDescriptor
//
//  Created by James Armer on 06/06/2023.
//

import SwiftUI

@main
struct SortingFetchRequestsWithSortDescriptorApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
