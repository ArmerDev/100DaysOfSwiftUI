//
//  ContentView.swift
//  FixingGuessTheFlag
//
//  Created by James Armer on 25/06/2023.
//

import SwiftUI

/*
 Way back in project 2 we made Guess the Flag, which showed three flag pictures and asked the users to guess which was which. Well, based on what you now know about VoiceOver, can you spot the fatal flaw in our game?

 That’s right: SwiftUI’s default behavior is to read out the image names as their VoiceOver label, which means anyone using VoiceOver can just move over our three flags to have the system announce which one is correct.

 To fix this we need to add text descriptions for each of our flags, describing them in enough detail that they can be guessed correctly by someone who has learned them, but of course without actually giving away the name of the country.

 If you open your copy of this project, you’ll see it was written to use an array of country names, like this:

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
 
 So, the easiest way to attach labels there – the way that doesn’t require us to change any of our code – is to create a dictionary with country names as keys and accessibility labels as values, like this. Please add this to ContentView:

     let labels = [
         "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
         "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
         "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
         "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
         "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
         "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
         "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
         "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
         "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
         "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
         "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
     ]
 
 And now all we need to do is add the accessibilityLabel() modifier to the flag images. I realize that sounds simple, but the code has to do three things:

 Use countries[number] to get the name of the country for the current flag.
 Use that name as the key for labels.
 Provide a string to use as a default if somehow the country name doesn’t exist in the dictionary. (This should never happen, but there’s no harm being safe!)
 Putting all that together, put this modifier directly below the rest of the modifiers for the flag images:

    .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
 
 And now if you run the game again you’ll see it actually is a game, regardless of whether you use VoiceOver or not. This gets right to the core of accessibility: everyone can have fun playing this game now, regardless of their access needs.
 */

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var correctAnswer = Int.random(in: 0...2)
   
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    
    @State private var questionNumber = 1
    
    @State private var endOfGame = false
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
           
            VStack {
                Spacer()
                Text("Guess the Flag")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(scoreMessage)
        }
        .alert("End of Game", isPresented: $endOfGame) {
            Button("Play again?", action: reset)
        } message: {
            Text("You've reached the end of the game.")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct"
            scoreMessage = "Your score is \(score)"
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "Wrong! That's the flag of \(countries[number])"
            
        }

        if questionNumber <= 8 {
            showingScore = true
        }
    }
    
    func askQuestion() {
        if questionNumber < 8 {
            questionNumber += 1
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        } else {
            endOfGame = true
        }
    }
    
    func reset() {
        questionNumber = 1
        score = 0
        scoreTitle = ""
        scoreMessage = ""
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
