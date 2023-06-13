//
//  Friend.swift
//  FriendFace
//
//  Created by James Armer on 13/06/2023.
//

import Foundation

struct Friend: Identifiable, Codable {
    let id: UUID
    let name: String
}
