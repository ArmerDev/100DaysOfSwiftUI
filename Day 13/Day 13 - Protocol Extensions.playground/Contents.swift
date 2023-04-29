import Cocoa

let guests = ["Mario", "Luigi", "Peach"]

if guests.isEmpty == false {
    print("Guest count: \(guests.count)")
}

//Some people prefer to use the Boolean ! operator, like this:

if !guests.isEmpty {
    print("Guest count: \(guests.count)")
}



/*
 I’m not really a big fan of either of those approaches, because they just don’t read naturally to me “if not some array is empty”?

 We can fix this with a really simple extension for Array, like this:
*/


extension Array {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}

//Tip: Xcode’s playgrounds run their code from top to bottom, so make sure you put that extension before where it’s used.

//Now we can write code that I think is easier to understand:
if guests.isNotEmpty {
    print("Guest count: \(guests.count)")
}


/*
 But we can do better. You see, we just added isNotEmpty to arrays, but what about sets and dictionaries? Sure, we could repeat ourself and copy the code into extensions for those, but there’s a better solution: Array, Set, and Dictionary all conform to a built-in protocol called Collection, through which they get functionality such as contains(), sorted(), reversed(), and more.

 This is important, because Collection is also what requires the isEmpty property to exist. So, if we write an extension on Collection, we can still access isEmpty because it’s required. This means we can change Array to Collection in our code to get this: (i've duplicated it for the flow of this playground, but Paul meant changing array at ther top of the page
 */


extension Collection {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}

//With that one word change in place, we can now use isNotEmpty on arrays, sets, and dictionaries, as well as any other types that conform to Collection. Believe it or not, that tiny extension exists in thousands of Swift projects because so many other people find it easier to read.

//More importantly, by extending the protocol we’re adding functionality that would otherwise need to be done inside individual structs. This is really powerful, and leads to a technique Apple calls protocol-oriented programming – we can list some required methods in a protocol, then add default implementations of those inside a protocol extension. All conforming types then get to use those default implementations, or provide their own as needed.

//For example, if we had a protocol like this one:
protocol Person {
    var name: String { get }
    func sayHello()
}

//That means all conforming types must add a sayHello() method, but we can also add a default implementation of that as an extension like this:

extension Person {
    func sayHello() {
        print("Hi, I'm \(name)")
    }
}


//And now conforming types can add their own sayHello() method if they want, but they don’t need to – they can always rely on the one provided inside our protocol extension.

//So, we could create an employee without the sayHello() method:

struct Employee: Person {
    let name: String
}

//But because it conforms to Person, we could use the default implementation we provided in our extension:

let taylor = Employee(name: "Taylor Swift")
taylor.sayHello()

//Swift uses protocol extensions a lot, but honestly you don’t need to understand them in great detail just yet – you can build fantastic apps without ever using a protocol extension. At this point you know they exist and that’s enough!



// Examples

protocol Politician {
    var isDirty: Bool { get set }
    func takeBribe()
}
extension Politician {
    func takeBribe() {
        if isDirty {
            print("Thank you very much!")
        } else {
            print("Someone call the police!")
        }
    }
}


protocol Anime {
    var availableLanguages: [String] { get set }
    func watch(in language: String)
}
extension Anime {
    func watch(in language: String) {
        if availableLanguages.contains(language) {
            print("Now playing in \(language)")
        } else {
            print("Unrecognized language.")
        }
    }
}




protocol Hamster {
    var name: String { get set }
    func runInWheel(minutes: Int)
}



extension Hamster {
    func runInWheel(minutes: Int) {
        print("\(name) is going for a run.")
        for _ in 0..<minutes {
            print("Whirr whirr whirr")
        }
    }
}



