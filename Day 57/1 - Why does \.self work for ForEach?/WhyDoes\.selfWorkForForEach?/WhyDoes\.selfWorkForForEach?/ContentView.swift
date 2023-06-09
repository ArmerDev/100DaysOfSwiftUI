//
//  ContentView.swift
//  WhyDoes\.selfWorkForForEach?
//
//  Created by James Armer on 09/06/2023.
//

import SwiftUI

/*
 Previously we looked at the various ways ForEach can be used to create dynamic views, but they all had one thing in common: SwiftUI needs to know how to identify each dynamic view uniquely so that it can animate changes correctly.

 If an object conforms to the Identifiable protocol, then SwiftUI will automatically use its id property for uniquing. If we don’t use Identifiable, then we can use a keypath for a property we know to be unique, such as a book’s ISBN number. But if we don’t conform to Identifiable and don’t have a keypath that is unique, we can often use \.self.

 Previously we used \.self for primitive types such as Int and String, like this:

 List {
     ForEach([2, 4, 6, 8, 10], id: \.self) {
         Text("\($0) is even")
     }
 }
 
 With Core Data we can use a unique identifier if we want, but we can also use \.self and also have something that works well.

 When we use \.self as an identifier, we mean “the whole object”, but in practice that doesn’t mean much – a struct is a struct, so it doesn’t have any sort of specific identifying information other than its contents. So what actually happens is that Swift computes the hash value of the struct, which is a way of representing complex data in fixed-size values, then uses that hash as an identifier.

 Hash values can be generated in any number of ways, but the concept is identical for all hash-generating functions:

 Regardless of the input size, the output should be the same fixed size.
 Calculating the same hash for an object twice in a row should return the same value.
 Those two sound simple, but think about it: if we get the hash of “Hello World” and the hash of the complete works of Shakespeare, both will end up being the same size. This means it’s not possible to convert the hash back into its original value – we can’t convert 40 seemingly random hexadecimal letters and numbers into the complete works of Shakespeare.

 Hashes are commonly used for things like data verification. For example, if you download a 8GB zip file, you can check that it’s correct by comparing your local hash of that file against the server’s – if they match, it means the zip file is identical. Hashes are also used with dictionary keys and sets; that’s how they get their fast look up.

 All this matters because when Xcode generates a class for our managed objects, it makes that class conform to Hashable, which is a protocol that means Swift can generate hash values for it, which in turn means we can use \.self for the identifier. This is also why String and Int work with \.self: they also conform to Hashable.

 Hashable is a bit like Codable: if we want to make a custom type conform to Hashable, then as long as everything it contains also conforms to Hashable then we don’t need to do any work. To demonstrate this, we could create a custom struct that conforms to Hashable rather than Identifiable, and use \.self to identify it:
 */

 struct Student: Hashable {
     let name: String
 }

 struct ContentView: View {
     let students = [Student(name: "Harry Potter"), Student(name: "Hermione Granger")]

     var body: some View {
         List(students, id: \.self) { student in
             Text(student.name)
         }
     }
 }

/*
 We can make Student conform to Hashable because all its properties already conform to Hashable, so Swift will calculate the hash values of each property then combine them into one hash that represents the whole struct. Of course, if we end up with two students that have the same name we’ll hit problems, just like if we had an array of strings with two identical strings.

 Now, you might think this leads to a problem: if we create two Core Data objects with the same values, they’ll generate the same hash, and we’ll hit animation problems. However, Core Data does something really smart here: the objects it creates for us actually have a selection of other properties beyond those we defined in our data model, including one called the object ID – an identifier that is unique to that object, regardless of what properties it contains. These IDs are similar to UUID, although Core Data generates them sequentially as we create objects.

 So, \.self works for anything that conforms to Hashable, because Swift will generate the hash value for the object and use that to uniquely identify it. This also works for Core Data’s objects because they already conform to Hashable. So, if you want to use a specific identifier that’s awesome, but you don’t need to because \.self is also an option.

 Warning: Although calculating the same hash for an object twice in a row should return the same value, calculating it between two runs of your app – i.e., calculating the hash, quitting the app, relaunching, then calculating the hash again – can return different values.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
