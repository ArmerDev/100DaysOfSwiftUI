//
//  ContentView.swift
//  EdutainmentMultiplicationApp
//
//  Created by James Armer on 14/05/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var numberOfQuestions = 10
    @State private var currentQuestionNumber = 0
    @State private var playersAnswer = ""
    @State private var selectedTimesTable = 2
    @State private var someArray: [qAndA]? = []
    @State private var showingSettings = true
    @State private var score = 0
    @State private var showEndGame = false
    
    
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [.blue, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            if showingSettings {
                gameSetup
            } else {
                gameView
            }
        }
        .alert("End of Game", isPresented: $showEndGame, actions: {
              Button("Play Again") { resetGame() }
            }, message: {
              Text("Your score was \(score)")
            })
        }
    
    
    func createQuestions() {
        
        // TODO: Need to make it so that questions are not repeated!
        
        var questionArray = [qAndA]()
        
        for _ in 0...numberOfQuestions {
            let randomInt = Int.random(in: 1...20)
            questionArray.append(qAndA(question: "\(selectedTimesTable) X \(randomInt)", answer: "\(randomInt * selectedTimesTable)"))
        }
        
        someArray = questionArray
    }
}

struct qAndA: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

extension ContentView {
    var gameSetup: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle.bold())
            
            Stepper("\(selectedTimesTable) Times Table", value: $selectedTimesTable, in: 2...12)
            
            Stepper("\(numberOfQuestions) Questions", value: $numberOfQuestions, in: 5...15, step: 5)
            
            Button("Play") {
                createQuestions()
                showingSettings.toggle()
                currentQuestionNumber += 1
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .padding()
    }
    
    var gameView: some View {
        VStack {
            Text("Score: \(score)")
                .font(.largeTitle)
            
            HStack {
                Text("\(someArray![currentQuestionNumber].question) = ")
                    .font(.title)
                
                TextField("", text: $playersAnswer)
                    .foregroundColor(.black)
                    .bold()
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 75)
            }
            
            Button("Next") {
                if checkAnswerCorrect(playersAnswer: playersAnswer,
                                      actualAnswer: someArray![currentQuestionNumber].answer) {
                    score += 1
                    nextQuestion()
                } else {
                    playersAnswer = ""
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .foregroundColor(.white)
    }
    
    func checkAnswerCorrect(playersAnswer: String, actualAnswer: String) -> Bool {
        playersAnswer == actualAnswer
    }
    
    func nextQuestion() {
        if currentQuestionNumber < numberOfQuestions {
            currentQuestionNumber += 1
            print(currentQuestionNumber)
        } else {
            showEndGame.toggle()
        }
    }
    
    func resetGame() {
        showingSettings = true
        playersAnswer = ""
        currentQuestionNumber = 0
        score = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
