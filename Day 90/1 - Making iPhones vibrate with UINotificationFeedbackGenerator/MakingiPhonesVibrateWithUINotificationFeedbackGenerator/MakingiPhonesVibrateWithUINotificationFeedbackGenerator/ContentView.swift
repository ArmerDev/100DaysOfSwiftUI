//
//  ContentView.swift
//  MakingiPhonesVibrateWithUINotificationFeedbackGenerator
//
//  Created by James Armer on 07/07/2023.
//

import SwiftUI

/*
 iOS comes with a number of options for generating haptic feedback, and they are all available for us to use in SwiftUI. In its simplest form, this is as simple as creating an instance of one of the subclasses of UIFeedbackGenerator then triggering it when you’re ready, but for more precise control over feedback you should first call its prepare() method to give the Taptic Engine chance to warm up.

 Important: Warming up the Taptic Engine helps reduce the latency between us playing the effect and it actually happening, but it also has a battery impact so the system will only stay ready for a second or two after you call prepare().

 There are a few different subclasses of UIFeedbackGenerator we could use, but the one we’ll use here is UINotificationFeedbackGenerator because it provides success and failure haptics that are common across iOS. Now, we could add one central instance of UINotificationFeedbackGenerator to every ContentView, but that causes a problem: ContentView gets notified whenever a card has been removed, but isn’t notified when a drag is in progress, which means we don’t have the opportunity to warm up the Taptic Engine.

 So, instead we’re going to give each CardView its own instance of UINotificationFeedbackGenerator so they can prepare and play them as needed. The system will take care of making sure the haptics are all neatly arranged, so there’s no chance of them somehow getting confused.

 Add this new property to CardView:

     @State private var feedback = UINotificationFeedbackGenerator()
 
 Now find the removal?() line in the drag gesture of CardView, and change that whole closure to this:

     if offset.width > 0 {
         feedback.notificationOccurred(.success)
     } else {
         feedback.notificationOccurred(.error)
     }

     removal?()
     
 That alone is enough to get haptics in our app, but there is always the risk that the haptic will be delayed because the Taptic Engine wasn’t ready. In this case the haptic will still play, but it could be up to maybe half a second late – enough to feel just that little bit disconnected from our user interface.

 To improve this we need to call prepare() on our haptic a little before triggering it. It is not enough to call prepare() immediately before activating it: doing so does not give the Taptic Engine enough time to warm up, so you won’t see any reduction in latency. Instead, you should call prepare() as soon as you know the haptic might be needed.

 Now, there are two helpful implementation details that you should be aware of.

 First, it’s OK to call prepare() then never triggering the effect – the system will keep the Taptic Engine ready for a few seconds then just power it down again. If you repeatedly call prepare() and never trigger it the system might start ignoring your prepare() calls until at least one effect has happened.

 Second, it’s perfectly allowable to call prepare() many times before triggering it once – prepare() doesn’t pause your app while the Taptic Engine warms up, and also doesn’t have any real performance cost when the system is already prepared.

 Putting these two together, we’re going to update our drag gesture so that prepare() is called whenever the gesture changes. This means it could be called a hundred times before the haptic is finally triggered, because it will get triggered every time the user moves their finger.

 So, modify your onChanged() closure to this:

     .onChanged { gesture in
         offset = gesture.translation
         feedback.prepare()
     }
     
 Now go ahead and give the app a try and see what you think – you should be able to feel two very different haptics depending on which direction you swipe.

 Before we wrap up with haptics, there’s one thing I want you to consider. Years ago PepsiCo challenged mall shoppers to the “Pepsi Challenge”: drink a sip of one cola drink and a sip of another, and see which you prefer. The results found that more Americans preferred Pepsi than Coca Cola, despite Coke having a much bigger market share. However, there was a problem: people seemed to pick Pepsi in the test because Pepsi had a sweeter taste, and while that worked well in sip-size amounts it worked less well in the sizes of cans and bottles, where people actually preferred Coke.

 The reason I’m saying this is because we added two haptic notifications to our app that will get played a lot. And while you’re testing out in small doses these haptics probably feel great – you’re making your phone buzz, and it can be really delightful. However, if you’re a serious user of this app then our haptics might hit two problems:

-  The user might find them annoying, because they’ll happen once every two or three seconds depending on how fast they are.

-  Worse, the user might become desensitized to them – they lose all usefulness either as a notification or as a little spark of delight.
 So, now you’ve tried it for yourself I want you to think about how they should be used. If this were my app I would probably keep the failure haptic, but I think the success haptic could go – that one is likely to be triggered the most often, and it means when the failure haptic plays it feels a little more special.
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
