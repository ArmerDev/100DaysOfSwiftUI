//
//  ContentView.swift
//  EdutainmentMultiplicationApp
//
//  Created by James Armer on 14/05/2023.
//

import SwiftUI

struct ContentView: View {
    
    var numberOfQuestions = 10
    var selectedTimesTable = 2
    @State private var someArray: [qAndA] = []
    
    var body: some View {
        List {
            ForEach(someArray) { array in
                HStack {
                    Text(array.question)
                    Spacer()
                    
                }
            }
        }
        .onAppear(perform: createQuestions)
        
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
