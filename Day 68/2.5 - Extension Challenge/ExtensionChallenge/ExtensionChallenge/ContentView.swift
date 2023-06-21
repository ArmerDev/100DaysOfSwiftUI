//
//  ContentView.swift
//  ExtensionChallenge
//
//  Created by James Armer on 21/06/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .onTapGesture {
                let str = "Test Message"
                FileManager.default.saveText(content: str, filename: "ExtensionChallenge")
                
                FileManager.default.readFile(filename: "ExtensionChallenge")
            }
        
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
