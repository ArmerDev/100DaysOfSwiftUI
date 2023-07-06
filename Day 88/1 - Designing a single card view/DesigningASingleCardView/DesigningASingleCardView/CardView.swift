//
//  CardView.swift
//  DesigningASingleCardView
//
//  Created by James Armer on 06/07/2023.
//

import SwiftUI

struct CardView: View {
    @State private var isShowingAnswer = false
    let card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)
                .shadow(radius: 10)
            
            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                
                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .onTapGesture {
            isShowingAnswer.toggle()
        }
    }
}

/*
 Tip: A width of 450 is no accident: the smallest iPhones have a landscape width of 480 points, so this means our card will be fully visible on all devices.

 That will break the CardView_Previews struct because it requires a card parameter to be passed in, but we already added a static example directly to the Card struct for this very purpose. So, update the CardView_Previews struct to this:
 */

struct CardView_Preview: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}


/*
 If you take a look at the preview you should see our example card showing, but you can’t actually see that it’s a card – it has a white background, and so does it doesn’t stand out against the default background of our view. This will become doubly problematic when we have a stack of cards to work through, because they’ll all have white backgrounds and kind of blend into each other.

 There’s a simple fix for this: we can add a shadow to the RoundedRectangle so we get a gentle depth effect. This will help us right now by making our white card stand out from the white background, but when we start adding more cards it will look even better because the shadows will add up.

 So, add this modifier below the fill(.white):

 .shadow(radius: 10)
 Now, right now you can see both the prompt and the answer at the same time, but obviously that isn’t going to help anyone learn. So, to finish this step we’re going to hide the answer label by default, and toggle its visibility whenever the card is tapped.

 So, start by adding this new @State property to CardView:

 @State private var isShowingAnswer = false
 Now wrap the answer view in a condition for that Boolean, like this:

 if isShowingAnswer {
     Text(card.answer)
         .font(.title)
         .foregroundColor(.gray)
 }
 That simple change means it will only show the answer when isShowingAnswer is true.

 The final step is to add an onTapGesture() modifier to the ZStack, by putting this code after the frame() modifier:

 .onTapGesture {
     isShowingAnswer.toggle()
 }
 That’s our card view done for the time being, so if you want to see it in action go back to ContentView.swift and replace its body property with this:

 var body: some View {
     CardView(card: Card.example)
 }
 When you run the project you’ll see the app jumps into landscape mode automatically, and our default card appears – a good start!
 */
