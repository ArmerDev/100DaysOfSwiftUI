import Cocoa

// 100 Days of SwiftUI
// Checkpoint 9

func returnInteger(arrayOfInts: [Int]?) -> Int {
    arrayOfInts?.randomElement() ?? Int.random(in: 1...100)
}
