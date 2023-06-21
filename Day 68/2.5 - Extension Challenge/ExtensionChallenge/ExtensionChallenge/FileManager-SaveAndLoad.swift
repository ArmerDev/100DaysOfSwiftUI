//
//  FileManager-SaveAndLoad.swift
//  ExtensionChallenge
//
//  Created by James Armer on 21/06/2023.
//

import Foundation

extension FileManager {
    func saveText(content: String, filename: String) {
        let url = getDocumentsDirectory().appendingPathComponent("\(filename).txt")
        
        
        do {
            try content.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func readFile(filename: String) {
        let url = getDocumentsDirectory().appendingPathComponent("\(filename).txt")
        
        do {
            let input = try String(contentsOf: url)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}
