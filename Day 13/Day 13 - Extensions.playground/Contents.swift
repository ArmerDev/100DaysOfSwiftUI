import Cocoa

// Extensions


//Extensions let us add functionality to any type, whether we created it or someone else created it – even one of Apple’s own types.

// Here is a string with whitespace

var quote = "   The truth is rarely pure and never simple   "

//If we wanted to trim the whitespace and newlines on either side, we could do so like this:

let trimmed = quote.trimmingCharacters(in: .whitespacesAndNewlines)



//Having to call trimmingCharacters(in:) every time is a bit wordy, so let’s write an extension to make it shorter:

extension String {
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
        //self. refers to the current string instance - whatever you called this .trimmed() method on.
    }
}


// now, we can just do this instead...

let newTrimmed = quote.trimmed()



// we could have just created a global function to achieve the same thing, like this...

func trimmed(_ string: String) -> String {
    string.trimmingCharacters(in: .whitespacesAndNewlines)
}

let otherTrimmed = trimmed(quote)

/*
 
 However, the extension has a number of benefits over the global function, including:

 - When you type quote. Xcode brings up a list of methods on the string, including all the ones we add in extensions. This makes our extra functionality easy to find.

- Writing global functions makes your code rather messy – they are hard to organize and hard to keep track of. On the other hand, extensions are naturally grouped by the data type they are extending.

 - Because your extension methods are a full part of the original type, they get full access to the type’s internal data. That means they can use properties and methods marked with private access control, for example.


 What’s more, extensions make it easier to modify values in place – i.e., to change a value directly, rather than return a new value.
 
 For example, earlier we wrote a trimmed() method that returns a new string with whitespace and newlines removed, but if we wanted to modify the string directly we could add this to the extension:
 
 */

extension String {
    mutating func trim() {
        self = self.trimmed()
    }
}


//Because the quote string was created as a variable, we can trim it in place like this:

quote.trim()

/*
 Notice how the method has slightly different naming now: when we return a new value we used trimmed(), but when we modified the string directly we used trim(). This is intentional, and is part of Swift’s design guidelines: if you’re returning a new value rather than changing it in place, you should use word endings like ed or ing, like reversed().

 Tip: Previously I introduced you to the sorted() method on arrays. Now you know this rule, you should realize that if you create a variable array you can use sort() on it to sort the array in place rather than returning a new copy.

 You can also use extensions to add properties to types, but there is one rule: they must only be computed properties, not stored properties. The reason for this is that adding new stored properties would affect the actual size of the data types – if we added a bunch of stored properties to an integer then every integer everywhere would need to take up more space in memory, which would cause all sorts of problems.

 Fortunately, we can still get a lot done using computed properties. For example, one property I like to add to strings is called lines, which breaks the string up into an array of individual lines. This wraps another string method called components(separatedBy:), which breaks the string up into a string array by splitting it on a boundary of our choosing. In this case we’d want that boundary to be new lines, so we’d add this to our string extension:
 */

extension String {
    var lines: [String] {
        self.components(separatedBy: .newlines)
    }
}

//With that in place we can now read the lines property of any string, like so:


let lyrics = """
But I keep cruising
Can't stop, won't stop moving
It's like I got this music in my mind
Saying it's gonna be alright
"""

print(lyrics.lines.count)

/*
 Whether they are single lines or complex pieces of functionality, extensions always have the same goal: to make your code easier to write, easier to read, and easier to maintain in the long term.

 Before we’re done, I want to show you one really useful trick when working with extensions. You’ve seen previously how Swift automatically generates a memberwise initializer for structs, like this:
 */

struct BookA {
    let title: String
    let pageCount: Int
    let readingHours: Int
}

let lotr = BookA(title: "Lord of the Rings", pageCount: 1178, readingHours: 24)

/*
 I also mentioned how creating your own initializer means that Swift will no longer provide the memberwise one for us. This is intentional, because a custom initializer means we want to assign data based on some custom logic, like this:
 */

struct BookB {
    let title: String
    let pageCount: Int
    let readingHours: Int

    init(title: String, pageCount: Int) {
        self.title = title
        self.pageCount = pageCount
        self.readingHours = pageCount / 50
    }
}

/*
 If Swift were to keep the memberwise initializer in this instance, it would skip our logic for calculating the approximate reading time.

 However, sometimes you want both – you want the ability to use a custom initializer, but also retain Swift’s automatic memberwise initializer. In this situation it’s worth knowing exactly what Swift is doing: if we implement a custom initializer inside our struct, then Swift disables the automatic memberwise initializer.

 That extra little detail might give you a hint on what’s coming next: if we implement a custom initializer inside an extension, then Swift won’t disable the automatic memberwise initializer. This makes sense if you think about it: if adding a new initializer inside an extension also disabled the default initializer, one small change from us could break all sorts of other Swift code.

 So, if we wanted our Book struct to have the default memberwise initializer as well as our custom initializer, we’d place the custom one in an extension, like this:
 */

extension BookA {
    init(title: String, pageCount: Int) {
        self.title = title
        self.pageCount = pageCount
        self.readingHours = pageCount / 50
    }
}


//let lorthbinb = BookA(title: <#T##String#>, pageCount: <#T##Int#>)





//Examples

extension String {
    var isLong: Bool {
        return count > 25
    }
}


extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) { return self }
        return "\(prefix)\(self)"
    }
}



extension String {
    func isUppercased() -> Bool {
        return self == self.uppercased()
    }
}



