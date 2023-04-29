import Cocoa

// Checkpoint 8
/*
 Make a protocol that describes a building
 
 Your protocol should require the following
 
 A property storing how many rooms it has
 A property storing the cost as an integer
 A property storing the name of the esate agent selling the building
 A method for printing the sales summary of the building, describing what it is along with its other properties.
 
*/

// 100 Days of SwiftUI
// Checkpoint 8

protocol Building {
    var rooms: Int { get }
    var cost: Int { get }
    var estateAgent: String { get }
    func printSummary()
}

extension Building {
    func printSummary() {
        print("This building has \(rooms) rooms, costs £\(cost), and is being sold by \(estateAgent)")
    }
}

struct House: Building {
    let rooms: Int
    let cost: Int
    let estateAgent: String
    
    func printSummary() {
        print("This House has \(rooms) rooms, costs £\(cost), and is being sold by \(estateAgent)")
    }
}

struct Office: Building {
    let rooms: Int
    let cost: Int
    let estateAgent: String
    
    func printSummary() {
        print("This Office has \(rooms) rooms, costs £\(cost), and is being sold by \(estateAgent)")
    }
}

struct Barn: Building {
    let rooms: Int
    let cost: Int
    let estateAgent: String
}

let someBarn = Barn(rooms: 1, cost: 20000, estateAgent: "Farm and Co")
someBarn.printSummary()

let someOffice = Office(rooms: 5, cost: 500000, estateAgent: "Bert And Sellers")
someOffice.printSummary()

// Prints...
// This Office has 5 rooms, costs £500000, and is being sold by Bert And Sellers

