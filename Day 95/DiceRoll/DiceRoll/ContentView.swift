//
//  ContentView.swift
//  DiceRoll
//
//  Created by James Armer on 12/07/2023.
//

import SwiftUI

struct ContentView: View {
    let diceTypes = [4, 6, 8, 10, 12, 20, 100]
    
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    @AppStorage("selectedDiceType") var selectedDiceType = 6
    @AppStorage("numberToRoll") var numberToRoll = 4
    
    @State private var currentResult = DiceResult(type: 0, number: 0)
    
    let timer = Timer.publish(every: 0.1, tolerance: 0.1, on: .main, in: .common).autoconnect()
    @State private var stoppedDice = 0
    
    @State private var feedback = UIImpactFeedbackGenerator(style: .rigid)
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedRolls.json")
    @State private var savedResults = [DiceResult]()
    
    @State private var showingSettings = false
    
    @State private var showingDicePlaceholder = true
    
    @State private var showingPreviousTotals = false
    
    @State private var counterForShakeTip = 0
    @State private var shakeOccurred = false
    @State private var showingShakeTip = false
    
    let columns: [GridItem] = [
        .init(.adaptive(minimum: 60))
    ]
    
    var body: some View {
        ZStack {
            
            NavigationStack {
                VStack {
                    if showingDicePlaceholder{
                        LazyVGrid(columns: columns) {
                                ForEach(0..<numberToRoll, id: \.self) { rollNumber in
                                    Text(" ")
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .foregroundColor(.black)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 3)
                                        .font(.title)
                                        .padding(5)
                                }
                        }
                        .padding()
                    } else {
                        LazyVGrid(columns: columns) {
                            ForEach(0..<currentResult.rolls.count, id: \.self) { rollNumber in
                                Text(String(currentResult.rolls[rollNumber]))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                                    .foregroundColor(.black)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                                    .font(.title)
                                    .padding(5)
                            }
                        }
                        .padding()
                        .accessibilityElement()
                        .accessibilityLabel("Latest roll: \(currentResult.description)")
                    }
                    
                    Spacer()
                    
                    if showingShakeTip {
                            Text("Tip: You can shake your device to roll the dice!")
                                .transition(.opacity)
                    }
                    
                    Button {
                        rollDice()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(stoppedDice < currentResult.rolls.count ? .gray : .blue)
                            
                            Text("Roll Dice")
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                    .padding()
                    .disabled(stoppedDice < currentResult.rolls.count)
                }
                .navigationTitle("Dice Rolls")
                .onReceive(timer) {  date in
                    updateDice()
                }
                .onChange(of: counterForShakeTip , perform: { _ in
                    if shakeOccurred {
                        withAnimation {
                            showingShakeTip = false
                        }
                        
                        return
                    }
                    
                    if counterForShakeTip >= 3 && shakeOccurred == false {
                        withAnimation {
                            showingShakeTip = true
                        }
                    }
                    
                })
                .onShake {
                    rollDice()
                    shakeOccurred = true
                }
                .onAppear(perform: load)
                .toolbar {
                    ToolbarItem {

                            NavigationLink {
                                if savedResults.isEmpty == true {
                                    VStack {
                                        Image(systemName: "dice")
                                        Text("No previous dice rolls to display")
                                    }
                                    .navigationTitle("Previous Rolls")
                                } else {
                                    Form {
                                        ForEach(savedResults) { result in
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text("\(result.number) x D\(result.type)")
                                                        .font(.headline)
                                                    
                                                    Text(result.rolls.map(String.init).joined(separator: ", "))
                                                }
                                                
                                                if showingPreviousTotals {
                                                    Spacer()
                                                    
                                                    Text("\(result.rollTotal)")
                                                        .font(.title)
                                                        .frame(width: 50)
                                                        .background(.gray.opacity(0.5))
                                                        .cornerRadius(10)
                                                    
                                                }
                                            }
                                            .accessibilityElement()
                                            .accessibilityLabel("\(result.number) D\(result.type), \(result.description)")
                                        }
                                        .onDelete { indexSet in
                                            savedResults.remove(atOffsets: indexSet)
                                            save()
                                        }
                                    }
                                    .toolbar {
                                        ToolbarItem {
                                            Toggle("Show Totals", isOn: $showingPreviousTotals)
                                        }
                                    }
                                    .navigationTitle("Previous Rolls")
                                }
                            } label: {
                                Image(systemName: "calendar.badge.clock")
                                    .accessibilityLabel("View Roll History")
                            }
                        
                    }
                    
                    ToolbarItem {
                        Button {
                            showingSettings = true
                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                }
                .sheet(isPresented: $showingSettings) {
                    VStack(spacing: 20) {
                        HStack {
                            Text("Settings")
                                .font(.largeTitle.bold())
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Picker("Type of dice", selection: $selectedDiceType) {
                            ForEach(diceTypes, id: \.self) { type in
                                Text("D\(type)")
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Stepper("Number of dice: \(numberToRoll)", value: $numberToRoll, in: 1...20)
                        
                        
                        Spacer()
                        
                        Button {
                            showingSettings = false
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(height: 55)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.blue)
                                
                                Text("Dismiss")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                        .padding()
                    }
                    .padding()
                    .presentationDetents([.fraction(0.45)])
                }
                .onChange(of: numberToRoll) { _ in
                    showingDicePlaceholder = true
                }
            }
        }
    }
    
    func rollDice() {
        showingDicePlaceholder = false
        counterForShakeTip += 1
        currentResult = DiceResult(type: selectedDiceType, number: numberToRoll)
        
        if voiceOverEnabled {
            stoppedDice = numberToRoll
            savedResults.insert(currentResult, at: 0)
            save()
        } else {
            stoppedDice = -20
        }
    }
    
    func updateDice() {
        guard stoppedDice < currentResult.rolls.count else { return }
        
        for i in stoppedDice..<numberToRoll {
            if i < 0 { continue }
            currentResult.rolls[i] = Int.random(in: 1...selectedDiceType)
            feedback.impactOccurred()
        }
        
        stoppedDice += 1
        
        if stoppedDice == numberToRoll {
            savedResults.insert(currentResult, at: 0)
            save()
        }
    }
    
    func load() {
        if let data = try? Data(contentsOf: savePath) {
            if let results = try? JSONDecoder().decode([DiceResult].self, from: data) {
                savedResults = results
            }
        }
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(savedResults) {
            try? data.write(to: savePath, options: [.atomic, .completeFileProtection])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
