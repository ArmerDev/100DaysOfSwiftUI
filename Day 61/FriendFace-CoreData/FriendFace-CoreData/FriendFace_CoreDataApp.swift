//
//  FriendFace_CoreDataApp.swift
//  FriendFace-CoreData
//
//  Created by James Armer on 14/06/2023.
//

import SwiftUI

@main
struct FriendFace_CoreDataApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
