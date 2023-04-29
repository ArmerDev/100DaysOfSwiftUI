//
//  ContentView2.swift
//  CreatingAForm
//
//  Created by James Armer on 29/04/2023.
//

import SwiftUI

struct ContentView2: View {
    var body: some View {
        Form {
            Group {
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
            }
            
            Group {
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
            }
            
            /*
             
             As you can see in the preview, Groups do not create separate groups in the form. This can be achieved with Sections, as seen in ContentView3
             
             */
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
