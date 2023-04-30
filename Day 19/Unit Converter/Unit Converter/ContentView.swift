//
//  ContentView.swift
//  Unit Converter


import SwiftUI

struct ContentView: View {
    
    enum Units: String, CaseIterable {
        case mm, cm, m, km
    }
    
    @State private var inputUnit: Units = .cm
    @State private var outputUnit: Units = .m
    @State private var inputValue = 0.0
    @FocusState private var valueIsFocused: Bool
    
    var outputValue: Double {
        
        var baseValue: Double
        
        switch inputUnit {
        case .mm: baseValue = inputValue
        case .cm: baseValue = inputValue * 10
        case .m: baseValue = inputValue * 1000
        case .km: baseValue = inputValue * 1000000
        }
        
        switch outputUnit {
        case .mm: return baseValue
        case .cm: return baseValue / 10
        case .m: return baseValue / 1000
        case .km: return baseValue / 1000000
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        TextField("Value", value: $inputValue, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($valueIsFocused)
                        Text(inputUnit.rawValue)
                    }
                } header: {Text("Input Value") }
                
                Section {
                    Picker("Original Unit", selection: $inputUnit) {
                        ForEach(Units.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {Text("Original Unit")}
                
                Section {
                    HStack {
                        Text("\(outputValue.formatted())")
                        Spacer()
                        Text(outputUnit.rawValue)
                    }
                } header: { Text("Output Value") }
                
                Section {
                    Picker("Conversion Unit", selection: $outputUnit) {
                        ForEach(Units.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: { Text("Conversion Unit") }
                
            }
            .navigationTitle("Unit Conversion")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        valueIsFocused = false
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
