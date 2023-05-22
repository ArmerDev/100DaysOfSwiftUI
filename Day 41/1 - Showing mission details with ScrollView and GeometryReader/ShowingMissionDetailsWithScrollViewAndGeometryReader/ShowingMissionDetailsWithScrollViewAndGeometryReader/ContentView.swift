//
//  ContentView.swift
//  ShowingMissionDetailsWithScrollViewAndGeometryReader
//
//  Created by James Armer on 22/05/2023.
//

import SwiftUI

/*
 When the user selects one of the Apollo missions from our main list, we want to show information about the mission: its mission badge, its mission description, and all the astronauts that were on the crew along with their roles. The first two of those aren’t too hard, but the third requires a little more work because we need to match up crew IDs with crew details across our two JSON files.

 Let’s start simple and work our way up: make a new SwiftUI view called MissionView.swift. Initially this will just have a mission property so that we can show the mission badge and description, but shortly we’ll add more to it.

 In terms of layout, this thing needs to have a scrolling VStack with a resizable image for the mission badge, then a text view. We’ll use GeometryReader to set the maximum width of the mission image, although through some trial and error I found that the mission badge worked best when it wasn’t full width – somewhere between 50% and 70% width looked better, to avoid it becoming weirdly big on the screen.

 Put this code into MissionView.swift now:

     struct MissionView: View {
         let mission: Mission

         var body: some View {
             GeometryReader { geometry in
                 ScrollView {
                     VStack {
                         Image(mission.image)
                             .resizable()
                             .scaledToFit()
                             .frame(maxWidth: geometry.size.width * 0.6)
                             .padding(.top)

                         VStack(alignment: .leading) {
                             Text("Mission Highlights")
                                 .font(.title.bold())
                                 .padding(.bottom, 5)

                             Text(mission.description)
                         }
                         .padding(.horizontal)
                     }
                     .padding(.bottom)
                 }
             }
             .navigationTitle(mission.displayName)
             .navigationBarTitleDisplayMode(.inline)
             .background(.darkBackground)
         }
     }
 
 Placing a VStack inside another VStack allows us to control alignment for one specific part of our view – our main mission image can be centered, while the mission details can be aligned to the leading edge.

 Anyway, with that new view in place the code will no longer build, all because of the previews struct below it – that thing needs a Mission object passed in so it has something to render. Fortunately, our Bundle extension is available here as well:

     struct MissionView_Previews: PreviewProvider {
         static let missions: [Mission] = Bundle.main.decode("missions.json")

         static var previews: some View {
             MissionView(mission: missions[0])
                 .preferredColorScheme(.dark)
         }
     }
 
 Tip: This view will automatically have a dark color scheme because it’s applied to the NavigationView in ContentView, but the MissionView preview doesn’t know that so we need to enable it by hand.

 If you look in the preview you’ll see that’s a good start, but the next part is trickier: we want to show the list of astronauts who took part in the mission below the description. Let’s tackle that next…
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
                            Text("Detail View")
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
