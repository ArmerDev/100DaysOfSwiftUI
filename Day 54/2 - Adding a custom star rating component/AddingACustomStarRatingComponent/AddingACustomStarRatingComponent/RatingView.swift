//
//  RatingView.swift
//  AddingACustomStarRatingComponent
//
//  Created by James Armer on 04/06/2023.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int

    var label = ""

    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow
    
    /*
     Before we fill in the body property, please try building the code – you should find that it fails, because our RatingView_Previews struct doesn’t pass in a binding to use for rating.

     SwiftUI has a specific and simple solution for this called constant bindings. These are bindings that have fixed values, which on the one hand means they can’t be changed in the UI, but also means we can create them trivially – they are perfect for previews.

     So, replace the existing previews property with this:

     static var previews: some View {
         RatingView(rating: .constant(4))
     }
     
     Now let’s turn to the body property. This is going to be a HStack containing any label that was provided, plus as many stars as have been requested – although, of course, they can choose any image they want, so it might not be a star at all.

     The logic for choosing which image to show is pretty simple, but it’s perfect for carving off into its own method to reduce the complexity of our code. The logic is this:

     If the number that was passed in is greater than the current rating, return the off image if it was set, otherwise return the on image.
     If the number that was passed in is equal to or less than the current rating, return the on image.
     We can encapsulate that in a single method, so add this to RatingView now:

     func image(for number: Int) -> Image {
         if number > rating {
             return offImage ?? onImage
         } else {
             return onImage
         }
     }
     
     And now implementing the body property is surprisingly easy: if the label has any text use it, then use ForEach to count from 1 to the maximum rating plus 1 and call image(for:) repeatedly. We’ll also apply a foreground color depending on the rating, and add a tap gesture that adjusts the rating.

     Replace your existing body property with this:

     HStack {
         if label.isEmpty == false {
             Text(label)
         }

         ForEach(1..<maximumRating + 1, id: \.self) { number in
             image(for: number)
                 .foregroundColor(number > rating ? offColor : onColor)
                 .onTapGesture {
                     rating = number
                 }
         }
     }
     */
    
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }

            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

/*
 That completes our rating view already, so to put it into action go back to AddBookView and replace the second section
 */

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
