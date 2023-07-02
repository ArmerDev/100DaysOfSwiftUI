//
//  ContentView.swift
//  AddingAContextMenuToAnImage
//
//  Created by James Armer on 02/07/2023.
//

import SwiftUI

/*
 We’ve already written code that dynamically generates a QR code based on the user’s name and email address, but with a little extra code we can also let the user save that QR code to their images.

 Start by opening MeView.swift, and adding the contextMenu() modifier to the QR code image
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

