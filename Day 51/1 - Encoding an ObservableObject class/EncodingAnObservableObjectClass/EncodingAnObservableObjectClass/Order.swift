//
//  Order.swift
//  EncodingAnObservableObjectClass
//
//  Created by James Armer on 01/06/2023.
//

import SwiftUI

/*
 We’ve organized our code so that we have one Order object that gets shared between all our screens, which has the advantage that we can move back and forward between those screens without losing data. However, this approach comes with a cost: we’ve had to use the @Published property wrapper for the properties in the class, and as soon we did that we lost support for automatic Codable conformance.

 If you don’t believe me, just try modifying the definition of Order to include Codable, like this:

 class Order: ObservableObject, Codable {
 The build will now fail, because Swift doesn’t understand how to encode and decode published properties. This is a problem, because we want to submit the user’s order to an internet server, which means we need it as JSON – we need the Codable protocol to work.

 The fix here is to add Codable conformance by hand, which means telling Swift what should be encoded, how it should be encoded, and also how it should be decoded – converted back from JSON to Swift data.

 That first step means adding an enum that conforms to CodingKey, listing all the properties we want to save. In our Order class that’s almost everything – the only thing we don’t need is the static types property.

 So, add this enum to Order now:
 */

class Order: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        
        return true
    }
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2
        
        // complicated cakes cost more
        cost += (Double(type) / 2)
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
    
    /*
     The second step requires us to write an encode(to:) method that creates a container using the coding keys enum we just created, then writes out all the properties attached to their respective key. This is just a matter of calling encode(_:forKey:) repeatedly, each time passing in a different property and coding key.
     */
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)

        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)

        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }
    
    /*
     Because that method is marked with throws, we don’t need to worry about catching any of the errors that are thrown inside – we can just use try without adding catch, knowing that any problems will automatically propagate upwards and be handled elsewhere.

     Our final step is to implement a required initializer to decode an instance of Order from some archived data. This is pretty much the reverse of encoding, and even benefits from the same throws functionality:
     */
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)

        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)

        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
    
    /*
     It’s worth adding here that you can encode your data in any order you want – you don’t need to match the order in which properties are declared in your object.

     That makes our code fully Codable compliant: we’ve effectively bypassed the @Published property wrapper, reading and writing the values directly. However, it doesn’t make our code compile – in fact, we now get a completely different error back in ContentView.swift.

     The problem now is that we just created a custom initializer for our Order class, init(from:), and Swift wants us to use it everywhere – even in places where we just want to create a new empty order because the app just started.

     Fortunately, Swift lets us add multiple initializers to a class, so that we can create it in any number of different ways. In this situation, that means we need to write a new initializer that can create an order without any data whatsoever – it will rely entirely on the default property values we assigned.

     So, add this new initializer to Order now:

     init() { }
     */
    
    init() { }
    
    /*
     Now our code is back to compiling, and our Codable conformance is complete. This means we’re ready for the final step: sending and receiving Order objects over the network.
     */
}
