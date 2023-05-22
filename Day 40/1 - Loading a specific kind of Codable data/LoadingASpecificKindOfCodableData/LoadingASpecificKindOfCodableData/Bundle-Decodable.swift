//
//  Bundle-Decodable.swift
//  LoadingASpecificKindOfCodableData
//
//  Created by James Armer on 22/05/2023.
//

import Foundation

extension Bundle {
    func decode(_ file: String) -> [String: Astronaut] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode([String: Astronaut].self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
    }
}

/*
 As you can see, that makes liberal use of fatalError(): if the file can’t be found, loaded, or decoded the app will crash. As before, though, this will never actually happen unless you’ve made a mistake, for example if you forgot to copy the JSON file into your project.

 Now, you might wonder why we used an extension here rather than a method, but the reason is about to become clear as we load that JSON into our content view. 
 */
