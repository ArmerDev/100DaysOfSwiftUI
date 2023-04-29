import Cocoa

// Checkpoint 7

/*
 
 make a class hierarch for animals
 
 start with Animal - add a legs property for the number of legs an animal has
 
 Make Dog a subclass of Animal, giving it a speak() method that prints a dog barking string, but each subclass should print something different
 
 
 Make Corgi and Poodle subclass of Dog
 
 Make Cat an Animal subclass. Ass a speak() method, with each subclass printing something different, and an isTame Boolean, set with an initialiser
 
 Make Persian and Lian as subclasses of Cat
 
 
 */

// 100 Days of SwiftUI
// Checkpoint 7

class Animal {
    let numberOfLegs: Int
    
    init(numberOfLegs: Int) {
        self.numberOfLegs = numberOfLegs
    }
}

class Dog: Animal {
    func speak() {
        print("Bark, Bark!")
    }
}

class Corgi: Dog {
    override func speak() {
        print("Corgi Bark, Bark!")
    }
}

class Poodle: Dog {
    override func speak() {
        print("Poodle Bark, Bark!")
    }
}

class Cat: Animal {
    let isTame: Bool
    
    init(numberOfLegs: Int, isTame: Bool) {
        self.isTame = isTame
        super.init(numberOfLegs: numberOfLegs)
    }
    
    func speak() {
        print("Meow, Meow!")
    }
}

class Persian: Cat {
    override func speak() {
        print("Persian Meow, Meow!")
    }
}

class Lion: Cat {
    override func speak() {
        print("Lion Meow, Meow!")
    }
}


let random = Lion(numberOfLegs: 4, isTame: false)
random.speak()
