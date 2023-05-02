//
//  ContentView.swift
//  PlayerScoreAlert
//
//  Created by James Armer on 02/05/2023.
//

import SwiftUI

/*
 In order for this game to be fun, we need to randomise the order in which flags are shown, trigger an alert telling them whether they were right or wrong whenever they tap a flag, then reshuffle the flags.

 We already set correctAnswer to a random integer, but the flags always start in the same order. To fix that we need to shuffle the countries array when the game starts.
 */

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    // The shuffled() method automatically takes care of randomising the array order for us.
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    /*
     Now for the more interesting part: when a flag has been tapped, what should we do? We need to replace the // flag was tapped comment with some code that determines whether they tapped the correct flag or not, and the best way of doing that is with a new method that accepts the integer of the button and checks whether that matches our correctAnswer property.

     Regardless of whether they were correct, we want to show the user an alert saying what happened so they can track their progress. So, add a property to store whether the alert is showing or not, as well as a property to store the title that will be shown inside the alert.
     */
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                }
                
                ForEach(0..<3) { number in
                    Button {
                        // Use the new method created below
                        flagTapped(number)
                    } label: {
                        Image(countries[number])
                            .renderingMode(.original)
                    }
                }
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is ???")
        }
    }
    
    /*
     The method we write will accept the number of the button that was tapped, compare that against the correct answer, then set the two new @State properties we added above to show a meaningful alert.
     */
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong"
        }

        showingScore = true
    }
    
    /*
     Before we show the alert, we need to think about what happens when the alert is dismissed. Obviously the game shouldn’t be over, otherwise the whole thing would be over immediately.

     Instead we’re going to write an askQuestion() method that resets the game by shuffling up the countries and picking a new correct answer:
     */
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
