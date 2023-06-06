//
//  UsingAnAlertToPopANavigationLinkProgrammaticallyApp.swift
//  UsingAnAlertToPopANavigationLinkProgrammatically
//
//  Created by James Armer on 06/06/2023.
//

import SwiftUI

@main
struct UsingAnAlertToPopANavigationLinkProgrammaticallyApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
