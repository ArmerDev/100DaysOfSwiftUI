import Cocoa

// Default values for parameters

//giving end a default value of 12
func printTimesTables(for number: Int, end: Int = 12) {
    for i in 1...end {
        print("\(number) * \(i) is \(number * i)")
    }
}

printTimesTables(for: 5, end: 20)

printTimesTables(for: 8)


//we actually used a default parameter before with removeAll() - below is the version where we modify the default value with keepingCapacity
var characters = ["Lna", "Pam", "Ray", "Sterling"]
print(characters.count)
characters.removeAll(keepingCapacity: true) // this will remove items but leave the array able to hold 4 values, rather than swift shrinking the amount of allocated space for the array to its no-value size
print(characters.count)


// Default values allow us to create shorter, simpler code most of the time, but felixibility when we need it!
func findDirections(from: String, to: String, route: String = "fastest", avoidHighways: Bool = false) {
    // code here
}

findDirections(from: "London", to: "Glasgow")
findDirections(from: "London", to: "Glasgow", route: "scenic")
findDirections(from: "London", to: "Glasgow", route: "scenic", avoidHighways: true)



// Handling errors in functions


// step 1 - define all errors that might happen in the code we are wrting - do this with an enum that is of type: Error
// step 2 - write a function that works as normal, but can throw one or more errors if serious problem is found
// step 3 - try and run that function, and handle any errors that come back

// Do, Try, Catch!!! 


enum PasswordError: Error {
    case short, obvious
}


//If a function is able to throw errors, we must mark it with the throws keyword before the return type
//this means it can throw errors, not that it must throw errors.

func checkPassword(_ password: String) throws -> String {
    if password.count < 5 {throw PasswordError.short}
    if password == "12345" {throw PasswordError.obvious}
    //if it throws, then the  immediately exits function. It will not run anymore code, it wont return anything. It will exit immediately to be handled somewhere else.
    
    //if no errors are thrown, we pass through these lines of code and move on to the rest of our code as normal
    
    
    if password.count < 8 {
        return "OK"
    } else if password.count < 10 {
        return "Good"
    } else {
        return "Excellent"
    }
}


let string = "12345"


//To use a function that throws error, you much use Do/Try

//if the check function works correctly, it will return a value back into result and carry on running the code in the do block
//but if there is any errors it will stop the do block immediately and jump straight to the catch block.
do {
    //the keyword "try" MUST be used before all throwing functions, to signal to yourself and other developers that regular code executing might stop here - because an error might be thrown and it will jump down to the catch block.
    let result = try checkPassword(string)
    print("Password rating: \(result)")
} catch {
    print("There was an error")
}

//you always need a catch block to catch errors

//you can look for particular errors - by using a dedicated catch block, like below

do {
    let result = try checkPassword(string)
    print("Password rating: \(result)")
} catch PasswordError.short {
    print("Please use a longer password.")
} catch PasswordError.obvious {
    print("I use the same combination on my luggage!")
} catch {
    print("There was an error")
}
//The final catch block is a catch all - sometimes comically called a Pokemon catch, because "Gotta catch them all"
//and will catch all other errors



// Apple's throwing functions are really good at providing explainations as to what the error was, and we can read that or show it to our user by using error.localizedDescription.

// print("There was an error: \(error.localizedDescription)")





//In a handful of circumstances you can write a diffferent version of try, which is try! - which does not require do or catch.
//It means "I think this function is safe to throw with no errors" and if your wrong, you're risking a very fatal error.

let result2 = try! checkPassword("jnasdijobaolsijdgpjashkbg")
// if you change this to "12345" it would produce a fatal error.
print("Password rating: \(result2)")














