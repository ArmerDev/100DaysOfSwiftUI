//
//  ContentView.swift
//  AddingConformanceToComparableForCustomTypes
//
//  Created by James Armer on 21/06/2023.
//

import SwiftUI

/*
 When you think about it, we take a heck of a lot of stuff for granted when we write Swift code. For example, if we write 4 < 5, we expect that to return true – the developers of Swift (and LLVM, larger compiler project that sits behind Swift) have already done all the hard work of checking whether that calculation is actually true, so we don’t have to worry about it.

 But what Swift does really well is extend functionality into lots of places using protocols and protocol extensions. For example, we know that 4 < 5 is true because we’re able to compare two integers and decide whether the first one comes before or after the second. Swift extends that functionality to arrays of integers: we can compare all the integers in an array to decide whether each one should come before or after the others. Swift then uses that result to sort the array.
 */

struct ContentView: View {
    let values = [1, 5, 3, 6, 2, 9].sorted()
    
    var body: some View {
        List(values, id: \.self) {
            Text(String($0))
        }
    }
}

/*
 We don’t need to tell sorted() how it should work, because it understands how arrays of integers work.

 Now consider a struct like this one:
 */

struct User: Identifiable {
    let id = UUID()
    let firstName: String
    let lastName: String
}

/*
 We could make an array of those users, and use them inside a List like this:
 */

struct ContentView2: View {
    let users = [
        User(firstName: "Arnold", lastName: "Rimmer"),
        User(firstName: "Kristine", lastName: "Kochanski"),
        User(firstName: "David", lastName: "Lister")
    ]
    
    var body: some View {
        List(users) { user in
            Text("\(user.lastName), \(user.firstName)")
        }
    }
}

/*
 That will work just fine, because we made the User struct conform to Identifiable.

 But how about if we wanted to show those users in a sorted order? If we modify the code to this it won’t work:

     let users = [
         User(firstName: "Arnold", lastName: "Rimmer"),
         User(firstName: "Kristine", lastName: "Kochanski"),
         User(firstName: "David", lastName: "Lister"),
     ].sorted()
 
 Swift doesn’t understand what sorted() means here, because it doesn’t know whether to sort by first name, last name, both, or something else.

 Previously I showed you how we could provide a closure to sorted() to do the sorting ourselves, and we could use the same here:
 */

struct ContentView3: View {
    let users = [
        User(firstName: "Arnold", lastName: "Rimmer"),
        User(firstName: "Kristine", lastName: "Kochanski"),
        User(firstName: "David", lastName: "Lister"),
    ].sorted {
        $0.lastName < $1.lastName
    }
    
    var body: some View {
        List(users) { user in
            Text("\(user.lastName), \(user.firstName)")
        }
    }
}

/*
 That absolutely works, but it’s not an ideal solution for two reasons.

 First, this is model data, by which I mean that it’s affecting the way we work with the User struct. That struct and its properties are our data model, and in a well-developed application we don’t really want to tell the model how it should behave inside our SwiftUI code. SwiftUI represents our view, i.e. our layout, and if we put model code in there then things get confused.

 Second, what happens if we want to sort User arrays in multiple places? You might copy and paste the closure once or twice, before realizing you’re just creating a problem for yourself: if you end up changing your sorting logic so that you also use firstName if the last name is the same, then you need to search through all your code to make sure all the closures get updated.

 Swift has a better solution. Arrays of integers get a simple sorted() method with no parameters because Swift understands how to compare two integers. In coding terms, Int conforms to the Comparable protocol, which means it defines a function that takes two integers and returns true if the first should be sorted before the second.

 We can make our own types conform to Comparable, and when we do so we also get a sorted() method with no parameters. This takes two steps:

 Add the Comparable conformance to the definition of User.
 Add a method called < that takes two users and returns true if the first should be sorted before the second.
 Here’s how that looks in code:
 */

struct User2: Identifiable, Comparable {
    let id = UUID()
    let firstName: String
    let lastName: String

    static func <(lhs: User2, rhs: User2) -> Bool {
        lhs.lastName < rhs.lastName
    }
}

/*
 There’s not a lot of code in there, but there is still a lot to unpack.

 First, yes the method is just called <, which is the “less than” operator. It’s the job of the method to decide whether one user is “less than” (in a sorting sense) another, so we’re adding functionality to an existing operator. This is called operator overloading, and it can be both a blessing and a curse.

 Second, lhs and rhs are coding conventions short for “left-hand side” and “right-hand side”, and they are used because the < operator has one operand on its left and one on its right.

 Third, this method must return a Boolean, which means we must decide whether one object should be sorted before another. There is no room for “they are the same” here – that’s handled by another protocol called Equatable.

 Fourth, the method must be marked as static, which means it’s called on the User struct directly rather than a single instance of the struct.

 Finally, our logic here is pretty simple: we’re just passing on the comparison to one of our properties, asking Swift to use < for the two last name strings. You can add as much logic as you want, comparing as many properties as needed, but ultimately you need to return true or false.

 Tip: One thing you can’t see in that code is that conforming to Comparable also gives us access to the > operator – greater than. This is the opposite of <, so Swift creates it for us by using < and flipping the Boolean between true and false.

 Now that our User struct conforms to Comparable, we automatically get access to the parameter-less version of sorted(), which means this kind of code works now:
 */

struct ContentView4: View {
    let users = [
        User2(firstName: "Arnold", lastName: "Rimmer"),
        User2(firstName: "Kristine", lastName: "Kochanski"),
        User2(firstName: "David", lastName: "Lister"),
    ].sorted()
    
    var body: some View {
        List(users) { user in
            Text("\(user.lastName), \(user.firstName)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
        ContentView3()
            .previewDisplayName("ContentView 3")
        ContentView4()
            .previewDisplayName("ContentView 4")
    }
}
