//
//  String-EmptyChecking.swift
//  CupcakeCorner
//
//  Created by James Armer on 03/06/2023.
//

import Foundation

extension String {
    var isReallyEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
