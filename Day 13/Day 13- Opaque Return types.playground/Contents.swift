import Cocoa

// Opaque Return Types


func getRandomNumber() -> some Equatable {
    Int.random(in: 1...6)
}


func getRandomBool() -> some Equatable {
    Bool.random()
}



// Refer to this website for more info on Opaque Return Types
//https://www.hackingwithswift.com/quick-start/beginners/how-to-use-opaque-return-types
