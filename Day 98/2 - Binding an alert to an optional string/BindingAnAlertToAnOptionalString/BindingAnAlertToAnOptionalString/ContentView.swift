//
//  ContentView.swift
//  BindingAnAlertToAnOptionalString
//
//  Created by James Armer on 18/07/2023.
//

import SwiftUI

/*
 SwiftUI lets us present an alert with an optional source of truth inside, but it takes a little thinking to get right as you’ll see.

 To demonstrate these optional alerts in action, we’re going to rewrite the way our resort facilities are shown. Right now we have a plain text view generated like this:

     Text(resort.facilities, format: .list(type: .and))
         .padding(.vertical)
     
 We’re going to replace that with icons that represent each facility, and when the user taps on one we’ll show an alert with a description of that facility.

 As usual we’re going to start small then work our way up. First, we need a way to convert facility names like “Accommodation” into an icon that can be displayed. Although this will only happen in ResortView right now, this functionality is exactly the kind of thing that should be available elsewhere in our project. So, we’re going to create a new struct to hold all this information for us.

 Create a new Swift file called Facility.swift, replace its Foundation import with SwiftUI, and give it this code:

     struct Facility: Identifiable {
         let id = UUID()
         var name: String

         private let icons = [
             "Accommodation": "house",
             "Beginners": "1.circle",
             "Cross-country": "map",
             "Eco-friendly": "leaf.arrow.circlepath",
             "Family": "person.3"
         ]

         var icon: some View {
             if let iconName = icons[name] {
                 return Image(systemName: iconName)
                     .accessibilityLabel(name)
                     .foregroundColor(.secondary)
             } else {
                 fatalError("Unknown facility type: \(name)")
             }
         }
     }
     
 As you can see, that conforms to Identifiable so we can loop over an array of facilities with SwiftUI, and internally it looks up a given facility name in a dictionary to return the correct icon. I’ve picked out various SF Symbols icons that work well for the facilities we have, and I also used an accessibilityLabel() modifier for the image to make sure it works well in VoiceOver.

 The next step is to create Facility instances for every of the facilities in a Resort, which we can do in a computed property inside the Resort struct itself:

     var facilityTypes: [Facility] {
         facilities.map(Facility.init)
     }
 
 We can now drop that facilities view into ResortView by replacing this code:

     Text(resort.facilities, format: .list(type: .and))
         .padding(.vertical)
 
 With this:

     HStack {
         ForEach(resort.facilityTypes) { facility in
             facility.icon
                 .font(.title)
         }
     }
     .padding(.vertical)
     
 That loops over each item in the facilities array, converting it to an icon and placing it into a HStack. I used the .font(.title) modifier to make the images larger – using the modifier here rather than inside Facility allows us more flexibility if we wanted to use these icons in other places.

 That was the easy part. The harder part comes next: we want to make the facility images into buttons, so that we can show an alert when they are tapped.

 Using the optional form of alert() this starts easily enough – add two new properties to ResortView, one to store the currently selected facility, and one to store whether an alert should currently be shown or not:

     @State private var selectedFacility: Facility?
     @State private var showingFacility = false
     
 Now replace the previous ForEach loop with this:

     ForEach(resort.facilityTypes) { facility in
         Button {
             selectedFacility = facility
             showingFacility = true
         } label: {
             facility.icon
                 .font(.title)
         }
     }
     
 We can create the alert in a very similar manner as we created the icons – by adding a dictionary to the Facility struct containing all the keys and values we need:

     private let descriptions = [
         "Accommodation": "This resort has popular on-site accommodation.",
         "Beginners": "This resort has lots of ski schools.",
         "Cross-country": "This resort has many cross-country ski routes.",
         "Eco-friendly": "This resort has won an award for environmental friendliness.",
         "Family": "This resort is popular with families."
     ]
     
 Then reading that inside another computed property:

     var description: String {
         if let message = descriptions[name] {
             return message
         } else {
             fatalError("Unknown facility type: \(name)")
         }
     }
     
 So far this hasn’t been tricky, but now comes the complex part. You see, the selectedFacility property is optional, so we need to handle it carefully:

 - We can’t use it as the only title for our alert, because we must provide a non-optional string. We can fix that with nil coalescing.
 
 - We always want to make sure the alert reads from our optional selectedFacility, so it passes in the unwrapped value from there.
 
 - We don’t need any buttons in this alert, so we can let the system provide a default OK button.
 
 - We need to provide an alert message based on the unwrapped facility data, calling the new message(for:) method we just wrote.
 
 Putting all that together, add this modifier below navigationBarTitleDisplayMode() in ResortView:

     .alert(selectedFacility?.name ?? "More information", isPresented: $showingFacility, presenting: selectedFacility) { _ in
     } message: { facility in
         Text(facility.description)
     }
     
 Notice how we’re using _ in for the alert’s action closure because we don’t actually care about getting the unwrapped Facility instance there, but it is important in the message closure so we can display the correct description.
 */

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var searchText = ""
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black, lineWidth: 1)
                        )

                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
            
            WelcomeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
