import Cocoa

// Functions


func showWelcome()/* Open and closed parenthesis - Parameters*/{
    //body of function
    
    print("Welcome to my app!")
    print("By default, this prings out a conversation")
    print("chart from centimeters to inches, but you")
    print("can also set a custom range if you want.")
}


showWelcome()   //This is known as fucntion's call site

// These are parameters - (number: Int, end: Int)
func printTimesTables(number: Int, end: Int) {
    for i in 1...end {
        print("\(i) x \(number) is \(i * number)")
    }
}

// Here, these are called arguments - the actual values are called arguments
//(number: 5, end: 20)
//most people will call them parameters - don't worry about it
printTimesTables(number: 5, end: 20)

// Any data you make inside the function is automatically destroyed when the function is finished


func rollDice()-> Int {
    return Int.random(in: 1...6)
}

let result = rollDice()
print(result)

func checkTwoString(str1: String, str2: String)->Bool {
    let string1 = Set(Array(str1))
    let string2 = Set(Array(str2))
    
    let string1Array = Array(string1).sorted()
    let string2Array = Array(string2).sorted()
    
    return string1Array == string2Array
}

let resultOfStrings = checkTwoString(str1: "hhhheeeeeeeeeeeeeeeeerrrroo", str2: "hhhhhhhhhhhhhhheeerrrrrrrrrrrrro")


print(resultOfStrings)

// I overcomplicated it - its meant to be str1: "abc" and str2: "cba"

func areLettersIdentical(string1: String, string2: String) -> Bool {
    
    string1.sorted() == string2.sorted()

    //because there is only one line of code in our function body, swift knows that this must be the data that has to be returned because its a boolean, so we can omit the return keyword.
    
}


func pythagoras(a: Double, b: Double) -> Double {

    sqrt(a * a + b * b)
}

let c = pythagoras(a: 3, b: 4)
print(c)


//if your function doesn't return a value - you can still use return by itself to force the function to exit immediately

func printHello() {
    return
}


// Tuples - multiple values into a single variable or constant - but unlike arrays, they have a fixed size

func getUser() -> (firstName: String, lastName: String) {
    ("Taylor","Swift")
}


let user = getUser()
print("Name: \(user.firstName) \(user.lastName)")


let firstName = user.firstName
let secondName = user.lastName
print("Name: \(firstName) \(secondName)")

// Destructuring - pulling functions returned tuple out into two seperate constants

let (firstName1, secondName1) = getUser()
print("Name1: \(firstName1) \(secondName1)")

//if you don't need one or more constants, you could replace it with an underscore

let (firstName2, _) = getUser()
print("Name2: \(firstName2)")


// If tuple doesn't have element names, you can refer to them numerically

func getUser2() -> (String, String) {
    ("Taylor","Swift")
}


let user2 = getUser()
print("Name: \(user2.0) \(user2.1)")


// Customise parameter labels

let lyric = "I see a red door and I want it painted black."

print(lyric.hasPrefix("I see"))

//_ is used to say there is no external parameter name
func isUppercase(_ string: String) -> Bool {
    string == string.uppercased()
}


let string5 = "HELLO, WORLD"
let result2 = isUppercase(string5)

// for is the external parameter name
// note: for can be used as an external parameter name, but not an internal one because for is a reserved keyboard for declaring a for in loop
func printTimesTables2(for number: Int) {
    for i in 1...12 {
        print(i * number)
    }
}

printTimesTables2(for: 50)
