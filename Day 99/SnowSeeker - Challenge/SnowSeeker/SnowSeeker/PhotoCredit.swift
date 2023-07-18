//
//  PhotoCredit.swift
//  SnowSeeker
//
//  Created by James Armer on 18/07/2023.
//

import SwiftUI

struct PhotoCredit: ViewModifier {
    var photographer: String

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(photographer)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(.black)
        }
    }
}

extension View {
    func photoCredit(with person: String) -> some View {
        modifier(PhotoCredit(photographer: person))
    }
}

