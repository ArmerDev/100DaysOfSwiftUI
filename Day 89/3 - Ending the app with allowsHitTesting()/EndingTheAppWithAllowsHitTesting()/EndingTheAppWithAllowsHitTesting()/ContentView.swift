//
//  ContentView.swift
//  EndingTheAppWithAllowsHitTesting()
//
//  Created by James Armer on 07/07/2023.
//

import SwiftUI

/*
 SwiftUI lets us disable interactivity for a view by setting allowsHitTesting() to false, so in our project we can use it to disable swiping on any card when the time runs out by checking the value of timeRemaining.

 Start by adding this modifier to the innermost ZStack – the one that shows our card stack:

     .allowsHitTesting(timeRemaining > 0)
 
 That enables hit testing when timeRemaining is 1 or greater, but sets it to false otherwise because the user is out of time.

 The other outcome is that the user flies through all the cards correctly, and ends with none left. When the final card goes away, right now our timer slides down to the center of the screen, and carries on ticking. What we want to happen is for the timer to stop so users can see how fast they were, and also to show a button allowing them to reset their cards and try again.

 This takes a little thinking, because just setting isActive to false isn’t enough – if the app moves to the background and returns to the foreground, isActive will be re-enabled even though there are no cards left.

 Let’s tackle it piece by piece. First, we need a method to run to reset the app so the user can try again, so add this to ContentView:

     func resetCards() {
         cards = [Card](repeating: Card.example, count: 10)
         timeRemaining = 100
         isActive = true
     }
     
 Second, we need a button to trigger that, shown only when all cards have been removed. Put this after the innermost ZStack, just below the allowsHitTesting() modifier:

     if cards.isEmpty {
         Button("Start Again", action: resetCards)
             .padding()
             .background(.white)
             .foregroundColor(.black)
             .clipShape(Capsule())
     }
     
 Now we have code to restart the timer when resetting the cards, but now we need to stop the timer when the final card is removed – and make sure it stays stopped when coming back to the foreground.

 We can solve the first problem by adding this to the end of the removeCard(at:) method:

     if cards.isEmpty {
         isActive = false
     }
     
 As for the second problem – making sure isActive stays false when returning from the background – we should just update our scene phase code so it explicitly checks for cards:

     .onChange(of: scenePhase) { newPhase in
         if newPhase == .active {
             if cards.isEmpty == false {
                 isActive = true
             }
         } else {
             isActive = false
         }
     }
     
 Done!
 */

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
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
            
            if differentiateWithoutColor {
                VStack {
                    Spacer()
                    
                    HStack {
                        Image(systemName: "xmark.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                        Spacer()
                        Image(systemName: "checkmark.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
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
