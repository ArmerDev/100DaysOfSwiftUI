//
//  ResortDetailsView.swift
//  CreatingASecondaryViewForNavigationView
//
//  Created by James Armer on 17/07/2023.
//

import SwiftUI

/*
 As with ResortView, you’ll need to update the preview struct to use some example data:
 */

struct ResortDetailsView: View {
    let resort: Resort
    
    /*
     When it comes to getting the size of the resort we could just add this property to ResortDetailsView:

         var size: String {
             ["Small", "Average", "Large"][resort.size - 1]
         }
     
     That works, but it would cause a crash if an invalid value was used, and it’s also a bit too cryptic for my liking. Instead, it’s safer and clearer to use a switch block like this:
     */
    
    var size: String {
        switch resort.size {
        case 1:
            return "Small"
        case 2:
            return "Average"
        default:
            return "Large"
        }
    }
    
    /*
     As for the price property, we can leverage the same repeating/count initializer we used to create example cards in project 17: String(repeating:count:) creates a new string by repeating a substring a certain number of times.
     */
    
    var price: String {
        String(repeating: "$", count: resort.price)
    }
    
    /*
     Now what remains in the body property is simple, because we just use the two computed properties we wrote:
     */
    
    var body: some View {
        Group {
            VStack {
                Text("Size")
                    .font(.caption.bold())
                Text(size)
                    .font(.title3)
            }

            VStack {
                Text("Price")
                    .font(.caption.bold())
                Text(price)
                    .font(.title3)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

/*
 Again, giving the whole Group an infinite maximum width means these views will spread out horizontally just like those from the previous view.

 That completes our two mini views, so we can now drop them into ResortView – put this just before the group in ResortView:

 HStack {
     ResortDetailsView(resort: resort)
     SkiDetailsView(resort: resort)
 }
 .padding(.vertical)
 .background(Color.primary.opacity(0.1))
 
 ...
 
 We’re going to add to that some more in a moment, but first I want to make one small tweak: using joined(separator:) does an okay job of converting a string array into a single string, but we’re not here to write okay code – we’re here to write great code.

 Previously we’ve used the format parameter of Text to control the way numbers are formatted, but there’s a format for string arrays too. This is similar to using joined(separator:), but rather than sending back “A, B, C” like we have right now, we get back “A, B, and C” – it’s more natural to read.

 Replace the current facilities text view with this:

 Text(resort.facilities, format: .list(type: .and))
     .padding(.vertical)
 
 Notice how the .and type is there? That’s because you can also use .or to get “A, B, or C” if that’s what you want.

 Anyway, it’s a tiny change but I think it’s much better!
 */

struct ResortDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ResortDetailsView(resort: Resort.example)
    }
}
