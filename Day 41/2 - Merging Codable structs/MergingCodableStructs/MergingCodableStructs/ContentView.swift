//
//  ContentView.swift
//  MergingCodableStructs
//
//  Created by James Armer on 22/05/2023.
//

import SwiftUI

/*
 Below our mission description we want to show the pictures, names, and roles of each crew member, which means matching up data that came from two different JSON files.

 If you remember, our JSON data is split across missions.json and astronauts.json. This eliminates duplication in our data, because some astronauts took part in multiple missions, but it also means we need to write some code to join our data together – to resolve “armstrong” to “Neil A. Armstrong”, for example. You see, on one side we have missions that know crew member “armstrong” had the role “Commander”, but has no idea who “armstrong” is, and on the other side we have “Neil A. Armstrong” and a description of him, but no concept that he was the commander on Apollo 11.

 So, what we need to do is make our MissionView accept the mission that got tapped, along with our full astronauts dictionary, then have it figure out which astronauts actually took part in the launch.

 Add this nested struct inside MissionView now:

 struct CrewMember {
     let role: String
     let astronaut: Astronaut
 }
 Now for the tricky part: we need to add a property to MissionView that stores an array of CrewMember objects – these are the fully resolved role / astronaut pairings. At first that’s as simple as adding another property:

 let crew: [CrewMember]
 But then how do we set that property? Well, think about it: if we make this view be handed its mission and all astronauts, we can loop over the mission crew, then for each crew member look in the dictionary to find the one that has a matching ID. When we find one we can convert that and their role into a CrewMember object, but if we don’t it means somehow we have a crew role with an invalid or unknown name.

 That latter case should never happen. To be clear, if you’ve added some JSON to your project that points to missing data in your app, you’ve made a fundamental mistake – it’s not the kind of thing you should try to write error handling for at runtime, because it should never be allowed to happen in the first place. So, this is a great example of where fatalError() is useful: if we can’t find an astronaut using their ID, we should exit immediately and complain loudly.

 Let’s put all that into code, using a custom initializer for MissionView. Like I said, this will accept the mission it represents along with all the astronauts, and its job is to store the mission away then figure out the array of resolved astronauts.

 Here’s the code:

 init(mission: Mission, astronauts: [String: Astronaut]) {
     self.mission = mission

     self.crew = mission.crew.map { member in
         if let astronaut = astronauts[member.name] {
             return CrewMember(role: member.role, astronaut: astronaut)
         } else {
             fatalError("Missing \(member.name)")
         }
     }
 }
 As soon as that code is in, our preview struct will stop working again because it needs more information. So, add a second call to decode() there so it loads all the astronauts, then passes those in too:

 struct MissionView_Previews: PreviewProvider {
     static let missions: [Mission] = Bundle.main.decode("missions.json")
     static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

     static var previews: some View {
         MissionView(mission: missions[0], astronauts: astronauts)
             .preferredColorScheme(.dark)
     }
 }
 Now that we have all our astronaut data, we can show this directly below the mission description using a horizontal scroll view. We’re also going to add a little extra styling to the astronaut pictures to make them look better, using a capsule clip shape and overlay.

 Add this code just after the VStack(alignment: .leading):

 ScrollView(.horizontal, showsIndicators: false) {
     HStack {
         ForEach(crew, id: \.role) { crewMember in
             NavigationLink {
                 Text("Astronaut details")
             } label: {
                 HStack {
                     Image(crewMember.astronaut.id)
                         .resizable()
                         .frame(width: 104, height: 72)
                         .clipShape(Capsule())
                         .overlay(
                             Capsule()
                                 .strokeBorder(.white, lineWidth: 1)
                         )

                     VStack(alignment: .leading) {
                         Text(crewMember.astronaut.name)
                             .foregroundColor(.white)
                             .font(.headline)
                         Text(crewMember.role)
                             .foregroundColor(.secondary)
                     }
                 }
                 .padding(.horizontal)
             }
         }
     }
 }
 Why after the VStack rather than inside? Because scroll views work best when they take full advantage of the available screen space, which means they should scroll edge to edge. If we put this inside our VStack it would have the same padding as the rest of our text, which means it would scroll strangely – the crew would get clipped as it hit the leading edge of our VStack, which looks odd.

 We’ll make that NavigationLink do something more useful shortly, but first we need to modify the NavigationLink in ContentView – it pushes to Text("Detail View") right now, but please replace it with this:

 MissionView(mission: mission, astronauts: astronauts)
 Now go ahead and run the app in the simulator – it’s starting to become useful!

 Before you move on, try spending a few minutes customizing the way the astronauts are shown – I’ve used a capsule clip shape and overlay, but you could try circles or rounded rectangles, you could use different fonts or larger images, or even add some way of marking who the mission commander was.

 In my project, I think it would be useful to add a little visual separation in our mission view, so that the mission badge, description, and crew are more clearly split up.

 SwiftUI does provide a dedicated Divider view for creating a visual divide in your layout, but it’s not customizable – it’s always just a skinny line. So, to get something a little more useful, I’m going to draw a custom divider to break up our view.

 First, place this directly before the “Mission Highlights” text:

 Rectangle()
     .frame(height: 2)
     .foregroundColor(.lightBackground)
     .padding(.vertical)
 Now place another one of those – the same code – directly after the mission.description text. Much better!

 To finish up this view, I’m going to add a title before our crew, but this needs to be done carefully. You see, although this relates to the scroll view, it needs to have the same padding as the rest of our text. So, the best place for this is inside the VStack, directly after the previous rectangle:

 Text("Crew")
     .font(.title.bold())
     .padding(.bottom, 5)
 You don’t need to put it there – if you wanted we could move it outside the VStack then apply padding individually to that text view. However, if you do that make sure you apply the same amount of padding to keep everything neatly aligned.
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
