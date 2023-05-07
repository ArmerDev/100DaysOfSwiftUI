//
//  ContentView.swift
//  ViewModifier
//
//  Created by James Armer on 07/05/2023.
//

import SwiftUI

struct BigBlueTitle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func bigBlueTitle() -> some View {
        modifier(BigBlueTitle())
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .bigBlueTitle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
