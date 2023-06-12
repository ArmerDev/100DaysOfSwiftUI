//
//  OneToManyRelationshipsWithCoreDataSwiftUIAnd_FetchRequestApp.swift
//  OneToManyRelationshipsWithCoreDataSwiftUIAnd@FetchRequest
//
//  Created by James Armer on 12/06/2023.
//

import SwiftUI

@main
struct OneToManyRelationshipsWithCoreDataSwiftUIAnd_FetchRequestApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
