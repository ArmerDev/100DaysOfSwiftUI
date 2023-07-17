//
//  SkiDetailsView.swift
//  CreatingASecondaryViewForNavigationView
//
//  Created by James Armer on 17/07/2023.
//

import SwiftUI

struct SkiDetailsView: View {
    let resort: Resort

    var body: some View {
        Group {
            VStack {
                Text("Elevation")
                    .font(.caption.bold())
                Text("\(resort.elevation)m")
                    .font(.title3)
            }

            VStack {
                Text("Snow")
                    .font(.caption.bold())
                Text("\(resort.snowDepth)cm")
                    .font(.title3)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

/*
 Giving the Group view a maximum frame width of .infinity doesn’t actually affect the group itself, because it has no impact on layout. However, it does get passed down to its child views, which means they will automatically spread out horizontally.

 As for the resort details, this is a little trickier because of two things:

 The size of a resort is stored as a value from 1 to 3, but really we want to use “Small”, “Average”, and “Large” instead.
 The price is stored as a value from 1 to 3, but we’re going to replace that with $, $$, or $$$.
 As always, it’s a good idea to get calculations out of your SwiftUI layouts so it’s nice and clear, so we’re going to create two computed properties: size and price.

 Start by creating a new SwiftUI view called ResortDetailsView, and give it this property:

 let resort: Resort
 */

struct SkiDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SkiDetailsView(resort: Resort.example)
    }
}
