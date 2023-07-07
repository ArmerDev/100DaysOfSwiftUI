//
//  ContentView.swift
//  AddingAndDeletingCards
//
//  Created by James Armer on 07/07/2023.
//

import SwiftUI

/*
 Everything we’ve worked on so far has used a fixed set of sample cards, but of course this app only becomes useful if users can actually customize the list of cards they see. This means adding a new view that lists all existing cards and lets the user add a new one, which is all stuff you’ve seen before. However, there’s an interesting catch this time that will require something new to fix, so it’s worth working through this.

 First we need some state that controls whether our editing screen is visible. So, add this to ContentView:

     @State private var showingEditScreen = false
     
 Next we need to add a button to flip that Boolean when tapped, so find the if differentiateWithoutColor || accessibilityEnabled condition and put this before it:

     VStack {
         HStack {
             Spacer()

             Button {
                 showingEditScreen = true
             } label: {
                 Image(systemName: "plus.circle")
                     .padding()
                     .background(.black.opacity(0.7))
                     .clipShape(Circle())
             }
         }

         Spacer()
     }
     .foregroundColor(.white)
     .font(.largeTitle)
     .padding()
     
 We’re going to design a new EditCards view to encode and decode a Card array to UserDefaults, but before we do that I’d like you to make the Card struct conform to Codable like this:

     struct Card: Codable {
 
 Now create a new SwiftUI view called “EditCards”. This needs to:

 - Have its own Card array.
 
 - Be wrapped in a NavigationView so we can add a Done button to dismiss the view.
 
 - Have a list showing all existing cards.
 
 - Add swipe to delete for those cards.
 
 - Have a section at the top of the list so users can add a new card.
 
 - Have methods to load and save data from UserDefaults.
 
 We’ve looked at literally all that code previously, so I’m not going to explain it again here. I hope you can stop to appreciate how far this means you have come!

 Replace the template EditCards struct with this:

     struct EditCards: View {
         @Environment(\.dismiss) var dismiss
         @State private var cards = [Card]()
         @State private var newPrompt = ""
         @State private var newAnswer = ""

         var body: some View {
             NavigationView {
                 List {
                     Section("Add new card") {
                         TextField("Prompt", text: $newPrompt)
                         TextField("Answer", text: $newAnswer)
                         Button("Add card", action: addCard)
                     }

                     Section {
                         ForEach(0..<cards.count, id: \.self) { index in
                             VStack(alignment: .leading) {
                                 Text(cards[index].prompt)
                                     .font(.headline)
                                 Text(cards[index].answer)
                                     .foregroundColor(.secondary)
                             }
                         }
                         .onDelete(perform: removeCards)
                     }
                 }
                 .navigationTitle("Edit Cards")
                 .toolbar {
                     Button("Done", action: done)
                 }
                 .listStyle(.grouped)
                 .onAppear(perform: loadData)
             }
         }

         func done() {
             dismiss()
         }

         func loadData() {
             if let data = UserDefaults.standard.data(forKey: "Cards") {
                 if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                     cards = decoded
                 }
             }
         }

         func saveData() {
             if let data = try? JSONEncoder().encode(cards) {
                 UserDefaults.standard.set(data, forKey: "Cards")
             }
         }

         func addCard() {
             let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
             let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
             guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }

             let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
             cards.insert(card, at: 0)
             saveData()
         }

         func removeCards(at offsets: IndexSet) {
             cards.remove(atOffsets: offsets)
             saveData()
         }
     }
     
 That’s almost all of EditCards complete, but before we can use it we need to add some more code to ContentView so that it shows the sheet on demand and calls resetCards() when dismissed.

 We’ve used sheets previously, but there’s one extra technique I’d like you to show you: you can attach a function to your sheet, that will automatically be run when the sheet is dismissed. This isn’t helpful for times you need to pass back data from the sheet, but here we’re just going to call resetCards() so it’s perfect.

 Add this sheet() modifier to the end of the outermost ZStack in ContentView:

     .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
         EditCards()
     }
     
 That works, but now that you’re gaining more experience in SwiftUI I want to show you an alternative way to get the same result.

 When we use the sheet() modifier we need to give SwiftUI a function it can run that returns the view to show in the sheet. For us above that’s a closure with EditCards() inside – that creates and returns a new view, which is what the sheet wants.

 When we write EditCards(), we’re relying on syntactic sugar – we’re treating our view struct like a function, because Swift silently treats that as a call to the view’s initializer. So, in practice we’re actually writing EditCards.init(), just in a shorter way.

 This all matters because rather than creating a closure that calls the EditCards initializer, we can actually pass the EditCards initializer directly to the sheet, like this:

     .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
     
 That means “when you want to read the content for the sheet, call the EditCards initializer and it will send you back the view to use.”

 Important: This approach only works because EditCards has an initializer that accepts no parameters. If you need to pass in specific values you need to use the closure-based approach instead.

 Anyway, as well as calling resetCards() when the sheet is dismissed, we also want to call it when the view first appears, so add this modifier below the previous one:

     .onAppear(perform: resetCards)
 
 So, when the view is first shown resetCards() is called, and when it’s shown after EditCards has been dismissed resetCards() is also called. This means we can ditch our example cards data and instead make it an empty array that gets filled at runtime.

 So, change the cards property of ContentView to this:

     @State private var cards = [Card]()
 
 To finish up with ContentView we need to make it load that cards property on demand. This starts with the same code we just added in EditCard, so put this method into ContentView now:

     func loadData() {
         if let data = UserDefaults.standard.data(forKey: "Cards") {
             if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                 cards = decoded
             }
         }
     }
     
 And now we can add a call to loadData() in resetCards(), so that we refill the cards property with all saved cards when the app launches or when the user edits their cards:

     func resetCards() {
         timeRemaining = 100
         isActive = true
         loadData()
     }
     
 Now go ahead and run the app. We’ve wiped out our default examples, so you’ll need to press the + icon to add some of your own.

 With that last change, our app is complete – good job!
 */

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @State private var cards = [Card]()
    
    @State private var showingEditScreen = false
    
    
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
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
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
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
            EditCards()
        }
        .onAppear(perform: resetCards)
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
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
        timeRemaining = 100
        isActive = true
        loadData()
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
