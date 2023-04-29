import Cocoa

// If statement

var someCondition = true

if someCondition {
    print("Do Something")
    print("Do Something else")
    print("Do another thing")
}


let score = 85

// > is a comparison operator
if score > 80 {
    print("Great job!")
}

let speed = 88
let percentage = 85
let age = 18

if speed >= 88 {
    print("Where we're going, we don't need roads")
}

if percentage < 85 {
    print("Sorry, you've failed the test.")
}

if age >= 18 {
    print("You are eligable to vote.")
}

let ourName = "Dave Lister"
let friendName = "Arnold Rimmer"

if ourName < friendName {
    print("It's \(ourName) vs \(friendName)")
}

if ourName > friendName {
    print("It's \(friendName) vs \(ourName)")
}

var numbers = [1, 2, 3]
numbers.append(4)

if numbers.count > 3 {
    numbers.remove(at: 0)
}

print(numbers)


let country = " Canada"

if country == "Australia" {
    print("G'day!")
}

let name = "Taylor Swift"

if name != "Anonymous" {
    print("Welcome, \(name)")
}


var username = "taylorswift13"
//if username.isEmpty == true
//we don't need the == true section because it already is a booleon.
if username.isEmpty {
    username = "Anonymous"
}

//you might think it would be quicker behind the scenes to compare if username's value is equal in length to 0. However, Swift works really well with strings out of the box, and when we ask swift to count the number of characters in a string, it has to count them one by one, it doesn't store the length of a string on hand. So it actually is easier to just compare a string to an empty string to see if its count if equal to 0. However, swift has a second piece of functionilty to strings, arrays, dictionaries and sets, which is called isEmpty, which will send back true if the item in question is empty.

print("Welcome, \(username)")


// If Else

if someCondition {
    print("This code will run if the condition is true")
} else {
    print("This code will run if the condition is false")
}

let a = true
let b = false

if a {
    print("code to run if true")
} else if b {
    print("code to be run is a is false and b is true")
} else {
    print("code to run if both a and b are false")
}



let temp = 25

if temp > 20 {
    if temp < 30 {
        print("It's a nice day")
    }
}

//The below code is the same as above
if temp > 20 && temp < 30 {     //&& is a logical operator - AND
    print("It's a nice day")
}

let userAge = 14

let hasParentalConsent = true

if age >= 18 || hasParentalConsent { //Remember: == true in a condition can be removed
    print("You can buy the game!")
}


enum TransportOption {
    case airplane, helicopter, bicycle, car, escooter
}

let transport = TransportOption.airplane


if transport == .airplane || transport == .helicopter {
    print("Let's fly!")
} else if transport == .bicycle {
    print("I hope there's a bike path...")
} else if transport == .car {
    print("Time to get stuck in traffic.")
} else {
    print("I'm going to hire a scooter!")
}


// Switch
// Switches are great when writing code because if we check something twice, it will complain, and if we miss something, it will refuse to build


enum Weather {
    case sun, rain, wind, snow
}

let forecast = Weather.sun

switch forecast {
    
case .sun:
    print("It should eb a nice day.")
case .rain:
    print("Pack an umbrella")
case .wind:
    print("Wear something warm")
case .snow:
    print("School is cancelled")
}


let place = "Metropolis"

switch place {
case "Gothem": print("You're Batman")
case "Mega-City One": print("You're Judge Dredd")
case "Wakanda": print("You're Black Panther!")
default: print("Who are you?") //default always goes at the end, otherwise case blocks below it will be missed, and the default would be used.
}


//switches have the benefit of reading the value once when checking multiple cases, but if statements have to check the value again and again - this is important when you start using function calls, because some of these can be slow.

// Switches will run the code in the block of code matched and nothing else, however, we can make it move down and run the next code block by using the keyword fallthrough

let day = 5
print("My true love gave to me...")

switch day {
case 5:
    print("5 golden rings")
    fallthrough
case 4:
    print("4 calling birds")
    fallthrough
case 3:
    print("3 french hens")
    fallthrough
case 2:
    print("2 turtle doves")
    fallthrough
default:
    print("A partidge in a pear tree")
}


// Ternary Conditional Operator / Ternary Operator

let someAge = 18
let canVote = age >= 18 ? "Yes" : "No"


let hour = 23
print(hour < 12 ? "It's before noon" : "It's after noon")

let names = ["Jayne", "Kaylee", "Mal"]
let crewCount = names.isEmpty ? "No one" : "\(names.count) people"
print(crewCount)


enum Theme {
    case light, dark
}

let theme = Theme.dark

//the below parathesis aren't needed, but can help to make your code easier to read than = theme == .dark
let background = (theme == .dark) ? "black" : "white"
print(background)



