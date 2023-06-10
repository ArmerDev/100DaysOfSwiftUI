//
//  ContentView.swift
//  ConditionalSavingOfNSManagedObjectContext
//
//  Created by James Armer on 10/06/2023.
//

import SwiftUI

/*
 We’ve been using the save() method of NSManagedObjectContext to flush out all unsaved changes to permanent storage, but what we haven’t done is check whether any changes actually need to be saved. This is often OK, because it’s common to place save() calls only after we specifically made a change such as inserting or deleting data.

 However, it’s also common to bulk your saves together so that you save everything at once, which has a lower performance impact. In fact, Apple specifically states that we should always check for uncommitted changes before calling save(), to avoid making Core Data do work that isn’t required.

 Fortunately, we can check for changes in two ways. First, every managed object is given a hasChanges property, that is true when the object has unsaved changes. And, the entire context also contains a hasChanges property that checks whether any object owned by the context has changes.

 So, rather than call save() directly you should always wrap it in a check first, like this:

 if moc.hasChanges {
     try? moc.save()
 }
 It’s a small change to make, but it matters – there’s no point doing work that isn’t needed, no matter how small, particularly because if you do enough small work you realize you’ve stacked up some big work.
 */

struct ContentView: View {
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple]), center: .center, startRadius: 350, endRadius: 100)
                .ignoresSafeArea()
            Text("Check for changes before saving to CoreData")
                .font(.title)
                .multilineTextAlignment(.center)
                .bold()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
