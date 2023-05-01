import UIKit

// Booleans

// Booleans simply store either true or false.

// We have come across them before, in code similar to the code below. These both print a boolean value, either true or false.
let filename = "paris.jpg"
print(filename.hasSuffix(".jpg"))

let number = 120
print(number.isMultiple(of: 3))

// Making a Boolean is just like making the other data types, except you should assign an initial value of either true or false
let goodDogs = true
let gameOver = false

// You can also assign a Boolean’s initial value from some other code, as long as ultimately it’s either true or false
let isMultiple = 120.isMultiple(of: 3)

/*
 Unlike the other types of data, Booleans don’t have arithmetic operators such as + and - – after all, what would true + true equal? However, Booleans do have one special operator, !, which means “not”. This flips a Boolean’s value from true to false, or false to true.
 */

// For example, we could flip a Boolean’s value like this:
var isAuthenticated = false
isAuthenticated = !isAuthenticated
print(isAuthenticated)
isAuthenticated = !isAuthenticated
print(isAuthenticated)

/*
 That will print “true” then “false” when it runs, because isAuthenticated started as false, and we set it to not false, which is true, then flip it again so it’s back to false.

 Booleans do have a little extra functionality that can be useful. In particular, if you call toggle() on a Boolean it will flip a true value to false, and a false value to true. To try this out, try making gameOver a variable and modifying it like this:
 */
var gameOver = false
print(gameOver)

gameOver.toggle()
print(gameOver)

/*
 That will print false first, then after calling toggle() will print true. Yes, that’s the same as using ! just in slightly less code, but it’s surprisingly useful when you’re dealing with complex code!
 */
