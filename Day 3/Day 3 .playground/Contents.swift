import Cocoa

//How to store ordered data in arrays

//Arrays will automatically adjust themselves to have enough space to fit the amount of values

var beatles = ["John", "Paul", "George","Ringo"]
let numbers = [4, 8, 15, 16, 23, 42]
var temperatures = [25.3, 28.2, 26.4]

// We can ask for a value out of the array by using an index - remember, index starts at 0, i.e., the first values position in the array is at index 0

print(beatles[0])

//You can add an item to an array using .append
beatles.append("Adrian")

//You can not append a different data type into an array. Arrays can only hold one data type.

//temperatures.append("cold") // this won't work
 
//You also can't mix data from two arrays holding different types.
//For example, you can't mix a value from an array of strings with an array of int

/*
let firstBeatle = beatles[0]
let firstNumber = numbers[0]
let notAllowed = firstBeatle + firstNumber
*/

//This is because of type safety. Yes, they are both arrays, but they are specialised arrays - one is an array of strings, one is an array of ints.

var scores = Array<Int>()
// The line above shows that we have a specialised array, specifically integers, which is inside the angle brackets.

//The parenthesis exist to customise the way you create an array.
//For example, you might say "give me an array of integers, but i want to have 1,000 example integers to start me off, each with a value of 0, and I'll change them later, but give me 1,000 zeros to start with"

scores.append(100)
scores.append(80)
scores.append(85)
print(scores[1])

var albums = Array<String>()
albums.append("Fearless")

//Arrays are so common in Swift that there is a special shorthand way to refer to them
var alternativeAlbums = [String]()
// which is the same as line 44, but its just shorter

//Remember Swift's type safety means it must always know what type of data an array is storing. That might mean being explicit "We are holding an array of strings". But, if we provide an initial value, swift can work this out itself.

var disneySongs = ["Colors of the Wind"]
disneySongs.append("Arabian Nights")


//Some useful pieces of functionality that comes with array

//1 - You can use count to read how many items are in the array
print(disneySongs.count)

//You can remove items from the array, either by calling remove(at: ) to remove one item by providing the index in the array, or removeAll to clear the array completely

var characters = ["Lana", "Pam", "Ray", "Sterling"]
print(characters.count)
characters.remove(at: 2)
print(characters.count)
characters.removeAll()
print(characters.count)

// 3 - You can check whether one array holds contains a particular item already by using contains

let bondMovies = ["Casino Royale", "Spectre", "No Time to Die"]
print(bondMovies.contains("Frozen"))


//4 - you can sort an array using sorted
let cities = ["London", "Tokyo", "Rome", "Budapest"]
print(cities.sorted())


//5 - you can reverse arrays by calling reversed on it

let presidents = ["Bush", "Obama", "Trump", "Biden"]
let reversedPresidents = presidents.reversed()
print(reversedPresidents)
//print(reversedPresidents) actually prints ReversedCollection<Array<String>>(_base: ["Bush", "Obama", "Trump", "Biden"])
//This is a new data type called a reversed collection of arrays, storing Bush, Obama, Trump and Biden. Its kept the original array intact inside, but it remembers to itself that its reversed. So when you ask for items, it will at that point do the reversing. Its an optimisation. It doesn't actually rearrange all the items because that would be very slow if you had an array of a million strings for example, its easier to say "Yep, its reversed, trust me" and then go backwards over the array later on.

// DICTIONARIES
 
let employee = [
    "name" : "Taylor Swift",
    "job" : "Singer",
    "location" : "Singer"
]

// You can create an empty dictionary by doing...
let myDictionary = [String:String]()
//or
let myDictionary2:[String:String] = [:]



print(employee["job"]) // this gets a warning and also prints Optional("Singer")


print(employee["job", default: "Unknown"])
// This allows us to provide a default value if there isn't anything in the dictionary for the key "job"


let hasGraduated = [
    "Eric": false,
    "Maeve": true,
    "Otis": false
]

let olympics = [
    2012: "London",
    2016: "Rio de Janeiro",
    2021: "Tokyo"
]

print(olympics[2012, default: "Unknown"])

var heights = [String: Int]()
heights["Yao Ming"] = 229
heights["Shaquille O'Neal"] = 216
heights["LeBron James"] = 206

// Note - You can not have multiples of the same key, afterall, they are meant to be unique so you can find things. If you try to create a new dictionary entry using the same key as one thats already entered, you will override the original.


//Below shows how you can add into the dictionary - note how this is different to arrays where you'd have to do .append or sets with .insert
var archEnemies = [String: String]()
archEnemies["Batman"] = "The Joker"
archEnemies["Superman"] = "Lex Luthor"
archEnemies["Batman"] = "Penguin"

print(archEnemies["Batman"])

// Dictionaries have functinality like arrays such as count and removeAll




// SETS - fast data lookup
//similar to arrays, but they don't remember the order and they don't allow duplicated

let actors = Set(["Denzel Washington", "Tom Cruise", "Nicolas Cage", "Samuel L Jackson"])
// notice how this actually creates an array inside the set, which is intentional and is a standard way of making sets from fixed data. Remember the set will automatically remove any duplicate values and will not remember the exact order used in the array
print(actors)

//you could also create on like this
let setOfBlogCategories: Set<String> = ["Swift", "Debugging", "Xcode", "Workflow", "Optimization"]

//Adding items for sets is different to arrays. We don't append, we insert.
var actors2 = Set<String>()
actors2.insert("Denzel Washington")
actors2.insert("Tom Crusie")
actors2.insert("Nicolas Cage")
actors2.insert("Samuel L Jackson")

print(actors2)

// Sets don't preseve the order when we enter them, but they have the advantage of storing their data in a highly optimised order which makes it very very fast to locate items.
//If you had a thousand films, and you wanted to search to see if "Batman Begins" was there, an array would have to search one by one through each element to check if the film is there, which takes time. With Sets, its basically instantaneos, you'd struggle to measure the time meaningfully, even with 10 million items in the set.

// You can use contains, count, and sorted on sets - with sorted, you'll get back a stored array containing the sets items'


// ENUMS
// short for enumeration - is a set of named values that we can create and use in our code.
// Enums help us prevent mistakes and make it easier to write code
// Swift stores enums in a highly optimsed way, which is much more efficient and faster than creating a string and storing it.
enum Weekdays {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
}

// you can also write case once and seperate cases with commas

enum Weather {
    case rain, sun, wind, cloud
}

var day = Weekdays.monday
day = Weekdays.friday
day = Weekdays.thursday

//when you assign a value to variable or contant, its data type becomes fixed. So for enums it means we can skip the name after the first assignment, like below

var todaysWeather = Weather.rain
todaysWeather = .sun




