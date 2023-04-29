import Cocoa

// For Loop

let platforms = ["iOS", "macOS", "tvOS", "watchOS"]


// os is the loop variable
for os in platforms {
    //This is the loop body
    print("Swift works great on \(os)")
} // One assignment of the loop variable and one pass through the loop body is called a loop iteration

// 1...12 is a range of 1 to 12, including 12. A range is a data type in swift
// x...y - closed range operator
// x..<y - half-open range
// x...  - one-sided range (this would be good for saying "from 1 to the end of array"

for i in 1...12 {
    print("The \(i) times table")
    
    for j in 1...12 {
        print("      \(j) x \(i) is \(j * i)")
    }
    
    print()
}

for number in [2, 3, 5] {
    print("\(number) is a prime number.")
}


for i in 1...5 {
    print("Counting from 1 through 5: \(i)")
}

for i in 1..<5 {
    print("Counting from 1 up to 5: \(i)")
}


var lyric = "Haters gonna"

for _ in 1...5 {
    lyric += " hate"
}

print(lyric)


// While loop - loop that will continue running until a condition is false


var countdown = 10

while countdown > 0 {
    print("\(countdown)")
    countdown -= 1
}

print("blast off")


let id = Int.random(in: 1...1000)
let amount = Double.random(in: 0...1)

var roll = 0

while roll != 20 {
    roll = Int.random(in: 1...20)
    print("I rolled a \(roll)")
}

print("Critical hit!")


var page: Int = 0
while page <= 5 {
    page += 1
    print("I'm reading page \(page).")
}

var number: Int = 10
while number > 0 {
    number -= 2
    if number % 2 == 0 {
        print("\(number) is an even number.")
    }
}


// Skip items in a loop
// Continue - skip remainder of current iteration
// Break - exit the loop and carry on after the loop

// Continue

//lets print just the picture files

let filenames = ["me.jpg", "work.txt", "sophie.jpg"]

for filename in filenames {
    if filename.hasSuffix(".jpg") == false {
        continue
    }
    
    print(filename)
}

let number1 = 4
let number2 = 14
var multiples = [Int]()

for i in 1...100_000 {
    if i.isMultiple(of: number1) && i.isMultiple(of: number2) {
        multiples.append(i)
        
        if multiples.count == 10 {
            break
        }
    }
}

print(multiples)

// Labelled Statements

let options = ["up", "down", "left", "right"]
let secretCombination = ["up", "down", "right"]

outerLoop: for option1 in options {
    for option2 in options {
        for option3 in options {
            print("In loop")
            let attempt = [option1, option2, option3]

            if attempt == secretCombination {
                print("The combination is \(attempt)!")
                break outerLoop // statement label allows us to break out of the outerloop
            }
        }
    }
}
