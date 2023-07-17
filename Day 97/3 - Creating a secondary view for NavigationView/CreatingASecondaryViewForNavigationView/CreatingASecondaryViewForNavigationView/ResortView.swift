//
//  ResortView.swift
//  CreatingASecondaryViewForNavigationView
//
//  Created by James Armer on 17/07/2023.
//

import SwiftUI

struct ResortView: View {
    let resort: Resort

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(decorative: resort.id)
                    .resizable()
                    .scaledToFit()
                
                HStack {
                    ResortDetailsView(resort: resort)
                    SkiDetailsView(resort: resort)
                }
                .padding(.vertical)
                .background(Color.primary.opacity(0.1))

                Group {
                    Text(resort.description)
                        .padding(.vertical)

                    Text("Facilities")
                        .font(.headline)

                    Text(resort.facilities, format: .list(type: .and))
                        .padding(.vertical)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/*
 You’ll also need to update ResortView_Previews to pass in an example resort for Xcode’s preview window:
 */

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        ResortView(resort: Resort.example)
    }
}

/*
 And now we can update the navigation link in ContentView to point to our actual view, like this:

 NavigationLink {
     ResortView(resort: resort)
 } label: {
 */
