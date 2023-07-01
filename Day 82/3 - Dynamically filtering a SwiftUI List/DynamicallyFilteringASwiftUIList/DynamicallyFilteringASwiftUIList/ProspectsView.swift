//
//  ProspectsView.swift
//  DynamicallyFilteringASwiftUIList
//
//  Created by James Armer on 01/07/2023.
//

import SwiftUI

struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @EnvironmentObject var prospects: Prospects

    let filter: FilterType
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button {
                    let prospect = Prospect()
                    prospect.name = "Paul Hudson"
                    prospect.emailAddress = "paul@hackingwithswift.com"
                    prospects.people.append(prospect)
                } label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            }
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted People"
        case .uncontacted:
            return "Uncontacted People"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
}

/*
 When filter() runs, it passes every element in the people array through our test. So, $0.isContacted means “does the current element have its isContacted property set to true?” All items in the array that pass that test – that have isContacted set to true – will be added to a new array and sent back from filteredResults. And when we use !$0.isContacted we get the opposite: only prospects that haven’t been contacted get included.

 With that computed property in place, we can now create a List to loop over that array. This will show both the title and email address for each prospect using a VStack, and we’ll also use a ForEach so we can add deleting later on.

 Replace the existing text view in ProspectsView with this:

 List {
     ForEach(filteredProspects) { prospect in
         VStack(alignment: .leading) {
             Text(prospect.name)
                 .font(.headline)
             Text(prospect.emailAddress)
                 .foregroundColor(.secondary)
         }
     }
 }
 If you run the app again you’ll see things are starting to look much better.

 Before we move on, I want you to think about this: now that we’re using a computed property, how does SwiftUI know to refresh the view when the property changed? The answer is actually quite simple: it doesn’t.

 When we added an @EnvironmentObject property to ProspectsView, we also asked SwiftUI to reinvoke the body property whenever that property changes. So, whenever we insert a new person into the people array its @Published property wrapper will announce the update to all views that are watching it, and SwiftUI will reinvoke the body property of ProspectsView. That in turn will calculate our computed property again, so the List will change.

 I love the way SwiftUI transparently takes on so much work for us here, which means we can focus on how we filter and present our data rather than how to connect up all the pipes to make sure things are kept up to date.
 */

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
