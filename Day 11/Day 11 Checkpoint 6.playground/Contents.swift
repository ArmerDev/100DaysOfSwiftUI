import Cocoa

//Checkpoint 6

/*
 
 Make a car struct that includes
 -Its model
 -Number of Seats
 -Current Gear
 
 add method to change gears up or down - could be one method or two
 
 think about variables and access control. What data in our properties should be variables and constants, and what data should be exposed to the world for modication. And should the gear changing method perform valiadation on the input or not? don't allow invalid gears - 1...10 seams a fair maximum range.
 
 */

enum Gears {
    case changeUp, changeDown
}


struct Car {
    let name: String
    let numberOfSeats: Int
    let numberOsGears: Int
    
    private(set) var currentGear = 1
    
    mutating func changeGear(_ gearDirection: Gears) {
        if currentGear <= numberOsGears && currentGear >= 1 {
            if gearDirection == .changeUp && currentGear < numberOsGears{
                currentGear += 1
                print("Changed gear successfully - current gear: \(currentGear)")
                return
            } else if gearDirection == .changeDown && currentGear > 1 {
                currentGear -= 1
                print("Changed gear successfully - current gear: \(currentGear)")
                return
            }
        }
        print("Gear out of range")
    }
}

var myCar = Car(name: "Audi A5", numberOfSeats: 5, numberOsGears: 7)

myCar.changeGear(.changeUp)
// Prints... Changed gear successfully - current gear: 2
myCar.changeGear(.changeDown)
// Prints... Changed gear successfully - current gear: 1
