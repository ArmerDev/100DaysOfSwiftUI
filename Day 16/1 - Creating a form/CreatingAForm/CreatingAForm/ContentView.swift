//
//  ContentView.swift
//  CreatingAForm
//
//  Created by James Armer on 29/04/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Form {
            Text("Hello World")
            Text("Hello World")
            Text("Hello World")
            Text("Hello World")
            Text("Hello World")
            Text("Hello World")
            Text("Hello World")
            Text("Hello World")
            Text("Hello World")
            Text("Hello World")
            //Text("Hello World")

            
            /*
             
             The above Form can contain 10 Text views, but no more than that.
             
             Tip: In case you were curious why 10 rows are allowed but 11 is not, this is a limitation in SwiftUI: it was coded to understand how to add one thing to a form, how to add two things to a form, how to add three things, four things, five things, and more, all the way up to 10, but not beyond – they needed to draw a line somewhere.
             
             This limit of 10 children inside a parent actually applies everywhere in SwiftUI.
            
             If you wanted to have 11 things inside the form you should put some rows inside a Group, as seen in ContentView2
             
            */
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
