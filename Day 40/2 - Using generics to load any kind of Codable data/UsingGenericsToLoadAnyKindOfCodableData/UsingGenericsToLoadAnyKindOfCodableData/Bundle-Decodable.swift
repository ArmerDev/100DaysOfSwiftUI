//
//  Bundle-Decodable.swift
//  UsingGenericsToLoadAnyKindOfCodableData
//
//  Created by James Armer on 22/05/2023.
//

import Foundation


/*
 Inside the method, we can now use “T” everywhere we would use [String: Astronaut] – it is literally a placeholder for the type we want to work with. So, rather than returning [String: Astronaut] we would use T.
 
 Be very careful: There is a big difference between T and [T]. Remember, T is a placeholder for whatever type we ask for, so if we say “decode our dictionary of astronauts,” then T becomes [String: Astronaut]. If we attempt to return [T] from decode() then we would actually be returning [[String: Astronaut]] – an array of dictionaries of astronauts!

 Towards the end of the decode() method there’s another place where [String: Astronaut] is used:

 guard let loaded = try? decoder.decode([String: Astronaut].self, from: data) else {
 Again, please change that to T, like this:

 guard let loaded = try? decoder.decode(T.self, from: data) else {
 So, what we’ve said is that decode() will be used with some sort of type, such as [String: Astronaut], and it should attempt to decode the file it has loaded to be that type.

 If you try compiling this code, you’ll see an error in Xcode: “Instance method 'decode(_:from:)' requires that 'T' conform to 'Decodable’”. What it means is that T could be anything: it could be a dictionary of astronauts, or it could be a dictionary of something else entirely. The problem is that Swift can’t be sure the type we’re working with conforms to the Codable protocol, so rather than take a risk it’s refusing to build our code.

 Fortunately we can fix this with a constraint: we can tell Swift that T can be whatever we want, as long as that thing conforms to Codable. That way Swift knows it’s safe to use, and will make sure we don’t try to use the method with a type that doesn’t conform to Codable.

 To add the constraint, change the method signature to this:

 func decode<T: Codable>(_ file: String) -> T {
 If you try compiling again, you’ll see that things still aren’t working, but now it’s for a different reason: “Generic parameter 'T' could not be inferred”, over in the astronauts property of ContentView. This line worked fine before, but there has been an important change now: before decode() would always return a dictionary of astronauts, but now it returns anything we want as long as it conforms to Codable.

 We know it will still return a dictionary of astronauts because the actual underlying data hasn’t changed, but Swift doesn’t know that. Our problem is that decode() can return any type that conforms to Codable, but Swift needs more information – it wants to know exactly what type it will be.

 So, to fix this we need to use a type annotation so Swift knows exactly what astronauts will be:

 let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
 Finally – after all that work! – we can now also load mission.json into another property in ContentView. Please add this below astronauts:

 let missions: [Mission] = Bundle.main.decode("missions.json")
 And that is the power of generics: we can use the same decode() method to load any JSON from our bundle into any Swift type that conforms to Codable – we don’t need half a dozen variants of the same method.

 Before we’re done, there’s one last thing I’d like to explain. Earlier you saw the message “Instance method 'decode(_:from:)' requires that 'T' conform to 'Decodable’”, and you might have wondered what Decodable was – after all, we’ve been using Codable everywhere. Well, behind the scenes, Codable is just an alias for two separate protocols: Encodable and Decodable. You can use Codable if you want, or you can use Encodable and Decodable if you prefer being specific – it’s down to you.
 */

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
    }
}
