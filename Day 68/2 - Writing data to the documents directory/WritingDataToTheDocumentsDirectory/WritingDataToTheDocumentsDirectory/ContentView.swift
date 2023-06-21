//
//  ContentView.swift
//  WritingDataToTheDocumentsDirectory
//
//  Created by James Armer on 21/06/2023.
//

import SwiftUI

/*
 Previously we looked at how to read and write data to UserDefaults, which works great for user settings or small amounts of JSON. However, it’s generally not a great place to store data, particularly if you think you’ll start storing more in the future.
 
 In this app we’re going to be letting users create as much data as they want, which means we want a better storage solution than just throwing things into UserDefaults and hoping for the best. Fortunately, iOS makes it very easy to read and write data from device storage, and in fact all apps get a directory for storing any kind of documents we want. Files here are automatically synchronized with iCloud backups, so if the user gets a new device then our data will be restored along with all the other system data – we don’t even need to think about it.
 
 There is a catch – isn’t there always? – and it’s that all iOS apps are sandboxed, which means they run in their own container with a hard to guess directory name. As a result, we can’t – and shouldn’t try to – guess the directory where our app is installed, and instead need to rely on Apple’s API for finding our app’s documents directory.
 
 There is no nice way of doing this, so I nearly always just copy and paste the same helper method into my projects, and we’re going to do exactly the same thing now. This uses a new class called FileManager, which can provide us with the document directory for the current user. In theory this can return several path URLs, but we only ever care about the first one.
 */

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}

/*
 That documents directory is ours to do with as we please, and because it belongs to the app it will automatically get deleted if the app itself gets deleted. Other than physical device limitations there is no limit to how much we can store, although remember that users can use the Settings app to see how much storage your app takes up – be respectful!
 
 Now that we have a directory to work with, we can read and write files there freely. You already met String(contentsOf:) and Data(contentsOf:) for reading data, but for writing data we need to use the write(to:) method. When used with strings this takes three parameters:
 
 A URL to write to.
 Whether to make the write atomic, which means “all at once”.
 What character encoding to use.
 The first of those can be created by combining the documents directory URL with a filename, such as myfile.txt.
 
 The second should nearly always be set to true. If this is set to false and we try to write a big file, it’s possible that another part of our app might try and read the file while it’s still being written. This shouldn’t cause a crash or anything, but it does mean that it’s going to read only part of the data, because the other part hasn’t been written yet. Atomic writing causes the system to write our full file to a temporary filename (not the one we asked for), and when that’s finished it does a simple rename to our target filename. This means either the whole file is there or nothing is.
 
 The third parameter is something we looked at briefly in project 5, because we had to use a Swift string with an Objective-C API. Back then we used the character encoding UTF-16, which is what Objective-C uses, but Swift’s native encoding is UTF-8, so we’re going to use that instead.
 
 To put all this code into action, we’re going to modify the default text view of our template so that it writes a test string to a file in the documents directory, reads it back into a new string, then prints it out – the complete cycle of reading and writing data.
 */

struct ContentView2: View {
    var body: some View {
        Text("Hello, world!")
            .onTapGesture {
                let str = "Test Message"
                let url = getDocumentsDirectory().appendingPathComponent("message.txt")
                
                
                do {
                    try str.write(to: url, atomically: true, encoding: .utf8)
                    
                    let input = try String(contentsOf: url)
                    print(input)
                } catch {
                    print(error.localizedDescription)
                }
            }
        
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}

/*
 When that runs you should be able to tap the label to see “Test message” printed to Xcode’s debug output area.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
    }
}
