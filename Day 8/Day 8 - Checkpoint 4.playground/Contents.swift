import Cocoa

enum SquareRootError: Error {
    case outOfBounds
    case noRoot
}

func squareRoot(_ integer: Int) throws -> Int {
    if integer < 1      { throw SquareRootError.outOfBounds }
    if integer > 10_000 { throw SquareRootError.outOfBounds }
    
    for i in 1...100 {
        if i * i == integer {
            return i
        }
    }
    throw SquareRootError.noRoot
}

do {
    let answer = try squareRoot(25)
    print("Answer is \(answer)")
} catch SquareRootError.outOfBounds {
    print("Integer out of bounds. Enter number between 1 and 10,000")
} catch SquareRootError.noRoot {
    print("No Root")
} catch {
    print("Error")
}


