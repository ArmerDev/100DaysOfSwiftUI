//
//  ProspectsView.swift
//  ScanningQRCodesWithSwiftUI
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
                }
            }
            .navigationTitle(title)
            .toolbar {
                
                /*
                 Earlier we added some test functionality to the “Scan” button so we could insert some sample data, but we don’t need that any more because we’re about to scan real QR codes. So, replace the action code for the toolbar button with this:
                 */
                Button {
                   isShowingScanner = true
                    
                    /*
                     When it comes to handling the result of the QR scanning, I’ve made the CodeScanner package do literally all the work of figuring out what the code is and how to send it back, so all we need to do here is catch the result and process it somehow.

                     When the CodeScannerView finds a code, it will call a completion closure with a Result instance either containing details about the code that was found or an error saying what the problem was – perhaps the camera wasn’t available, or the camera wasn’t able to scan codes, for example. Regardless of what code or error comes back, we’re just going to dismiss the view; we’ll add more code shortly to do more work.

                     Start by adding import CodeScanner ProspectsView.swift, and then add the handleScan method:
                     */
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
 Before we show the scanner and try to handle its result, we need to ask the user for permission to use the camera:

 - Go to your target’s configuration options under its Info tab.
 
 - Right-click on an existing key and select Add Row.
 
 - Select “Privacy - Camera Usage Description” for the key.
 
 - For the value enter “We need to scan QR codes.”
 
 And now we’re ready to scan some QR codes! We already have the isShowingScanner state that determines whether to show a code scanner or not, so we can now attach a sheet() modifier to present our scanner UI.

 Creating a CodeScanner view takes three parameters:

 - An array of the types of codes we want to scan. We’re only scanning QR codes in this app so [.qr] is fine, but iOS supports lots of other types too.
 
 - A string to use as simulated data. Xcode’s simulator doesn’t support using the camera to scan codes, so CodeScannerView automatically presents a replacement UI so we can still test that things work. This replacement UI will automatically send back whatever we pass in as simulated data.
 
 - A completion function to use. This could be a closure, but we just wrote the handleScan() method so we’ll use that.
 
 So, add this below the existing toolbar() modifier in ProspectsView:

 .sheet(isPresented: $isShowingScanner) {
     CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
 }
 
 That’s enough to get most of this screen working, but there is one last step: replacing the // more code to come comment in handleScan() with some actual functionality to process the data we found.

 If you recall, the QR codes we’re generating are a name, then a line break, then an email address, so if our scanning result comes back successfully then we can pull apart the code string into those components and use them to create a new Prospect. If code scanning failed, we’ll just print an error – you’re welcome to show some more interesting UI if you want!

 Replace the // more code to come comment with this:

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
 Go ahead and run the code now. If you’re using the simulator you’ll see a test UI appear, and tapping anywhere will dismiss the view and send back our simulated data. If you’re using a real device you’ll see a permission message asking the user to allow camera use, and you grant that you’ll see a scanner view. To test out scanning on a real device, simultaneously launch the app in the simulator and switch to the Me tab – your phone should be able to scan the simulator screen on your computer.
 */

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
