//
//  ContentView.swift
//  UsingGenericsToLoadAnyKindOfCodableData
//
//  Created by James Armer on 22/05/2023.
//

import SwiftUI

/*
 We added a Bundle extension for loading one specific type of JSON data from our app bundle, but now we have a second type: missions.json. This contains slightly more complex JSON:

 - Every mission has an ID number, which means we can use Identifiable easily.
 - Every mission has a description, which is a free text string taken from Wikipedia.
 - Every mission has an array of crew, where each crew member has a name and role.
 - All but one missions has a launch date. Sadly, Apollo 1 never launched because a launch rehearsal cabin fire destroyed the command module and killed the crew.
 
 Let’s start converting that to code. Crew roles need to be represented as their own struct, storing the name string and role string. So, create a new Swift file called Mission.swift and give it this code:
 */

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    var body: some View {
        Text("\(astronauts.count)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
