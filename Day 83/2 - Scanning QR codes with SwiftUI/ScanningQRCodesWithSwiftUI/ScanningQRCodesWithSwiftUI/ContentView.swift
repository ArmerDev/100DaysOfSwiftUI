//
//  ContentView.swift
//  ScanningQRCodesWithSwiftUI
//
//  Created by James Armer on 01/07/2023.
//

import SwiftUI

/*
 Scanning a QR code – or indeed any kind of visible code such as barcodes – can be done by Apple’s AVFoundation library. This doesn’t integrate into SwiftUI terribly smoothly, so to skip over a whole lot of pain I’ve packaged up a QR code reader into a Swift package that we can add and use directly inside Xcode.

 My package is called CodeScanner, and its available on GitHub under the MIT license at https://github.com/twostraws/CodeScanner – you’re welcome to inspect and/or edit the source code if you want. Here, though, we’re just going to add it to Xcode by following these steps:

 Go to File > Swift Packages > Add Package Dependency.
 Enter https://github.com/twostraws/CodeScanner as the package repository URL.
 For the version rules, leave “Up to Next Major” selected, which means you’ll get any bug fixes and additional features but not any breaking changes.
 Press Finish to import the finished package into your project.
 The CodeScanner package gives us one CodeScanner SwiftUI view to use, which can be presented in a sheet and handle code scanning in a clean, isolated way. I know I keep repeating myself, but I hope you can see the continuing theme: the best way to write SwiftUI is to isolate functionality in discrete methods and wrappers, so that all you expose to your SwiftUI layouts is clean, clear, and unambiguous.

 We already have a “Scan” button in ProspectsView, and we’re going to use that trigger QR scanning. So, start by adding this new @State property to ProspectsView:
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
