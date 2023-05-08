//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by James Armer on 08/05/2023.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    
    @State private var shouldWin = Bool.random()
    @State private var computersPlay = "👊"
    @State private var usersPlay = ""
    @State private var numberOfTurns = 0
    @State private var endOfGame = false
    @State private var score = 0
    @State private var incorrectPlayAlert = false
    @State private var drawPlayAlert = false
    
    
    let rockPaperScissorsArray = ["👊", "✋", "✌️"]
    
    var body: some View {

        ZStack {
            RadialGradient(colors: [.black, .blue], center: .center, startRadius: 1 , endRadius: 750)
                .ignoresSafeArea()
            VStack {
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title)
                
                Spacer()
                
                Text(computersPlay)
                    .font(.system(size: 100))
                
                Text(shouldWin ? "Win" : "Lose")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                HStack {
                    
                    // Game Buttons
                    ForEach(rockPaperScissorsArray, id: \.self) { move in
                        Button {
                            usersPlay = move
                            checkAnswer()
                            newRound()
                        } label: {
                            Text(move)
                                .customButton()
                        }
                        .alert("Incorrect Play", isPresented: $incorrectPlayAlert) {
                            Button("Continue") {
                                score -= 1
                                incorrectPlayAlert = false
                            }
                        } message: {
                            Text("You lose a point!")
                        }
                        .alert("Draw", isPresented: $drawPlayAlert) {
                            Button("Continue") {
                                drawPlayAlert = false
                            }
                        }
                    }
                }
                
                Spacer()
                
            }
            .alert("End Of Game", isPresented: $endOfGame) {
                Button("Play Again") {
                    resetGame()
                }
            } message: {
                Text("""
                    End of Game
                    Your score is \(score)
                    """)
            }
        }
    }
    
    func newRound() {
        computersPlay = rockPaperScissorsArray.randomElement()!
        shouldWin.toggle()
        numberOfTurns += 1
        
        if numberOfTurns == 10 {
            endOfGame = true
        }
    }
    
    func resetGame() {
        computersPlay = rockPaperScissorsArray.randomElement()!
        shouldWin = Bool.random()
        usersPlay = ""
        score = 0
        numberOfTurns = 0
        
    }
    
    func correctAnswer() {
        score += 1
    }

    func checkAnswer() {
        
        if shouldWin == true {
            switch computersPlay {
            case "👊" :
                switch usersPlay {
                    case "👊" : drawPlayAlert = true
                    case "✋" : correctAnswer()
                    case "✌️" : incorrectPlayAlert = true
                    default: print("Somethings wrong...")
                }
                
            case "✋" :
                switch usersPlay {
                    case "👊" : incorrectPlayAlert = true
                    case "✋" : drawPlayAlert = true
                    case "✌️" : correctAnswer()
                    default: print("Somethings wrong...")
                }
                
                
            case "✌️" :
                switch usersPlay {
                    case "👊" : correctAnswer()
                    case "✋" : incorrectPlayAlert = true
                    case "✌️" : drawPlayAlert = true
                    default: print("Somethings wrong...")
                }
                
            default: print("Somethings wrong...")
            }
        } else {
            switch computersPlay {
            case "👊" :
                switch usersPlay {
                    case "👊" : drawPlayAlert = true
                    case "✋" : incorrectPlayAlert = true
                    case "✌️" : correctAnswer()
                    default: print("Somethings wrong...")
                }
                
            case "✋" :
                switch usersPlay {
                    case "👊" : correctAnswer()
                    case "✋" : drawPlayAlert = true
                    case "✌️" : incorrectPlayAlert = true
                    default: print("Somethings wrong...")
                }
                
                
            case "✌️" :
                switch usersPlay {
                    case "👊" : incorrectPlayAlert = true
                    case "✋" : correctAnswer()
                    case "✌️" : drawPlayAlert = true
                    default: print("Somethings wrong...")
                }
                
            default: print("Somethings wrong...")
            }
        }
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 70))
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(15)
    }
}

extension View {
    func customButton() -> some View {
        modifier(ButtonModifier())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
