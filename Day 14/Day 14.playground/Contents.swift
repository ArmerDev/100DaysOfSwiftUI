import Cocoa

//How to handle missing data with optionals

let opposites = ["Mario" : "Wario", "Luigi" : "Waluigi"]

let peachOpposite = opposites["Peach"] // What value will this have??   - This type is a string optional - String?
// Optional string means that it could contain a String, or it could contain nothing - nil.




//Swift likes our code to be predictable, which means it won’t let us use data that might not be there. In the case of optionals, that means we need to unwrap the optional in order to use it – we need to look inside the box to see if there’s a value, and, if there is, take it out and use it.

//Swift gives us two primary ways of unwrapping optionals, but the one you’ll see the most looks like this:


if let marioOpposite = opposites["Mario"] {
    print("Mario's opposite is \(marioOpposite)")
}


//This if let syntax is very common in Swift, and combines creating a condition (if) with creating a constant (let). Together, it does three things:

// - It reads the optional value from the dictionary.
// - If the optional has a string inside, it gets unwrapped – that means the string inside gets placed into the marioOpposite constant.
// - The condition has succeeded – we were able to unwrap the optional – so the condition’s body is run.

//The condition’s body will only be run if the optional had a value inside. Of course, if you want to add an else block you can – it’s just a normal condition, so this kind of code is fine:


var username: String? = nil


if let unwrappedName = username {
    print("We got a user: \(unwrappedName)")
} else {
    print("The optional was empty.")
}



/*

 Think of optionals a bit like Schrödinger’s data type: there might be a value inside the box or there might not be, but the only way to find out is to check.

 This might seem rather academic so far, but optionals really are critical for helping us produce better software. You see, in the same way optionals mean data may or may not be present, non-optionals – regular strings, integers, etc – mean data must be available.

 Think about it: if we have a non-optional Int it means there is definitely a number inside, always. It might be something like 1 million or 0, but it’s still a number and is guaranteed to be present. In comparison, an optional Int set to nil has no value at all – it’s not 0 or any other number, it’s nothing at all.

 Similarly, if we have a non-optional String it means there is definitely a string in there: it might be something like “Hello” or an empty string, but both of those are different from an optional string set to nil.
 
 Every data type can be optional if needed, including collections such as Array and Dictionary. Again, an array of integers might contain one or more numbers, or perhaps no numbers at all, but both of those are different from optional arrays set to nil.

 To be clear, an optional integer set to nil is not the same as a non-optional integer holding 0, an optional string set to nil is not the same as a non-optional string that is currently set to an empty string, and an optional array set to nil is not the same as a non-optional array that currently has no items – we’re talking about the absence of any data at all, empty or otherwise.

 As Zev Eisenberg said, “Swift didn’t introduce optionals. It introduced non-optionals.”

 You can see this in action if you try to pass an optional integer into a function that requires a non-optional integer, like this:
 
 
 
 
 func square(number: Int) -> Int {
     number * number
 }

 var number: Int? = nil
 print(square(number: number))
 
 
 
 Swift will refuse to build that code, because the optional integer needs to be unwrapped – we can’t use an optional value where a non-optional is needed, because if there were no value inside we’d hit a problem.

 So, to use the optional we must first unwrap it like this:
 
 
 if let unwrappedNumber = number {
     print(square(number: unwrappedNumber))
 }
 
 
 
 Before we’re done, I want to mention one last thing: when unwrapping optionals, it’s very common to unwrap them into a constant of the same name. This is perfectly allowable in Swift, and means we don’t need to keep naming constants unwrappedNumber or similar.

 Using this approach, we could rewrite the previous code to this:
 
 
 if let number = number {
     print(square(number: number))
 }
 
 
 
 This style is a bit confusing when you first read it, because now it feels like quantum physics – can number really be both optional and non-optional at the same time? Well, no.

 What’s happening here is that we’re temporarily creating a second constant of the same name, available only inside the condition’s body. This is called shadowing, and it’s mainly used with optional unwraps like you can see above.

 So, inside the condition’s body we have an unwrapped value to work with – a real Int rather than an optional Int? – but outside we still have the optional.
 

*/
  
  
  // Unwrapping optionals with guard
  
  
func printSquare(of number: Int?) {
    guard let number = number else {
        print("Missing input")
        return
    }
    
    print("\(number) x \(number) is \(number * number)")
}




var myVar: Int? = 3

/*

if let unwrapped = myVar {
    // Run if myVar has a value inside
}


guard let unwrapped = myVar else {
    // Run if myVar doesn't have a value inside
}

 */

//guard has the else keyword because its checking if there is a value, else .... do something else....

//guard provides the ability to check our program state is what we expect, and if it isn't, bail out - to exit the current function for example

/*
 This is sometimes called an early return: we check that all a function’s inputs are valid right as the function starts, and if any aren’t valid we get to run some code then exit straight away. If all our checks pass, our function can run exactly as intended.

 guard is designed exactly for this style of programming, and in fact does two things to help:

 If you use guard to check a function’s inputs are valid, Swift will always require you to use return if the check fails.
 If the check passes and the optional you’re unwrapping has a value inside, you can use it after the guard code finishes.
 You can see both of these points in action if you look at the printSquare() function from earlier:
 */


func printSquare2(of number: Int?) {
    guard let number = number else {
        print("Missing input")

        // 1: We *must* exit the function here
        return
    }

    // 2: `number` is still available outside of `guard`
    print("\(number) x \(number) is \(number * number)")
}


/*
 So: use if let to unwrap optionals so you can process them somehow, and use guard let to ensure optionals have something inside them and exit otherwise.

 Tip: You can use guard with any condition, including ones that don’t unwrap optionals. For example, you might use guard someArray.isEmpty else { return }.


 */



// Example of guard let....

func describe(occupation: String?) {
    guard let occupation = occupation else {
        print("You don't have a job.")
        return
    }
    print("You are an \(occupation).")
}
let job = "engineer"
describe(occupation: job)



// Unwrapping optionals with nil coalescing -----------------------------------

// This way of unwrapping optionals means it will unwrap the optional, but if it was nil/if it was empty, it will provide a default value instead.


let captains = [
    "Enterprise": "Picard",
    "Voyager": "Janeway",
    "Defiant": "Sisko"
]


let new = captains["Serenity"]   //This will be an optional string with the value of nil, because there is no Serenity key in captains...


// With nil coalescing, which is written with ??, we can provide a default value for any optional, like this:
let new2 = captains["Serenity"] ?? "N/A"
// This will read the value from the captains dictionary and attempt to unwrap it - if the optional had a value inside, it will be sent back and stored in new2 as a non-optional, a real value. But if its empty/if its nil - it will send back "N/A"

// Either way - new2 will not be an optional string


// And yes.... while we could have provided a default value like we did when we first looked at dictionaries, like this:

let new3 = captains["Jacob", default: "N/A"]

// however, we can use nil coalescing with any optionals.

/*
 For example, the randomElement() method on arrays returns one random item from the array, but it returns an optional because you might be calling it on an empty array. So, we can use nil coalescing to provide a default:
 */


let tvShows = ["Archer", "Babylon 5", "Ted Lasso"]
let favorite = tvShows.randomElement() ?? "None"


//Or perhaps you have a struct with an optional property, and want to provide a sensible default for when it’s missing:

struct Book {
    let title: String
    let author: String?
}

let book = Book(title: "Beowulf", author: nil)
let author = book.author ?? "Anonymous"
print(author)



//It’s even useful if you create an integer from a string, where you actually get back an optional Int? because the conversion might have failed – you might have provided an invalid integer, such as “Hello”. Here we can use nil coalescing to provide a default value, like this:

let input = ""
let number = Int(input) ?? 0
print(number)

//As you can see, the nil coalescing operator is useful anywhere you have an optional and want to use the value inside or provide a default value if it’s missing.


// Examples....


var captain: String? = "Kathryn Janeway"
let name = captain ?? "Anonymous"



let planetNumber: Int? = 426
var destination = planetNumber ?? 3




var userOptedIn: Bool? = nil
var optedIn = userOptedIn ?? false




// How to handle multiple optionals using optional chaining ------------------


/*
 Optional chaining is a simplified syntax for reading optionals inside optionals. That might sound like something you’d want to use rarely, but if I show you an example you’ll see why it’s helpful.

 Take a look at this code:
 */

let names = ["Arya", "Bran", "Robb", "Sansa"]

let chosen = names.randomElement()?.uppercased() ?? "No one"
print("Next in line: \(chosen)")


/*
 That uses two optional features at once: you’ve already seen how the nil coalescing operator helps provide a default value if an optional is empty, but before that you see optional chaining where we have a question mark followed by more code.

 Optional chaining allows us to say “if the optional has a value inside, unwrap it then…” and we can add more code. In our case we’re saying “if we managed to get a random element from the array, then uppercase it.” Remember, randomElement() returns an optional because the array might be empty.

 The magic of optional chaining is that it silently does nothing if the optional was empty – it will just send back the same optional you had before, still empty. This means the return value of an optional chain is always an optional, which is why we still need nil coalescing to provide a default value.

 Optional chains can go as long as you want, and as soon as any part sends back nil the rest of the line of code is ignored and sends back nil.

 To give you an example that pushes optional chaining harder, imagine this: we want to place books in alphabetical order based on their author names. If we break this right down, then:

 We have an optional instance of a Book struct – we might have a book to sort, or we might not.
 The book might have an author, or might be anonymous.
 If it does have an author string present, it might be an empty string or have text, so we can’t always rely on the first letter being there.
 If the first letter is there, make sure it’s uppercase so that authors with lowercase names such as bell hooks are sorted correctly.
 Here’s how that would look:
 */


struct Book1 {
    let title: String
    let author: String?
}

var book1: Book1? = nil
let author1 = book1?.author?.first?.uppercased() ?? "A"
print(author1)

/*
 So, it reads “if we have a book, and the book has an author, and the author has a first letter, then uppercase it and send it back, otherwise send back A”.

 Admittedly it’s unlikely you’ll ever dig that far through optionals, but I hope you can see how delightfully short the syntax is!
 */





// Examples....


let shoppingList = ["eggs", "tomatoes", "grapes"]
let firstItem = shoppingList.first?.appending(" are on my shopping list")


print(firstItem ?? "N/A")



let capitals = ["Scotland": "Edinburgh", "Wales": "Cardiff"]
let scottishCapital = capitals["Scotland"]?.uppercased()





// How to handle function failure with optionals....



/*
 When we call a function that might throw errors, we either call it using try and handle errors appropriately, or if we’re certain the function will not fail we use try! and accept that if we were wrong our code will crash. (Spoiler: you should use try! very rarely.)

 However, there is an alternative: if all we care about is whether the function succeeded or failed, we can use an optional try to have the function return an optional value. If the function ran without throwing any errors then the optional will contain the return value, but if any error was thrown the function will return nil. This means we don’t get to know exactly what error was thrown, but often that’s fine – we might just care if the function worked or not.

 Here’s how it looks:
 */


enum UserError: Error {
    case badID, networkFailed
}

func getUser(id: Int) throws -> String {
    throw UserError.networkFailed
}



if let user = try? getUser(id: 23) {
    print("User: \(user)")
}


/*
 The getUser() function will always throw a networkFailed error, which is fine for our testing purposes, but we don’t actually care what error was thrown – all we care about is whether the call sent back a user or not.

 This is where try? helps: it makes getUser() return an optional string, which will be nil if any errors are thrown. If you want to know exactly what error happened then this approach won’t be useful, but a lot of the time we just don’t care.

 If you want, you can combine try? with nil coalescing, which means “attempt to get the return value from this function, but if it fails use this default value instead.”

 Be careful, though: you need to add some parentheses before nil coalescing so that Swift understands exactly what you mean. For example, you’d write this:
 */

let userB = (try? getUser(id: 23)) ?? "Anonymous"
print(userB)


/*
 You’ll find try? is mainly used in three places:

 In combination with guard let to exit the current function if the try? call returns nil.
 In combination with nil coalescing to attempt something or provide a default value on failure.
 When calling any throwing function without a return value, when you genuinely don’t care if it succeeded or not – maybe you’re writing to a log file or sending analytics to a server, for example.
 */

