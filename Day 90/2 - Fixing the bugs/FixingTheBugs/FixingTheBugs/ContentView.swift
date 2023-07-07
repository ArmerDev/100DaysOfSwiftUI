//
//  ContentView.swift
//  FixingTheBugs
//
//  Created by James Armer on 07/07/2023.
//

import SwiftUI

/*
 Our SwiftUI app is looking good so far: we have a stack of cards that can be dragged around to control the app, plus haptic feedback and some accessibility support. But at the same time it’s also pretty full of glitches that are holding it back – some big, some small, but all worth addressing.

 First, it’s possible to drag cards around when they aren’t at the top. This is confusing for users because they can grab a card they can’t actually see, so this should never be possible.

 To fix this we’re going to use allowsHitTesting() so that only the last card – the one on top – can be dragged around. Find the stacked() modifier in ContentView and add this directly below:

     .allowsHitTesting(index == cards.count - 1)
 
 Second, our UI is a bit of a mess when used with VoiceOver. If you launch it on a real device with VoiceOver enabled, you’ll find that you can tap on the background image to get “Background, image” read out, which is pointless. However, things get worse: make small swipes to the right and VoiceOver will move through all the accessibility elements – it reads out the text from all our cards, even the ones that aren’t visible.

 To fix the background image problem we should make it use a decorative image so it won’t be read out as part of the accessibility layout. Modify the background image to this:

 Image(decorative: "background")
 To fix the cards, we need to use an accessibilityHidden() modifier with a similar condition to the allowsHitTesting() modifier we added a minute ago. In this case, every card that’s at an index less than the top card should be hidden from the accessibility system because there’s really nothing useful it can do with the card, so add this directly below the allowsHitTesting() modifier:

 .accessibilityHidden(index < cards.count - 1)
 There’s a third accessibility problem with our app, and it’s the direct result of using gestures to control things. Yes, gestures are great fun to use most of the time, but if you have specific accessibility needs it can be very hard to use them.

 In this app our gestures are causing multiple problems: it’s not apparent to VoiceOver users how they should control the app:

- We don’t say that the cards are buttons that can be tapped.
 
- When the answer is revealed there is no audible notification of what it was.
 
- Users have no way of swiping left or right to move through the cards.
 
 It takes very little work to fix these problems, but the pay off is that our app is much more accessible to everyone.

 First, we need to make it clear that our cards are tappable buttons. This is as simple as adding accessibilityAddTraits() with .isButton to the ZStack in CardView. Put this after its opacity() modifier:

     .accessibilityAddTraits(.isButton)
 
 Now the system will read “Who played the 13th Doctor in Doctor Who? Button” – an important hint to users that the card can be tapped.

 Second, we need to help the system to read the answer to the cards as well as the questions. This is possible right now, but only if the user swipes around on the screen – it’s far from obvious. So, to fix this we’re going to detect whether the user has accessibility enabled on their device, and if so automatically toggle between showing the prompt and showing the answer. That is, rather than have the answer appear below the prompt we’ll switch it out and just show the answer, which will cause VoiceOver to read it out immediately.

 SwiftUI provides a specific environment property that tells us when VoiceOver is running, called accessibilityVoiceOverEnabled. So, add this new property to CardView:

     @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
     
 Right now our code for displaying the prompt and answer looks like this:

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
 
 We’re going to change that so the prompt and answer are shown in a single text view, with accessibilityEnabled deciding which layout is shown. Amend your code to this:

     VStack {
         if voiceOverEnabled {
             Text(isShowingAnswer ? card.answer : card.prompt)
                 .font(.largeTitle)
                 .foregroundColor(.black)
         } else {
             Text(card.prompt)
                 .font(.largeTitle)
                 .foregroundColor(.black)

             if isShowingAnswer {
                 Text(card.answer)
                     .font(.title)
                     .foregroundColor(.gray)
             }
         }
     }
 
 If you try that out with VoiceOver you’ll hear that it works much better – as soon as the card is double-tapped the answer is read out.

 Third, we need to make it easier for users to mark cards as correct or wrong, because right now our images just don’t cut it. Not only do they stop users from interacting with our app using tap gestures, but they also get read out as their SF Symbols name – “checkmark, circle, image” – rather than anything useful.

 To fix this we need to replace the images with buttons that actually remove the cards. We don’t actually do anything different if the user was correct or wrong – I need to leave something for your challenges! – but we can at least remove the top card from the deck. At the same time, we’re going to provide an accessibility label and hint so that users get a better idea of what the buttons do.

 So, replace your current HStack with those images with this new code:

     HStack {
         Button {
             withAnimation {
                 removeCard(at: cards.count - 1)
             }
         } label: {
             Image(systemName: "xmark.circle")
                 .padding()
                 .background(.black.opacity(0.7))
                 .clipShape(Circle())
         }
         .accessibilityLabel("Wrong")
         .accessibilityHint("Mark your answer as being incorrect.")

         Spacer()

         Button {
             withAnimation {
                 removeCard(at: cards.count - 1)
             }
         } label: {
             Image(systemName: "checkmark.circle")
                 .padding()
                 .background(.black.opacity(0.7))
                 .clipShape(Circle())
         }
         .accessibilityLabel("Correct")
         .accessibilityHint("Mark your answer as being correct.")
     }
     
 Because those buttons remain onscreen even when the last card has been removed, we need to add a guard check to the start of removeCard(at:) to make sure we don’t try to remove a card that doesn’t exist. So, put this new line of code at the start of that method:

     guard index >= 0 else { return }
 
 Finally, we can make those buttons visible when either differentiateWithoutColor is enabled or when VoiceOver is enabled. This means adding another accessibilityVoiceOverEnabled property to ContentView:

     @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
     
 Then modifying the if differentiateWithoutColor { condition to this:

     if differentiateWithoutColor || voiceOverEnabled {
     
 With these accessibility changes our app works much better for everyone – good job!

 Before we’re done, I’d like to add one tiny extra change. Right now if you drag an image a little then let go we set its offset back to zero, which causes it to jump back into the center of the screen. If we attach a spring animation to our card, it will slide into the center, which I think is a much clearer indication to our user of what actually happened.

 To make this happen, add an animation() modifier to the end of the ZStack in CardView, directly after the onTapGesture():

 ].animation(.spring(), value: offset)
 
 Much better!

 Tip: If you look carefully, you might notice the card flash red if you drag it a little to the right then release. More on that later!
 */

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @State private var cards = [Card](repeating: Card.example, count: 10)
    
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count - 1)
                        .accessibilityHidden(index < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                        .padding()
                }
            }
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        cards = Array<Card>(repeating: Card.example, count: 10)
        timeRemaining = 100
        isActive = true
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
