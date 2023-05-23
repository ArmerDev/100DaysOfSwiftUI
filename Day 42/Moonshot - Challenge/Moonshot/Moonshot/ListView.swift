//
//  ListView.swift
//  Moonshot
//
//  Created by James Armer on 23/05/2023.
//

import SwiftUI

struct ListView: View {
    let missions: [Mission]
    let astronauts: [String: Astronaut]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(missions) { mission in
                    NavigationLink {
                        MissionView(mission: mission, astronauts: astronauts)
                    } label: {
                        HStack {
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
//                            .padding(.vertical)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    }
}

struct ListView_Previews: PreviewProvider {
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    static let missions: [Mission] = Bundle.main.decode("missions.json")

    static var previews: some View {
        ListView(missions: missions, astronauts: astronauts)
            .preferredColorScheme(.dark)
    }
}
