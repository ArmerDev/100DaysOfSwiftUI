import Cocoa

// Day 10 - Structs, compute properties, property observers, custom initialisers

// Structs let us create our own data types


//note how we use a capital letter for the name of the struct/data type... just like String, Int and so on.
struct Album {
    
    //These constants below (or variables) are called Properties
    let title: String
    let artist: String
    let year: Int
    
    
    //functions within a struct are called Methods
    func printSummary() {
        print("\(title) (\(year)) by \(artist)")
    }
}


//When we create a constant or variable of our structs, that is called an Instance
let red = Album(title: "Red", artist: "Taylor Swift", year: 2012)
let wings = Album(title: "Wings", artist: "BTS", year: 2016)
// Album(title: "Wings", artist: "BTS", year: 2016) - This bit is known as an Initialiser - it provides the initial values for the struct

// swift creates a function is our structs called init - and it will use all the properties of the struct as parameters for the init function - and then it treats that as the equvilent of saying Album.init(...), but swift gives us some "syntactic sugar" and lets us just write Album(...)



print(red.title)
print(wings.artist)

red.printSummary()
wings.printSummary()


// It’s possible to modify the properties of a struct, but only if that struct is created as a variable. Of course, inside your struct there’s no way of telling whether you’ll be working with a variable struct or a constant struct, so Swift has a simple solution: any time a struct’s method tries to change any properties, you must mark it as 'mutating'.

/*
 There are two important details you’ll find useful in regards to 'mutating':

 - Marking methods as mutating will stop the method from being called on constant structs, even if the method itself doesn’t actually change any properties. If you say it changes stuff, Swift believes you!
 
 - A method that is not marked as mutating cannot call a mutating function – you must mark them both as mutating.
 
 */




struct Employee {
    let name: String
    var vacationRemaining: Int
    
    mutating func takeVacation(days: Int) {
        if vacationRemaining > days {
            vacationRemaining -= days
            
            // swift will complain here because we are wanting to change the value of some data in the struct. However, if we create an instant of our struct as a constant, swift makes the employee and all its data constant - which means that we can call functions on it, but those functions shouldn't be allowed to change the struct's data because we made it constant.
            
            // So - swift makes us take an extra step of including the keyword "mutating" before the func keyword, which means that the function can mutate the data.
            
            // By putting mutating, our code will build just fine, but swift will stop us from calling the takeVacation method from a constant struct.
            
        
            
            print("I'm going on vacation!")
            print("Days remaining: \(vacationRemaining)")
        } else {
            print("Oops! There aren't enough days remaining.")
        }
    }
}

var archer = Employee(name: "Bob", vacationRemaining: 20)
archer.takeVacation(days: 10)
print(archer.vacationRemaining)


// Default values

// 1 - if we provide a default value for the property name.....

struct Employee2 {
    let name: String = "Dave"
    var vacationRemaining: Int
    
    mutating func takeVacation(days: Int) {
        if vacationRemaining > days {
            vacationRemaining -= days
        
            print("I'm going on vacation!")
            print("Days remaining: \(vacationRemaining)")
        } else {
            print("Oops! There aren't enough days remaining.")
        }
    }
}

// 2 - Swift will complain if we try to include the name property in the initialiser - because we already set it and it was a constant (let) property... so it can not change.

//var darren = Employee2(name: "Harold", vacationRemaining: 10)

// 3 - You will note that the autocomplete will show an initialiser with just vacationRemaining when creating an instance of  Employee2

var jake = Employee2(vacationRemaining: 0)


// Note that if we provided a default value for vacationRemaining, we would be provided with two initialisers - one with just name, meaning it would use the default for vacationRemaining, and a second one which would allow us to provide initial values for both properties.


struct Employee3 {
    let name: String
    var vacationRemaining = 14
    
    mutating func takeVacation(days: Int) {
        if vacationRemaining > days {
            vacationRemaining -= days
        
            print("I'm going on vacation!")
            print("Days remaining: \(vacationRemaining)")
        } else {
            print("Oops! There aren't enough days remaining.")
        }
    }
}


let liam = Employee3(name: "Liam")
let liam2 = Employee3(name: "Liam", vacationRemaining: 15)



// Compute Property

// Structs have two types of property -
//Stored Property, which is a variable or constant that holds a piece of data inside an instance of the struct.
//Computed Property - which calculates the value of the property dyncatically every time it's accessed.

// This means that comptuted properties are a blend of both stored properties and functions: they are accessed like stored properties, but work like functions.


struct Employee5 {
    let name: String
    var vacation: Int
}

var archer1 = Employee5(name: "Sterling Archer", vacation: 14)
archer1.vacation -= 5
print(archer1.vacation)
archer1.vacation -= 3
print(archer1.vacation)

// we've lost how many days they were initially allocated.

// we can solve that using additional properties and using computed properties to calculate how much is remaining

struct Employee10 {
    let name: String
    var vacationAllocated = 14
    var vacationTaken = 0
    
    //calculated dynamically
    var vacationRemaining: Int {
        vacationAllocated - vacationTaken
    }
}


var liz = Employee10(name: "Liz", vacationAllocated: 14)
liz.vacationTaken  += 4
print(liz.vacationRemaining)
liz.vacationTaken += 2
print(liz.vacationRemaining)


// at the moment, we can't write to the vacationRemaining property (computed property), because we haven't told swift how to do that

// to fix it, we need to provide what is called a Getter, and a Setter = getters read, and setters write.

//lets re-wrtie employee again


struct Employee20 {
    let name: String
    var vacationAllocated = 14
    var vacationTaken = 0
    
    //calculated dynamically
    
    //Remember - computed properties must always have an explicit type. And computed properties can not be constants
    var vacationRemaining: Int {
        get {
            vacationAllocated - vacationTaken
        }
        
        //lets change the vacation allocation
        set {
            vacationAllocated = vacationTaken + newValue
            //newValue is automatically provided by swift inside the setter. It is the new value being provided..... what do you want to do with it?
        }
    }
}


var tony = Employee20(name: "Tony", vacationAllocated: 14)
tony.vacationTaken += 4
print("Tony has \(tony.vacationAllocated) days allocated")
print(tony.vacationRemaining)
tony.vacationRemaining = 5
print(tony.vacationAllocated)



// Property Observers
//-------------------- runs anytime a properties values are changed
// didSet runs code after the property has changed
// willSet runs when the property is about to change

struct Game {
    var score = 0
}

var game = Game()
game.score += 10
print(game.score)
game.score -= 2
print(game.score)
game.score += 1
print(game.score)
game.score += 5

// change score, print, change score, print and so on...
// but look, we missed printing the final time by mistake! We want to print everytime score changes!

//didSet lets us print automatically
// the code below is the same, execpt its renamed so the xcode is happy, and we have removed the print lines we had earlier.

// now, we create a didSet section inside the struct, after the score property...

struct Game1 {
    var score = 0 {
        didSet {
            print("Score us now \(score)")
            
            // Tip - Swift will automatically provide us with a special constant inside didSet called oldValue, to read what the score was previously...
            // Bonus Tip! - Theres a willSet equivilent, willSet being some code which runs some code before a property chance. That version is called newValue.
        }
    }
}

var game1 = Game1()
game1.score += 10
game1.score -= 2
game1.score += 1
game1.score += 5



struct App {
    var contacts = [String]() {
        willSet {
            print("Current value is: \(contacts)")
            print("New value will be: \(newValue)")
            print("")
        }
        
        didSet {
            print("There are now \(contacts.count) contacts")
            print("Old value was: \(oldValue)")
            print("")
        }
    }
}

var app = App()

app.contacts.append("Adrian E")
app.contacts.append("Luke M")
app.contacts.append("Daisy B")



struct Application {
    var name: String
    var isOnSale: Bool {
        didSet {
            if isOnSale {
                print("Go and download my app!")
            } else {
                print("Maybe download it later.")
            }
        }
    }
}


struct Child {
    var name: String
    var age: Int {
        didSet {
            print("Happy birthday, \(name)!")
        }
    }
}


//Remember, you can't attach a property observer to a constant because it will never change
//Therefore, the below will not work


//struct FootballMatch {
//    let homeTeamScore: Int {
//        didSet {
//            print("Yay - we scored!")
//        }
//    }
//    let awayTeamScore: Int {
//        didSet {
//            print("Boo - they scored!")
//        }
//    }
//}
//

// Custom Initialisers.... ---------------------------

// We can create our own initialisers, so long as we follow one rule
// All properties must have an initial value by the time the initialiser has finished.

struct Player {
    let name: String
    let number: Int
}

let player = Player(name: "Tom P", number: 15)
//This is a memberwise initialiser - which accepts each property in the order it was defined in the struct.
//This is the initialiser that Swift creates for us silently in the background.

// we can do that ourselves...

struct Player1 {
    let name: String
    let number: Int
    
    //note - there is no func keyword. init is treated specially...
//    note there is no explicit return type - because they always return the type they belong too... Player1
    init(name: String, number: Int) {
        //note - used self. to assign values, to clarify we mean assign the name parameter to self's property.
        // without it, its not clear which is which and what we want to do.
        
        
        // Self --------
        
//        Inside a method, Swift lets us refer to the CURRENT INSTANCE of a struct using self, but broadly speaking you don’t want to unless you specifically need to distinguish what you mean.
//
//        By far the most common reason for using self is inside an initializer, where you’re likely to want parameter names that match the property names of your type,
        
        
        // (Side note......
        //  Outside of initializers, the main reason for using self is because we’re in a closure and Swift requires it so we’re clear we understand what’s happening. This is only needed when accessing self from inside a closure that belongs to a class, and Swift will refuse to build your code unless you add it.)
        
        self.name = name
        self.number = number
    }
}

// we can customise our initialisers to do something more interesting.



struct Player3 {
    let name: String
    let number: Int

    init(name: String) {
        self.name = name
        //we don't use self here because we don't need to distinguish between a parameter and the structs property
        number = Int.random(in: 1...99)
        
        
        //although you can call other methods here inside the initialiser, you can only do this once you have met the requirements of having values for all your stored properties.
        
        //the reason you cant is because you might try to do something to a value that isn't set yet, which would cause all sorts of problems and that isn't very safe.
    }
}

let player10 = Player3(name: "Mike")
print(player10.number)

// You can set multiple initialisers for your structs... such as one for name, one for name and number, one that performs different functionality and more...

// You can use external parameter names, default values and more...

//however, as soon as you have your own custom initialiser, even just one, you will loose Swifts automatic memberwise initialiser........... if you want it to stay, you can use an extension, as shown below... we will cover extensions another day though.


struct EmployeeB {
    var name: String
    var yearsActive = 0
}

extension EmployeeB {
    init() {
        self.name = "Anonymous"
        print("Creating an anonymous employee…")
    }
}

// creating a named employee now works
let roslin = EmployeeB(name: "Laura Roslin")

// as does creating an anonymous employee
let anon = EmployeeB()




// Examples from review .....

struct Country {
    var name: String
    var usesImperialMeasurements: Bool
    init(countryName: String) {
        name = countryName
        let imperialCountries = ["Liberia", "Myanmar", "USA"]
        if imperialCountries.contains(name) {
            usesImperialMeasurements = true
        } else {
            usesImperialMeasurements = false
        }
    }
}




struct Cabinet {
    var height: Double
    var width: Double
    var area: Double
    init (itemHeight: Double, itemWidth: Double) {
        height = itemHeight
        width = itemWidth
        area = height * width
    }
}
let drawers = Cabinet(itemHeight: 1.4, itemWidth: 1.0)
