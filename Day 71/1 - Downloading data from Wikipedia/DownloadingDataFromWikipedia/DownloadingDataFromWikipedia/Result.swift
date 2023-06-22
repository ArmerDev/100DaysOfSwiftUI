//
//  Result.swift
//  DownloadingDataFromWikipedia
//
//  Created by James Armer on 22/06/2023.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
}

/*
 We’re going to use that to store data we fetch from Wikipedia, then show it immediately in our UI. However, we need something to show while the fetch is happening – a text view saying “Loading” or similar ought to do the trick.

 This means conditionally showing different UI depending on the current load state, and that means defining an enum that actually stores the current load state otherwise we don’t know what to show.

 Start by navigating to EditView and adding this nested enum to EditView:
 
 enum LoadingState {
     case loading, loaded, failed
 }
 
 */
