//
//  Movie+CoreDataProperties.swift
//  CreatingNSManagedObjectSubclasses
//
//  Created by James Armer on 10/06/2023.
//
//

import Foundation
import CoreData


extension Movie {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }
    
    @NSManaged public var title: String?
    @NSManaged public var director: String?
    @NSManaged public var year: Int16
    
    public var wrappedTitle: String {
        title ?? "Unknown Title"
    }
    
    public var wrappedDirector: String {
        director ?? "Unknown Director"
    }

}

extension Movie : Identifiable {

}
