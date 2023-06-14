//
//  Friend.swift
//  FriendFace-CoreData
//
//  Created by James Armer on 14/06/2023.
//

import Foundation

struct Friend: Identifiable, Codable {
    let id: UUID
    let name: String
}
