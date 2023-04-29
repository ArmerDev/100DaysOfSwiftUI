import Cocoa

// Protocols and Extensions



/*
 Protocols are a bit like contracts in Swift: they let us define what kinds of functionality we expect a data type to support, and Swift ensures that the rest of our code follows those rules.

 Think about how we might write some code to simulate someone commuting from their home to their office. We might create a small Car struct, then write a function like this:
 */

//func commute(distance: Int, using vehicle: Car) {
    // lots of code here
//}


//Of course, they might also commute by train, so we’d also write this:

//func commute(distance: Int, using vehicle: Train) {
    // lots of code here
//}

//Or they might travel by bus:

//func commute(distance: Int, using vehicle: Bus) {
    // lots of code here
//}


/*
 Or they might use a bike, an e-scooter, a ride share, or any number of other transport options.

 The truth is that at this level we don’t actually care how the underlying trip happens. What we care about is much broader: how long might it take for the user to commute using each option, and how to perform the actual act of moving to the new location.

 This is where protocols come in: they let us define a series of properties and methods that we want to use. They don’t implement those properties and methods – they don’t actually put any code behind it – they just say that the properties and methods must exist, a bit like a blueprint.

 For example, we could define a new Vehicle protocol like this:
 */


protocol Vehicle {
    
    // Protocols can also mark out properties they have too, but we must say if they are a get or a get and set.
    var name: String { get }
    var currentPassengers: Int { get set}
    
    func estimateTime(for distance: Int) -> Int
    func travel(distance: Int)
}


/*
 
Let’s break that down:

To create a new protocol we write protocol followed by the protocol name. This is a new type, so we need to use camel case starting with an uppercase letter.
Inside the protocol we list all the methods we require in order for this protocol to work the way we expect.
These methods do not contain any code inside – there are no function bodies provided here. Instead, we’re specifying the method names, parameters, and return types. You can also mark methods as being throwing or mutating if needed.
So we’ve made a protocol – how has that helped us?

Well, now we can design types that work with that protocol. This means creating new structs, classes, or enums that implement the requirements for that protocol, which is a process we call adopting or conforming to the protocol.

The protocol doesn’t specify the full range of functionality that must exist, only a bare minimum. This means when you create new types that conform to the protocol you can add all sorts of other properties and methods as needed.

For example, we could make a Car struct that conforms to Vehicle, like this:
 */

struct Car: Vehicle {
    
    let name = "Car"
    var currentPassengers = 1
    
    func estimateTime(for distance: Int) -> Int {
        distance / 50
    }

    func travel(distance: Int) {
        print("I'm driving \(distance)km.")
    }

    func openSunroof() {
        print("It's a nice day!")
    }
}


struct Bus: Vehicle {
    
    let name = "Bus"
    var currentPassengers = 8
    
    func estimateTime(for distance: Int) -> Int {
        distance / 50
    }

    func travel(distance: Int) {
        print("I'm driving \(distance)km.")
    }

    func openSunroof() {
        print("It's a nice day!")
    }
}


struct Train: Vehicle {
    
    let name = "Train"
    var currentPassengers = 27
    
    func estimateTime(for distance: Int) -> Int {
        distance / 50
    }

    func travel(distance: Int) {
        print("I'm driving \(distance)km.")
    }

    func openSunroof() {
        print("It's a nice day!")
    }
}


struct Bicylce: Vehicle {
    
    let name = "Bike"
    var currentPassengers = 1
    
    func estimateTime(for distance: Int) -> Int {
        distance / 10
    }
    
    func travel(distance: Int) {
        print("I'm cycling \(distance)km")
    }
}


/*
 There are a few things I want to draw particular attention to in that code:

 We tell Swift that Car conforms to Vehicle by using a colon after the name Car, just like how we mark subclasses.
 All the methods we listed in Vehicle must exist exactly in Car. If they have slightly different names, accept different parameters, have different return types, etc, then Swift will say we haven’t conformed to the protocol.
 The methods in Car provide actual implementations of the methods we defined in the protocol. In this case, that means our struct provides a rough estimate for how many minutes it takes to drive a certain distance, and prints a message when travel() is called.
 The openSunroof() method doesn’t come from the Vehicle protocol, and doesn’t really make sense there because many vehicle types don’t have a sunroof. But that’s okay, because the protocol describes only the minimum functionality conforming types must have, and they can add their own as needed.
 So, now we’ve created a protocol, and made a Car struct that conforms to the protocol.

 To finish off, let’s update the commute() function from earlier so that it uses the new methods we added to Car:
 */



func commute(distance: Int, using vehicle: Car) {
    if vehicle.estimateTime(for: distance) > 100 {
        print("Thats too slow! I'll try a different vehicle.")
    } else {
        vehicle.travel(distance: distance)
    }
}


let car = Car()
commute(distance: 100, using: car)


// But you might be thinking we could have done the above without the protocol we created - and you'd be right...
// However... because we created a Vehicle protocol, and therefore we know all types we create that conform to the Vehicle protocol must have the methods estimateTime and distance, we can actually chance our function parameter to accept 'Vehicle' rather than car. And because we know that all types that conform to vehcile must have those methods, the code here would still work for any type passed in that conforms to it...



func commute(distance: Int, usingThe vehicle: Vehicle) {
    if vehicle.estimateTime(for: distance) > 100 {
        print("Thats too slow! I'll try a different vehicle.")
    } else {
        vehicle.travel(distance: distance)
    }
}

func getTravelEstiamtes(using vehicles: [Vehicle], distance: Int) {
    for vehicle in vehicles {
        let estimate = vehicle.estimateTime(for: distance)
        print("\(vehicle.name): \(estimate) hours to travel \(distance)km")
    }
}


let car2 = Car()
commute(distance: 100, usingThe: car)

let bus = Bus()
commute(distance: 50, usingThe: bus)

let train = Train()
commute(distance: 1000, usingThe: train)

let bike = Bicylce()
commute(distance: 10, usingThe: bike)


getTravelEstiamtes(using: [car, bike], distance: 150)
 



// You can conform to multiple Protocols, like this


protocol CanBeElectric {
    
}


protocol AlternativeVehicle: Vehicle, CanBeElectric {
    
    
}


// If you ever need to subclass something AND conform to a protocol ...
// Put the parent class name fist after the colon, then list the protocols...
// Example

/*
 class someSuperclass {
 }
 
 class someSubclass: someSuperclass, Vechile, CanBeElectric {
 
 
 */





// Example!!!

// We could create a protocol that declares the basic functionality we need for purchasable items. This might be many methods and properties, but here we’re just going to say that we need a name string:

protocol Purchasable {
    var name: String { get set }
}

//Now we can go ahead and define as many structs as we need, with each one conforming to that protocol by having a name string:

struct Book: Purchasable {
    var name: String
    var author: String
}

struct Movie: Purchasable {
    var name: String
    var actors: [String]
}

struct Car2: Purchasable {
    var name: String
    var manufacturer: String
}

struct Coffee: Purchasable {
    var name: String
    var strength: Int
}


//You’ll notice each one of those types has a different property that wasn’t declared in the protocol, and that’s okay – protocols determine the minimum required functionality, but we can always add more.

//Finally, we can rewrite the buy() function so that it accepts any kind of Purchasable item:
func buy(_ item: Purchasable) {
    print("I'm buying \(item.name)")
}


/*
 Inside that method we can use the name property of our item safely, because Swift will guarantee that each Purchasable item has a name property. It doesn’t guarantee that any of the other properties we defined will exist, only the ones that are specifically declared in the protocol.

 So, protocols let us create blueprints of how our types share functionality, then use those blueprints in our functions to let them work on a wider variety of data.
 */
