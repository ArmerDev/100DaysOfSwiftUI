//
//  ContentView.swift
//  EdutainmentMultiplicationApp
//
//  Created by James Armer on 14/05/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var numberOfQuestions = 10
    @State private var selectedTimesTable = 2
    @State private var someArray: [qAndA] = []
    @State private var showingSettings = true
    
    
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [.blue, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            if showingSettings {
                VStack {
                    Text("Settings")
                        .font(.largeTitle.bold())
                    
                    Stepper("\(selectedTimesTable) Times Table", value: $selectedTimesTable, in: 2...12)
                    
                    Stepper("\(numberOfQuestions) Questions", value: $numberOfQuestions, in: 5...15, step: 5)
                    
                    Button("Play") {
                        createQuestions()
                        showingSettings.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .padding()
            } else {
                Text("Insert Questions Here...")
                    .foregroundColor(.white)
            }
        }
        
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
