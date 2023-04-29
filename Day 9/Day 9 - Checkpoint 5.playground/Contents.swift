import Cocoa

// 100 Days of SwiftUI
// Checkpoint 5

let luckyNumbers = [7, 4, 38, 21, 16, 15, 12, 33, 32, 49]

let filteredNumbers = luckyNumbers.filter{$0.isMultiple(of: 2) == false}.sorted().map{"\($0) is a lucky number!"}

for number in filteredNumbers {
    print(number)
}

// Prints...
//  7 is a lucky number!
// 15 is a lucky number!
// 21 is a lucky number!
// 33 is a lucky number!
// 49 is a lucky number!
