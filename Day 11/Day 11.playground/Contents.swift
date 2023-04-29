import Cocoa


// Day 11
// Static Properties and Methods


//By default, Swift’s structs let us access their properties and methods freely, but often that isn’t what you want – sometimes you want to hide some data from external access. For example, maybe you have some logic you need to apply before touching your properties, or maybe you know that some methods need to be called in a certain way or order, and so shouldn’t be touched externally.


struct BankAccount {
    var funds = 0
    
    mutating func deposit(amount: Int) {
        funds += amount
    }
    
    mutating func withdraw(amount: Int) -> Bool {
        if funds > amount {
            funds -= amount
            return true
        } else {
            return false
        }
    }
}


var account = BankAccount()
account.deposit(amount: 100)

let success = account.withdraw(amount: 200)

if success {
    print("Withdraw money successfully")
} else {
    print("Failed to get the money")
}


// Here is our Struct, the funds property is exposed externally.
// So whats stopping us from touching it directly? Answer: Nothing at all

// That means we could - 1000 from funds, bypassing our checks to see if funds are available
account.funds -= 1000

//obviously - this is bad and shouldn't be allowed



// To solve this, we can tell swift that our funds property should be available for reading and writing only inside the struct by methods that belong to it, as well as any computed properties and property observers.

//We do that by adding the keyword private

struct BankAccount2 {
    private var funds = 0
    
    mutating func deposit(amount: Int) {
        funds += amount
    }
    
    mutating func withdraw(amount: Int) -> Bool {
        if funds > amount {
            funds -= amount
            return true
        } else {
            return false
        }
    }
}


var account2 = BankAccount()
account2.deposit(amount: 100)

let success2 = account2.withdraw(amount: 200)

if success {
    print("Withdraw money successfully")
} else {
    print("Failed to get the money")
}

// This makes funds private

// now trying to read funds from outside the struct is no longer possible, but it is possible from inside the structs methods - deposit and withdraw.

// If you try to modify funds from outside the struct, swift willl refuse to even build your code

// THIS IS CALLED ACCESS CONTROL - BECAUSE IT CONTROLS HOW A STRUCTS PROPERTIES AND METHODS CAN BE ACCESSED FROM OUTSIDE THE STRUCT.


// The main ones for when you're learning are...

// private - don't let anything outside the struct use this.
// fileprivate - don't let anything outside the current file use this.
// public - let anyone, anywhere use this.
// private(set) - means let anyone read this property externally or internally, but only let my internal methods write it.





//There’s one extra option that is sometimes useful for learners, which is this: private(set). This means “let anyone read this property, but only let my methods write it.” If we had used that with BankAccount, it would mean we could print account.funds outside of the struct, but only deposit() and withdraw() could actually change the value.

//In this case, I think private(set) is the best choice for funds: you can read the current bank account balance at any time, but you can’t change it without running through my logic.

//If you think about it, access control is really about limiting what you and other developers on your team are able to do – and that’s sensible! If we can make Swift itself stop us from making mistakes, that’s always a smart move.





//Important: If you use private access control for one or more properties, chances are you’ll need to create your own initializer.


struct School1 {
    var staffNames: [String]
    private var studentNames: [String]
    init(staff: String...) {            //the String... is called a Variadic Parameter - which accepts zero or more values of a specified type.
        self.staffNames = staff
        self.studentNames = [String]()
    }
}
let royalHigh = School1(staff: "Mrs Hughes", "Mr McDowel", "Mr Holroyd", "Miss Mozzolla ")
print(royalHigh)



struct Customer {
    var name: String
    private var creditCardNumber: Int
    init(name: String, creditCard: Int) {
        self.name = name
        self.creditCardNumber = creditCard
    }
}
let lottie = Customer(name: "Lottie Knights", creditCard: 1234567890)



// Static Properties and Methods

//You’ve seen how we can attach properties and methods to structs, and how each struct has its own unique copy of those properties so that calling a method on the struct won’t read the properties of a different struct from the same type.

//Well, sometimes – only sometimes – you want to add a property or method to the struct itself, rather than to one particular instance of the struct, which allows you to use them directly. I use this technique a lot with SwiftUI for two things: creating example data, and storing fixed data that needs to be accessed in various places.








//Notice the keyword static in there, which means both the studentCount property and add() method belong to the School struct itself, rather than to individual instances of the struct.
struct School {
    static var studentCount = 0

    static func add(student: String) {
        print("\(student) joined the school.")
        studentCount += 1
    }
}


School.add(student: "Taylor Swift")
print(School.studentCount)

//I haven’t created an instance of School – we can literally use add() and studentCount directly on the struct. This is because those are both static, which means they don’t exist uniquely on instances of the struct.


//This should also explain why we’re able to modify the studentCount property without marking the method as mutating – that’s only needed with regular struct functions for times when an instance of struct was created as a constant, and there is no instance when calling add().


//If you want to mix and match static and non-static properties and methods, there are two rules:

// 1 - To access non-static code from static code… you’re out of luck: static properties and methods can’t refer to non-static properties and methods because it just doesn’t make sense – which instance of School would you be referring to?

// 2 - To access static code from non-static code, always use your type’s name such as School.studentCount. You can also use Self to refer to the current type. - note - that is Self with a capital S

//lowercase self means the current value of a struct
//Uppercase Self means the current type of struct

// think of it like this... when we create properties and variables, we use lowercase camelCase
//but for types... Int, String, Bool - we use uppercase CamelCase




// Paul provides examples of when he might use this..

//"First, I use static properties to organize common data in my apps. For example, I might have a struct like AppData to store lots of shared values I use in many places:"


struct AppData {
    static let version = "1.3 beta 2"
    static let saveFilename = "settings.json"
    static let homeURL = "https://www.hackingwithswift.com"
}


AppData.version


//Using this approach, everywhere I need to check or display something like my app’s version number – an about screen, debug output, logging information, support emails, etc – I can read AppData.version.

//The second reason I commonly use static data is to create examples of my structs. As you’ll see later on, SwiftUI works best when it can show previews of your app as you develop, and those previews often require sample data. For example, if you’re showing a screen that displays data on one employee, you’ll want to be able to show an example employee in the preview screen so you can check it all looks correct as you work.

//This is best done using a static example property on the struct, like this:

struct Employee {
    let username: String
    let password: String
    
    static let example = Employee(username: "cfederighi", password: "h4irf0rce0ne")
}

//And now whenever you need an Employee instance to work with in your design previews, you can use Employee.example and you’re done.
Employee.example

//Like I said at the beginning, there are only a handful of occasions when a static property or method makes sense, but they are still a useful tool to have around.


// EXAMPLES ======================


struct NewsStory {
    static var breakingNewsCount = 0
    static var regularNewsCount = 0
    var headline: String
    init(headline: String, isBreaking: Bool) {
        self.headline = headline
        if isBreaking {
            NewsStory.breakingNewsCount += 1
        } else {
            NewsStory.regularNewsCount += 1
        }
    }
}


struct Person {
    static var population = 0
    var name: String
    init(personName: String) {
        name = personName
        Person.population += 1
    }
}


struct Pokemon {
    static var numberCaught = 0
    var name: String
    static func catchPokemon() {
        print("Caught!")
        Pokemon.numberCaught += 1
    }
}


struct LegoBrick {
    static var numberMade = 0
    var shape: String
    var color: String
    init(shape: String, color: String) {
        self.shape = shape
        self.color = color
        LegoBrick.numberMade += 1
    }
}



/*
 
 Structs are used almost everywhere in Swift: String, Int, Double, Array and even Bool are all implemented as structs, and now you can recognize that a function such as isMultiple(of:) is really a method belonging to Int.

 Let’s recap what else we learned:

 You can create your own structs by writing struct, giving it a name, then placing the struct’s code inside braces.
 Structs can have variable and constants (known as properties) and functions (known as methods)
 If a method tries to modify properties of its struct, you must mark it as mutating.
 You can store properties in memory, or create computed properties that calculate a value every time they are accessed.
 We can attach didSet and willSet property observers to properties inside a struct, which is helpful when we need to be sure that some code is always executed when the property changes.
 Initializers are a bit like specialized functions, and Swift generates one for all structs using their property names.
 You can create your own custom initializers if you want, but you must always make sure all properties in your struct have a value by the time the initializer finishes, and before you call any other methods.
 We can use access to mark any properties and methods as being available or unavailable externally, as needed.
 It’s possible to attach a property or methods directly to a struct, so you can use them without creating an instance of the struct.
 
 
 */
