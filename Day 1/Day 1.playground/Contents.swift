import Cocoa

var greeting = "Hello, playground"

var name = "Ted"
name = "Rebecca"
name = "Keeley"

let character = "Daphne"

var playerName = "Roy"
print(playerName)

playerName = "Dani"
print(playerName)

playerName = "Sam"
print(playerName)

let managerName = "Michael Scott"
let dogBreed = "Samoyed"
let meaningOfLife = "How many roads must a man walk down?"

//Try to prefer constants over variables
//Gives swift the chance to optimise code better
//Allows swift to stop you changing values by accident


let actor = "Denzel Washington"

let filename = "image.jpg"

let longerTest = """
This is some text
this is some more
and this is the last of it
"""

let nameLength = actor.count
print(nameLength)

print(filename.hasSuffix(".jpg"))

print(actor.uppercased())

//How to store whole numbers

let score = 10
let reallyBig = 100_000_000
//switft ignores the underscores, it just makes it easier for humans to read.
let otherReallyBig = 1_00____00___00_00
//this is also valid, although it isn't easier for humans to read.

let lowerScore = score - 2
let higherScore = score + 10
let doubleScore = score * 2
let squaredScore = score * score
let halvedScore = score / 2

var counter = 10
counter += 5 // this is called Compound Assignment Operator
print(counter)

counter *= 2
counter -= 10
counter /= 2

let number = 120
print(number.isMultiple(of: 3))



let number1 = 0.1+0.2
print(number1)

let a = 1
let b = 2.0
let c = Double(a) + b

print(c)

let double1 = 3.1
let double2 = 3131.3131
let double3 = 3.0
let int1 = 3

var secondName = "Nicolas Cage"
name = "57"

var rating = 5.0
rating *= 2
print(rating)


//CGFloat and Doubles can be used interchangably. If you come across CGFloat, just think Double


//-------

// Boolean

var gameOver = false
gameOver.toggle()
print(gameOver)

gameOver = !gameOver
print(gameOver)


let firstPart = "Hello "
let secondPart = "world!"

let phrase = firstPart + secondPart // the plus here is different to adding two integers together, for example. Thats because of operator overload (like function overload), which allows it to be used to concatenate multiple strings together when working with strings, and to add numbers together using addition.
print(phrase)

// swift has to add one string to the other before moving on to the next one. It will join the first two strings, then add the third, and so on. This is very wasteful. Its ok for small things, but you wouldn't want to use it much

//Instead, use string interpolation
let name2 = "Taylor"
let age = 24
let message = "Hello, my name is \(name2), and I'm \(age) years old."
//string interpolation is more efficient that adding strings one by one, but it also allows you to do other things such as use an integer in a string - you can even do calculations inside string interpolation. Swift is capable of placing any kind of data inside string interpolation. The result might not always be useful, but for all of Swift’s basic types – strings, integers, Booleans, etc – the results are great.


let temperatureInCelsius = 10.0
let temperatureInFahrenheit = ((temperatureInCelsius*9) / 2) + 32

print("The temperature is \(temperatureInCelsius) degrees celsius, which is \(temperatureInFahrenheit) fahrenheit")



