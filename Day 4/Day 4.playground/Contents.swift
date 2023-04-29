import Cocoa

// Type annotations

let playerName: String = "Roy"
let luckyNumber: Int = 13
let pi: Double = 3.141
var isAuthenticated: Bool = true

var albums: [String] = ["Red", "Fearless"]
var user: [String: String] = ["id": "@ArmerDev"]
var books: Set<String> = Set([
    "The Bluest Eye",
    "Foundation",
    "Girl, Woman, Other"
])

//The below three lines do the same thing
var teams: [String] = [String]()
var cities: [String] = []
var clues = [String]()


//Enums - types of our own

enum UIStyle {
    case light, dark, system
}

var style = UIStyle.light
style = .dark // remember, we can omit UIStyle. because we have already used it before, so it knows we want to use it again


// YOU CAN CREATE A CONSTANT WITHOUT A VALUE YET, BUT MUST PROVIDE IT A TYPE
let username: String
// lots of complex logic
//now we assign the value to username, which is valid because we can only assign it once, then it can not change
username = "@twostraws"
//lots more complex logic
print(username)




