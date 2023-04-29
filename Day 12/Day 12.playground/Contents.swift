import Cocoa

//Classes

class Game {
    var score = 0 {
        didSet {
            print("Score is now \(score)")
        }
    }
}


var newGame = Game()
newGame.score += 10


// Notes of Classes

/*
Swift uses structs for storing most of its data types, including String, Int, Double, and Array, but there is another way to create custom data types called classes. These have many things in common with structs, but are different in key places.

First, the things that classes and structs have in common include:

- You get to create and name them.
- You can add properties and methods, including property observers and access control.
- You can create custom initializers to configure new instances however you want.

 However, classes differ from structs in five key places:
 
- You can make one class build upon functionality in another class, gaining all its properties and methods as a starting point.
  If you want to selectively override some methods, you can do that too.
- Because of that first point, Swift won’t automatically generate a memberwise initializer for classes. This means you either
  need to write your own initializer, or assign default values to all your properties.
- When you copy an instance of a class, both copies share the same data – if you change one copy, the other one also changes.
- When the final copy of a class instance is destroyed, Swift can optionally run a special function called a deinitializer.
- Even if you make a class constant, you can still change its properties as long as they are variables.
*/


// Inheritence
// Getting properties and methods from the other class, called the parent or super class
// And the new class - child class or subclass, can then add customisations or change functionality or make improvements to customise the way the new class wants to behave.
// When you want to in inherit one class from another, you write the class name, colon, followed by the parent class name - the name of the class you want to inherit from


class Employee {
    let hours: Int
    
    init(hours: Int) {
        self.hours = hours
    }
    
    
    func printSummary() {
        print("I work \(hours) hours a day.")
    }
    
}

class Developer: Employee {
    func work() {
        print("I'm writing code for \(hours) hours.")
    }
    
    override func printSummary() {
        print("I'm a developer who will sometimes work \(hours) hours a day, but other times spend hours arguing about whether code should be indented using tabs or spaces.")
    }
}

class Manager: Employee {
    func work() {
        print("I'm going to meetings for \(hours) hours.")
    }
}


// Note how Developer and Manager both gain the hours property and initialiser.
// Also note how those two child classes can refer directly to hours - it's as if they added that property themselves, except we don't have to keep repearing ourselves.

//Each of those classes inherit from Employee, but each then adds their own customisation. So, if we create an instance of each and call work(), we'll get dirrent results.


let robert = Developer(hours: 8)
let joseph = Manager(hours: 10)
robert.work()
joseph.work()

//As well as sharing properties, you can also share methods, which can then be called from the child classes.
// As an example, try adding this to the Employee class:
/*
 func printSummary() {
     print("I work \(hours) hours a day.")
 }
 */

//Because Developer inherits from Employee, we can immediately start calling printSummary() on instances of Developer, like this:
let novall = Developer(hours: 8)
novall.printSummary()



// Overriding methods...

/*
 Things get a little more complicated when you want to change a method you inherited. For example, we just put printSummary() into Employee, but maybe one of those child classes wants slightly different behavior.

 This is where Swift enforces a simple rule: if a child class wants to change a method from a parent class, you must use 'override' in the child class’s version. This does two things:

 If you attempt to change a method without using override, Swift will refuse to build your code. This stops you accidentally overriding a method.
 
 If you use override but your method doesn’t actually override something from the parent class, Swift will refuse to build your code because you probably made a mistake.
 
 So, if we wanted developers to have a unique printSummary() method, we’d add this to the Developer class:
 
 override func printSummary() {
     print("I'm a developer who will sometimes work \(hours) hours a day, but other times spend hours arguing about whether code should be indented using tabs or spaces.")
 }
 
 */





// Final class

//Tip: If you know for sure that your class should not support inheritance, you can mark it as 'final'. This means the class itself can inherit from other things, but can’t be used to inherit from – no child class can use a final class as its parent.


final class JuniorDeveloper: Developer {
    func work(str: String) {
        print("I'm writing code for \(hours) hours.")
    }
}

// Tip on inheriting methods: if the name is the same as the inherited method, but you have different perameters, you don't have to mark the method as override - like above in the JuniorDeveloper class.


// Tip from Paul Hudson - he tends to make classes final by default, so nobody can accidentally inherit something, and instead opens up the class if he knows that someone needs to inherit from it. So kind of flipping final around in a way.







// Adding initialisers to classes


/*
 Class initializers in Swift are more complicated than struct initializers, but with a little cherrypicking we can focus on the part that really matters: if a child class has any custom initializers, it must always call the parent’s initializer after it has finished setting up its own properties, if it has any.

 Remember, Swift won’t automatically generate a memberwise initializer for classes. This applies with or without inheritance happening – it will never generate a memberwise initializer for you. So, you either need to write your own initializer, or provide default values for all the properties of the class.
 */


class Vehicle {
    let isElectric: Bool
    
    init(isElectric: Bool) {
        self.isElectric = isElectric
    }
}


class Car: Vehicle {
    let isConvertible: Bool
    
/*  init(isConvertible: Bool) {
        self.isConvertible = isConvertible
    }
*/
    
    // Remember, we need to initialise the Superclass! Otherwise we won't know if the Car isElectric or not. Therefore, the above init wouldn't work. We need to do it like this:
    
    init(isElectric: Bool, isConvertible: Bool) {
        self.isConvertible = isConvertible
        super.init(isElectric: isElectric)
    }
}

// super allows us to call up to methods from the parents class, such as the initialiser. We can also use it with other methods too, its not just initialisers


let teslaX = Car(isElectric: true, isConvertible: false)



// Tip: If a subclass does not have any of its own initializers, it automatically inherits the initializers of its parent class.
// Aka - if there is no new properties in the subclass, or you have provided default values for new properties.







// Examples


class Product {
    var name: String
    init(name: String) {
        self.name = name
    }
}
class Book: Product {
    var isbn: String
    init(name: String, isbn: String) {
        self.isbn = isbn
        super.init(name: name)
    }
}




class Bicycle {
    var color: String
    init(color: String) {
        self.color = color
    }
}
class MountainBike: Bicycle {
    var tireThickness: Double
    init(color: String, tireThickness: Double) {
        self.tireThickness = tireThickness
        super.init(color: color)
    }
}



class Dog {
    var breed: String
    var isPedigree: Bool
    init(breed: String, isPedigree: Bool) {
        self.breed = breed
        self.isPedigree = isPedigree
    }
}
class Poodle: Dog {
    var name: String
    init(name: String) {
        self.name = name
        super.init(breed: "Poodle", isPedigree: true)
    }
}




class Instrument {
    var name: String
    init(name: String) {
        self.name = name
    }
}
class Piano: Instrument {
    var isElectric: Bool
    init(isElectric: Bool) {
        self.isElectric = isElectric
        super.init(name: "Piano")
    }
}



class Printer {
    var cost: Int
    init(cost: Int) {
        self.cost = cost
    }
}
class LaserPrinter: Printer {
    var model: String
    init(model: String, cost: Int) {
        self.model = model
        super.init(cost: cost)
    }
}




class Shape {
    var sides: Int
    init(sides: Int) {
        self.sides = sides
    }
}
class Rectangle: Shape {
    var color: String
    init(color: String) {
        self.color = color
        super.init(sides: 4)
    }
}




// Copying a class

// All copies of a class instance point to the same data - this mean if you change one, it will automatically change all the other copies too. This happens becuase classes are Reference types. They don't hold their own value, and instead point to a shared pot of data.


class User {
    var username = "Anonymous"
    // This will be shared with all other copies of the class
    
    func copy() -> User {
        let user = User()
        user.username = username
        return user
    }
}

var user1 = User()
var user2 = user1
user2.username = "Taylor"

print(user1.username)
print(user2.username)


/*
 This might seem like a bug, but it’s actually a feature – and a really important feature too, because it’s what allows us to share common data across all parts of our app. As you’ll see, SwiftUI relies very heavily on classes for its data, specifically because they can be shared so easily.

 In comparison, structs do not share their data amongst copies, meaning that if we change class User to struct User in our code we get a different result: it will print “Anonymous” then “Taylor”, because changing the copy didn’t also adjust the original.

 If you want to create a unique copy of a class instance – sometimes called a 'deep copy' – you need to handle creating a new instance and copy across all your data safely, by hand.

 
 You can do that by creating a copy method... Like this:
 */

class AlternativeUser {
    var username = "Anonymous"
    // This will be shared with all other copies of the class
    
    func copy() -> User {
        let user = User()
        user.username = username
        return user
    }
}


var userA = AlternativeUser()
var userB = userA.copy()

userB.username = "Darren"

print(userA.username)
print(userB.username)



// Create a deinitialiser

/*
 Swift’s classes can optionally be given a deinitializer, which is a bit like the opposite of an initializer in that it gets called when the object is destroyed rather than when it’s created.

 This comes with a few small provisos:

 - Just like initializers, you don’t use func with deinitializers – they are special.
 - Deinitializers can never take parameters or return data, and as a result aren’t even written with parentheses.
 - Your deinitializer will automatically be called when the final copy of a class instance is destroyed. That might mean it was created inside a function that is now finishing, for example.
 - We never call deinitializers directly; they are handled automatically by the system.
 - Structs don’t have deinitializers, because you can’t copy them.
 
 
 Exactly when your deinitializers are called depends on what you’re doing, but really it comes down to a concept called scope. Scope more or less means “the context where information is available”, and you’ve seen lots of examples already:

 If you create a variable inside a function, you can’t access it from outside the function.
 If you create a variable inside an if condition, that variable is not available outside the condition.
 If you create a variable inside a for loop, including the loop variable itself, you can’t use it outside the loop.
 If you look at the big picture, you’ll see each of those use braces to create their scope: conditions, loops, and functions all create local scopes.

 When a value exits scope we mean the context it was created in is going away. In the case of structs that means the data is being destroyed, but in the case of classes it means only one copy of the underlying data is going away – there might still be other copies elsewhere. But when the final copy goes away – when the last constant or variable pointing at a class instance is destroyed – then the underlying data is also destroyed, and the memory it was using is returned back to the system.
 
 */

//To demonstrate this, we could create a class that prints a message when it’s created and destroyed, using an initializer and deinitializer:


class UserB {
    let id: Int

    init(id: Int) {
        self.id = id
        print("User \(id): I'm alive!")
    }

    
    //Remember, no parentheses with deinit
    deinit {
        print("User \(id): I'm dead!")
    }
}

var users = [UserB]()

for i in 1...3 {
    let user = UserB(id: i)
    print("User \(user.id): I'm in control!")
    users.append(user)
}

print("Loop is finished!")
users.removeAll()
print("Array is clear!")


// You can see they were alive because they were stored in the array, and only when the array is finally cleared, do the instances of the class get destroyed.





/*
 
 // Why do classes have deinitializers and structs don’t?
 
 One small but important feature of classes is that they can have a deinitializer function – a counterpart to init() that gets run when the class instance gets destroyed. Structs don’t have deinitializers, which means we can’t tell when they are destroyed.

 The job of deinitializers is to tell us when a class instance was destroyed. For structs this is fairly simple: the struct is destroyed when whatever owns it no longer exists. So, if we create a struct inside a method and the methods ends, the struct is destroyed.

 However, classes have complex copying behavior that means several copies of the class can exist in various parts of your program. All the copies point to the same underlying data, and so it’s now much harder to tell when the actual class instance is destroyed – when the final variable pointing to it has gone away.

 Behind the scenes Swift performs something called automatic reference counting, or ARC. ARC tracks how many copies of each class instance exists: every time you take a copy of a class instance Swift adds 1 to its reference count, and every time a copy is destroyed Swift subtracts 1 from its reference count. When the count reaches 0 it means no one refers to the class any more, and Swift will call its deinitializer and destroy the object.

 So, the simple reason for why structs don’t have deinitializers is because they don’t need them: each struct has its own copy of its data, so nothing special needs to happen when it is destroyed.

 You can put your deinitializer anywhere you want in your code, but I love this quote from Anne Cahalan: “Code should read like sentences, which makes me think my classes should read like chapters. So the deinitializer goes at the end, it's the ~fin~ of the class!”
 
 */










// How to work with variables inside classes

/*
 Swift’s classes work a bit like signposts: every copy of a class instance we have is actually a signpost pointing to the same underlying piece of data. Mostly this matters because of the way changing one copy changes all the others, but it also matters because of how classes treat variable properties.
 */


class UserC {
    var name = "Paul"
}

let user = UserC()
user.name = "Taylor"
print(user.name)

// But we're changing the constant... aren't we? ... That can't happen??

// Except we aren't changing the constant value at all. We are changing the variable property inside the class.
// The actual class instance itself, the object we created, hasn't changed - and can't be changed, because we made it constant.

/*
 Think of it like this: we created a constant signpoint pointing towards a user, but we erased that user’s name tag and wrote in a different name. The user in question hasn’t changed – the person still exists – but a part of their internal data has changed.

 Now, if we had made the name property a constant using let, then it could not be changed – we have a constant signpost pointing to a user, but we’ve written their name in permanent ink so that it can’t be erased.
 
 In contrast, what happens if we made both the user instance and the name property variables? Now we’d be able to change the property, but we’d also be able to change to a wholly new User instance if we wanted. To continue the signpost analogy, it would be like turning the signpost to point at wholly different person.
 
 
 */


class UserD {
    var name = "Paul"
}

var userD = UserD()
userD.name = "Taylor"
userD = UserD()
print(user.name)

// We couldn't be able to do the above if we had created userD as a constant/let.



/*
 The final variation is having a variable instance and constant properties, which would mean we can create a new User if we want, but once it’s done we can’t change its properties.

 So, we end up with four options:

 Constant instance, constant property – a signpost that always points to the same user, who always has the same name.
 Constant instance, variable property – a signpost that always points to the same user, but their name can change.
 Variable instance, constant property – a signpost that can point to different users, but their names never change.
 Variable instance, variable property – a signpost that can point to different users, and those users can also change their names.
 */



// Note - methods in classes that modify the properties does not need to be marked with mutating, unless struct.
