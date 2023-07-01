//
//  ProspectsView.swift
//  AddingOptionsWithSwipeActions
//
//  Created by James Armer on 01/07/2023.
//

import SwiftUI
import CodeScanner

struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @EnvironmentObject var prospects: Prospects
    
    @State private var isShowingScanner = false

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
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button {
                   isShowingScanner = true

                } label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
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
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            
            prospects.people.append(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

/*
 While the text for that is OK and the context menu displays correctly, the action doesn’t do anything. Well, that’s not strictly true: it does toggle the Boolean, but it doesn’t actually update the UI.

 This problem occurs because the people array in Prospects is marked with @Published, which means if we add or remove items from that array a change notification will be sent out. However, if we quietly change an item inside the array then SwiftUI won’t detect that change, and no views will be refreshed.

 To fix this, we need to tell SwiftUI by hand that something important has changed. So, rather than flipping a Boolean in ProspectsView, we are instead going to call a method on the Prospects class to flip that same Boolean while also sending a change notification out.

 Start by adding this method to the Prospects class:

 func toggle(_ prospect: Prospect) {
     objectWillChange.send()
     prospect.isContacted.toggle()
 }
 Important: You should call objectWillChange.send() before changing your property, to ensure SwiftUI gets its animations correct.

 Now you can replace the prospect.isContacted.toggle() action with this:

 prospects.toggle(prospect)
 If you run the app now you’ll see it works much better – scan a user, then bring up the context menu and tap its action to see the user move between the Contacted and Uncontacted tabs.

 We could leave it there, but there’s one more change I want to make. As you saw, changing isContacted directly causes problems, because although the Boolean has changed internally our UI has become stale. If we leave our code as-is, it’s possible we (or other developers) might forget about this problem and try to flip the Boolean directly from elsewhere, which will just cause more bugs.

 Swift can help us mitigate this problem by stopping us from modifying the Boolean outside of Prospects.swift. There’s a specific access control option called fileprivate, which means “this property can only be used by code inside the current file.” Of course, we still want to read that property, and so we can deploy another useful Swift feature: fileprivate(set), which means “this property can be read from anywhere, but only written from the current file” – the exact combination we need to make sure the Boolean is safe to use.

 So, modify the isContacted Boolean in Prospect to this:

 fileprivate(set) var isContacted = false
 It hasn’t affected our project here, but it does help keep us safe in the future. If you were wondering why we put the Prospect and Prospects classes in the same file, now you know!
 */

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
