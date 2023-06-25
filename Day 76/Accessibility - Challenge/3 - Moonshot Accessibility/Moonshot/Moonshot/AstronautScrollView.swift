//
//  AstronautScrollView.swift
//  Moonshot
//
//  Created by James Armer on 25/06/2023.
//

import SwiftUI

struct AstronautScrollView: View {
    let crew: [MissionView.CrewMember]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.role) { crewMember in
                    NavigationLink {
                        AstronautView(astronaut: crewMember.astronaut)
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
                            .accessibilityElement()
                            .accessibilityLabel("\(crewMember.astronaut.name.replacingOccurrences(of: ".", with: "")): \(crewMember.role)")
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}
