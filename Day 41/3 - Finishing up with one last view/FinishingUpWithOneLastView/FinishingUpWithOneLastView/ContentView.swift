//
//  ContentView.swift
//  FinishingUpWithOneLastView
//
//  Created by James Armer on 22/05/2023.
//

import SwiftUI

/*
 To finish this program we’re going to make a third and final view to display astronaut details, which will be reached by tapping one of the astronauts in the mission view. This should mostly just be practice for you, but I hope it also shows you the importance of NavigationView – we’re digging deeper into our app’s information, and the presentation of views sliding in and out really drives that home to the user.

 Start by making a new SwiftUI view called AstronautView. This will have a single Astronaut property so it knows what to show, then it will lay that out using a similar ScrollView/VStack combination as we had in MissionView. Give it this code:

 struct AstronautView: View {
     let astronaut: Astronaut

     var body: some View {
         ScrollView {
             VStack {
                 Image(astronaut.id)
                     .resizable()
                     .scaledToFit()

                 Text(astronaut.description)
                     .padding()
             }
         }
         .background(.darkBackground)
         .navigationTitle(astronaut.name)
         .navigationBarTitleDisplayMode(.inline)
     }
 }
 Once again we need to update the preview so that it creates its view with some data:

 struct AstronautView_Previews: PreviewProvider {
     static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

     static var previews: some View {
         AstronautView(astronaut: astronauts["aldrin"]!)
             .preferredColorScheme(.dark)
     }
 }
 Now we can present that from the NavigationLink inside MissionView. This points to Text("Astronaut details") right now, but we can update it to point to our new AstronautView instead:

 AstronautView(astronaut: crewMember.astronaut)
 That was easy, right? But if you run the app now you’ll see how natural it makes our user interface feel – we start at the broadest level of information, showing all our missions, then tap to select one specific mission, then tap to select one specific astronaut. iOS takes care of animating in the new views, but also providing back buttons and swipes to return to previous views.
 */

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(missions) { mission in
                        NavigationLink {
                            MissionView(mission: mission, astronauts: astronauts)
                        } label: {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                
                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackground)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.lightBackground)
                            )
                        }

                    }
                }
                .padding([.horizontal, .bottom])
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
