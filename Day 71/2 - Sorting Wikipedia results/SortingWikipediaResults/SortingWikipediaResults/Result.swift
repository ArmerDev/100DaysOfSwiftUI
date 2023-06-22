//
//  Result.swift
//  SortingWikipediaResults
//
//  Created by James Armer on 22/06/2023.
//

import Foundation

/*
 Start by modifying the definition of the Page struct to this:
 */

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    /*
    If you recall, conforming to Comparable has only a single requirement: we must implement a < function that accepts two parameters of the type of our struct, and returns true if the first should be sorted before the second. In this case we can just pass the test directly onto the title strings, so add this method to the Page struct now:
     */
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    
    static func <(lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}

/*
 Now that Swift understands how to sort pages, it will automatically gives us a parameter-less sorted() method on page arrays. This means when we set self.pages in fetchNearbyPlaces() we can now add sorted() to the end.
 */
