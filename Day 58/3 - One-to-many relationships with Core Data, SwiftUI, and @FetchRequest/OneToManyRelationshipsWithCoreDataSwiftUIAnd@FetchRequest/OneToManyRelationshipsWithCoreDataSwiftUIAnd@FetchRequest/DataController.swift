//
//  DataController.swift
//  OneToManyRelationshipsWithCoreDataSwiftUIAnd@FetchRequest
//
//  Created by James Armer on 12/06/2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "CoreDataProject")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load from CoreData: \(error.localizedDescription)")
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
