//
//  ContentView.swift
//  DiceRoll
//
//  Created by James Armer on 12/07/2023.
//

import SwiftUI

struct ContentView: View {
    var numberOfDice = 30
    
    let columns = [
            GridItem(.adaptive(minimum: 80))
        ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                LazyVGrid(columns: columns, spacing: 20){
                    ForEach(0..<numberOfDice) { _ in
                        Dice()
                    }
                }
                
                Spacer()
                Button("Roll Dice") {
                    // roll dice
                }
                .buttonStyle(.borderedProminent)
                
            }
            .navigationTitle("DiceRoll")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // settings
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // History
                    } label: {
                        Label("History", systemImage: "clock")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



//struct ContentView: View {
//    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
//    @State private var rollTotal: Int? = nil
//    @State private var diceImage: String? = nil
//    @State private var rollingCounter = 0
//    @State private var speed: rollSpeed = .fast
//    @State private var speedValue: Double = 0.1
//
//    init() {
//        _timer = State(initialValue: Timer.publish(every: speedValue, on: .main, in: .common).autoconnect())
//    }
//
//    enum rollSpeed: Double {
//        case fast = 0.1
//        case medium = 0.5
//        case slow = 0.9
//    }
//
//    var body: some View {
//        VStack {
//            if let total = rollTotal {
//                Text("\(total)")
//                    .font(.largeTitle)
//            } else {
//                Text(" ")
//                    .font(.largeTitle)
//            }
//
//            Spacer()
//
//            if let image = diceImage {
//                Image(image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 100, height: 100)
//            }
//
//            Spacer()
//
//            Button("Roll Dice") {
//                rollingCounter = 0
//                timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
//            }
//            .buttonStyle(.borderedProminent)
//            .onReceive(timer) { _ in
//                rollDice()
//            }
//        }
//        .padding()
//    }
//
//    func rollDice() {
//
//        speedValue += 0.05
//
//        rollingCounter += 1
//
//        if rollingCounter == 10 {
//            speed = .medium
//        } else if rollingCounter == 20 {
//            speed = .slow
//        } else if rollingCounter == 30 {
//            self.timer.upstream.connect().cancel()
//        }
//
//        rollTotal = Int.random(in: 1...6)
//        diceImage = "\(rollTotal!)"
//    }
//}
