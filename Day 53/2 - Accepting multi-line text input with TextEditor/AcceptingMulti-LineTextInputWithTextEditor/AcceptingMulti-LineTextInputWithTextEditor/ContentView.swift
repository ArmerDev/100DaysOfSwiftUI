//
//  ContentView.swift
//  AcceptingMulti-LineTextInputWithTextEditor
//
//  Created by James Armer on 03/06/2023.
//

import SwiftUI

/*
 We’ve used SwiftUI’s TextField view several times already, and it’s great for times when the user wants to enter short pieces of text. However, for longer pieces of text you should switch over to using a TextEditor view instead: it also expects to be given a two-way binding to a text string, but it has the additional benefit of allowing multiple lines of text – it’s much better for accepting longer strings from the user.

 Mostly because it has nothing special in the way of configuration options, using TextEditor is actually easier than using TextField – you can’t adjust its style or add placeholder text, you just bind it to a string. However, you do need to be careful to make sure it doesn’t go outside the safe area, otherwise typing will be tricky; embed it in a NavigationView, a Form, or similar.

 For example, we could create the world’s simplest notes app by combining TextEditor with @AppStorage, like this:
 */

struct ContentView: View {
    @AppStorage("notes") private var notes = ""
    
    var body: some View {
        NavigationView {
            TextEditor(text: $notes)
                .navigationTitle("Notes")
                .padding()
        }
    }
}

/*
 Tip: @AppStorage is not designed to store secure information, so never use it for anything private.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
