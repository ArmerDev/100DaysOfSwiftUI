import Cocoa

// Closures

func greetUser() {
    print("Hi there!")
}

greetUser()

// You can assign functions to variables
var greetCopy = greetUser  //note how we don't have parens when we COPY the function - if you put the parens here, it means run the function and put its return value in greetCopy.

greetCopy()


// you can assign some functionality directly to a constant or variable

let sayHello = {
    print("Hi there!")
}
// The above is known as a closure expression

sayHello()

// if you want the closure to accept parameters, it has to be written in a slightly different way
// remember, it all has to be inside the opening and closing curly braces - thats where the closure is.
// Therefore, we put the parameter and return type inside the curly brackets


// the keywork 'in' is a marker for the end of the parameters and the return type, start of the body of the closure, the actual functionality we want to run.

let sayHello1 = { (name: String) -> String in
    "Hi \(name)!"
}


// --------------

// Thinking about function types

func greetUser2() {
    print("Hi there!")
}

// The function type is () -> Void because our function accepts no parameters, and returns no value
var greetCopy2: () -> Void = greetUser2


func getUserData(for id: Int) -> String {
    if id == 1989 {
        return "Taylor Swift"
    } else {
        return "Anonymous"
    }
}

// When we make a copy of the function, we lose the external name - only the data types are important
let data: (Int) -> String = getUserData

// Therefore, when we make a call to the copy (called data) and store the result in user - we have no parameter name
let user = data(1989)
print(user)


let result2 = sayHello1("Taylor")

print(result2)

// Example of where this closure thing could be used.
let team = ["Gloria", "Suzanne", "Piper", "Tiffany", "Tasha"]

let sortedTeam = team.sorted()
print(sortedTeam)

// But what if we wanted control over that sort
//we can actual pass a custom sorted function.

// the .sorted() function can receive a function so long as it takes two strings and returns a boolean - it doesn't care if we pass in a dedicated, seperate function or a closure written directly inside the .sorted function

// So - if we wanted suzanne to become first no matter what

func captainFirstSorted(name1: String, name2: String) -> Bool {
    
//    remember - this should return true if we want name1 to come become before name2
    
    if name1 == "Suzanne" {
        //if suzanne is first, return true
        return true
        
    } else if name2 == "Suzanne" {
        // return false because name2 should come before name1
        return false
    }
    
    //if still here, neither is Suzanne, so do a normal alphabetical sort
    return name1 < name2
}


//let captainFirstTeam = team.sorted(by: captainFirstSorted)
//print(captainFirstTeam)

let captainFirstTeam = team.sorted(by: {(name1: String, name2: String)-> Bool in
    if name1 == "Suzanne" {
        return true
    } else if name2 == "Suzanne" {
        return false
    }
    return name1 < name2
})

print(captainFirstTeam)


// Trailing closure and shorthand syntax

let teamAgain = ["Gloria", "Suzanne", "Piper", "Tiffany", "Tasha"]

// because sorted(by: ) must take in two string parameters and return a bool, we can omit it
// meaning instead of writing (a: String, b: String) -> Bool in
// we can just write a, b in

let sortedAgain = teamAgain.sorted(by: { a, b in
    if a == "Suzanne" {
        return true
        
    } else if b == "Suzanne" {
        return false
    }
    
    return a < b
})

print(sortedAgain)


// when one function accepts another functin as its parameter - swift gives us a special syntax type called trailing closure syntax
// which means the by chunk as well as the closing parentheses goes away, so instead it would be...

let sortedAgain2 = teamAgain.sorted { a, b in
    if a == "Suzanne" {
        return true
    } else if b == "Suzanne" {
        return false
    }
    return a < b
}

print(sortedAgain2)



// theres another way that we can make closures less cluttered
// swift can automatically provide parameters names using so called shorthand syntax
// so instead we don't have A / B anymore - we have $0, $1

// note how now we don't have anything at the start of the closure block - not even the in keyword

let sortedAgain3 = teamAgain.sorted {
    if $0 == "Suzanne" {
        return true
    } else if $1 == "Suzanne" {
        return false
    }
    return $0 < $1
}

print(sortedAgain2)

// now - this might not be the best way to use the shorthand, but if you wanted to reserve the team, then thats where shorthand does make more sense - like below

let reverseTeam = team.sorted {
    return $0 > $1
}


// remember - if you only have one line, then you can omit the return keyword. So it can become a signle line, like below

let reverseTeam1 = team.sorted { $0 > $1 }

// There are no fixed rules as to when use shorthand and when not to
// but Paul Hudson uses shorthand most of the time, unless one of three things are true

// 1 - If closure body is long, don't use shorthand - declare the variable names
// 2 - if $0/$1/$2 are used multiple times, paul prefers not to use it
// 3 - if you end up with three or more parameters ($0,$1,$2,$3) - it gets to complex, just name them all it becomes easier - Paul prefers a maximum of $0 and $1



//
//
//
//




//some examples

let tOnly = team.filter {$0.hasPrefix("T")}
print(tOnly)

let uppercasedTeam = team.map { $0.uppercased()}
print(uppercasedTeam)



// How to accept functions as parameters

// remember - using is just an external parameter name
// and that parameter with the internal name generator accepts a function that has no parameters and returns an integer
func makeArray(size: Int, using generator: () -> Int) -> [Int] {
    var numbers = [Int]()
    
    for _ in 0..<size {
        let newNumber = generator()
        numbers.append(newNumber)
    }
    
    return numbers
}

// effectively rolling a 20 sided dice, 50 times
let rolls = makeArray(size: 50) {
    Int.random(in: 1...20)
}

print(rolls)


//remember - we could make a function and pass that into makeArray ... like this

func generateNumeber() -> Int {
    Int.random(in: 1...20)
}

let newRolls = makeArray(size: 50, using: generateNumeber) //remember, we don't put open and close parens after generateNumber - !!!!I'm guessing because we are bascially passing the functionality to makeArray, not actually running generateNumber.
// We are just going - hey - here, have this functionality, and use it if you want to - which is why in the declaration for makeArray, we have generator() with parens - because thats when we actually run it!!!




// You can make your function accept multiple function parameters if you want to, which means you can specify multiple trailing closures if they are the last parameters.

// the syntax is very common in swiftUI - even making buttons use this syntax

func doImportantWork(first: () -> Void, second: () -> Void, third: () -> Void) {
    print("About to start first work")
    first()
    print("About to start second work")
    second()
    print("About to start third work")
    third()
    print("Done!")
}

//When we call it, we do not use the first parameter name, we close the brace, then use the external parameter names and seperate blocks for the other function parameters

doImportantWork {
    print("This is the first work")
} second: {
    print("This is the second work")
} third: {
    print("This is the third work")
}

