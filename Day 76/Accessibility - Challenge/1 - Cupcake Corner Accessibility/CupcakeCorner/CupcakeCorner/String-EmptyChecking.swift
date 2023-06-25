//
//  String-EmptyChecking.swift
//  CupcakeCorner
//
//  Created by James Armer on 25/06/2023.
//

import Foundation

extension String {
    var isReallyEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
