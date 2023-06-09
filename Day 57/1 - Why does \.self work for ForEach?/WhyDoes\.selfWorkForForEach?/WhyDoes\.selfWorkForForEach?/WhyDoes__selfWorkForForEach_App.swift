//
//  WhyDoes__selfWorkForForEach_App.swift
//  WhyDoes\.selfWorkForForEach?
//
//  Created by James Armer on 09/06/2023.
//

import SwiftUI

@main
struct WhyDoes__selfWorkForForEach_App: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
