//
//  ContentView.swift
//  NavigationBar
//
//  Created by James Armer on 29/04/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Hello World")
                }
            }
            .navigationTitle("SwiftUI")
            .navigationBarTitleDisplayMode(.automatic)
            // Tip: You can specify the navigation bar to be always be large or inline using the .navigationBarTitleDisplayMode modifier
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
