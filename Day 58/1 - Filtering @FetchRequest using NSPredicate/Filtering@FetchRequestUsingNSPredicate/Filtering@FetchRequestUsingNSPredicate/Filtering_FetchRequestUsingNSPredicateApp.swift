//
//  Filtering_FetchRequestUsingNSPredicateApp.swift
//  Filtering@FetchRequestUsingNSPredicate
//
//  Created by James Armer on 11/06/2023.
//

import SwiftUI

@main
struct Filtering_FetchRequestUsingNSPredicateApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
