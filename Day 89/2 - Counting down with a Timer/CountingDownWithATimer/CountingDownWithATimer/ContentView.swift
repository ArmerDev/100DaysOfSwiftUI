//
//  ContentView.swift
//  CountingDownWithATimer
//
//  Created by James Armer on 07/07/2023.
//

import SwiftUI

/*
 If we bring together Foundation, SwiftUI, and Combine, we can add a timer to our app to add a little bit of pressure to the user. A simple implementation of this doesn’t take much work, but it also has a bug that requires some extra work to fix.

 For our first pass of the timer, we’re going to create two new properties: the timer itself, which will fire once a second, and a timeRemaining property, from which we’ll subtract 1 every time the timer fires. This will allow us to show how many seconds remain in the current app run, which should give the user a gentle incentive to speed up.

 So, start by adding these two new properties to ContentView:

     @State private var timeRemaining = 100
     let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
     
 That gives the user 100 seconds to start with, then creates and starts a timer that fires once a second on the main thread.

 Whenever that timer fires, we want to subtract 1 from timeRemaining so that it counts down. We could try and do some date mathematics here by storing a start date and showing the difference between that and the current date, but there really is no need as you’ll see!

 Add this onReceive() modifier to the outermost ZStack in ContentView:

     .onReceive(timer) { time in
         if timeRemaining > 0 {
             timeRemaining -= 1
         }
     }
     
 Tip: That adds a trivial condition to make sure we never stray into negative numbers.

 That code starts our timer at 100 and makes it count down to 0, but we need to actually display it. This is as simple as adding another text view to our layout, this time with a dark background color to make sure it’s clearly visible.

 Put this inside the VStack that contains the ZStack for our cards:

     Text("Time: \(timeRemaining)")
         .font(.largeTitle)
         .foregroundColor(.white)
         .padding(.horizontal, 20)
         .padding(.vertical, 5)
         .background(.black.opacity(0.75))
         .clipShape(Capsule())
     
 If you’ve placed it correctly, your layout code should look like this:

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
     
 You should be able to run the app now and give it a try – it works well enough, right? Well, there’s a small problem:

 - Take a look at the current value in the timer.
 
 - Press Cmd+H to go back to the home screen.
 
 - Wait about ten seconds.
 
 - Now tap your app’s icon to go back to the app.
 
 - What time is shown in the timer?
 
 What I find is that the timer shows a value about three seconds lower than we had when we were in the app previously – the timer runs for a few seconds in the background, then pauses until the app comes back.

 We can do better than this: we can detect when our app moves to the background or foreground, then pause and restart our timer appropriately.

 First, add two properties to store whether the app is currently active:

     @Environment(\.scenePhase) var scenePhase
     @State private var isActive = true
     
 We have two because the environment value tells us whether the app is active or inactive in terms of its visibility, but we’ll also consider the app inactive is the player has gone through their deck of flashcards – it will be active from a scene phase point of view, but we don’t keep the timer ticking.

 Now add this onChange() modifier below the existing onReceive() modifier:

     .onChange(of: scenePhase) { newPhase in
         if newPhase == .active {
             isActive = true
         } else {
             isActive = false
         }
     }
     
 Finally, modify the onReceive(timer) function so it exits immediately is isActive is false, like this:

     .onReceive(timer) { time in
         guard isActive else { return }

         if timeRemaining > 0 {
             timeRemaining -= 1
         }
     }
     
 And with that small change the timer will automatically pause when the app moves to the background – we no longer lose any mystery seconds.
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
                isActive = true
            } else {
                isActive = false
            }
        }
    }
    
    func removeCard(at index: Int) {
        cards.remove(at: index)
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
