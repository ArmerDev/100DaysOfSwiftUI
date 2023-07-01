//
//  ContentView.swift
//  GeneratingAndScalingUpAQRCode
//
//  Created by James Armer on 01/07/2023.
//

import SwiftUI

/*
 Core Image lets us generate a QR code from any input string, and do so extremely quickly. However, there’s a problem: the image it generates is very small because it’s only as big as the pixels required to show its data. It’s trivial to make the QR code larger, but to make it look good we also need to adjust SwiftUI’s image interpolation. So, in this step we’re going to ask the user to enter their name and email address in a form, use those two pieces of information to generate a QR code identifying them, and scale up the code without making it fuzzy.

 We already have a simple MeView struct that we made as a placeholder earlier, so our first job will be to add a couple of text fields and their string bindings.
 
 Navigate to MeView...
 */

struct ContentView: View {
    @StateObject var prospects = Prospects()
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }
            
            ProspectsView(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }
            
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
        .environmentObject(prospects)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
