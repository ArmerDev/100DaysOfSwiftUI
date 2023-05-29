//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by James Armer on 29/05/2023.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var habits: Habits
    @State private var habitName = ""
    @State private var habitDescription = ""
    @State private var trackingQuantity = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name of habit"){
                    TextField(text: $habitName) {
                        Text("Name")
                    }
                }
                
                Section("Description of habit"){
                    TextField(text: $habitDescription) {
                        Text("Description")
                    }
                }
                
                Section("Starting Quantity"){
                    Stepper(value: $trackingQuantity) {
                        Text("Current quantity: \(trackingQuantity)")
                    }
                }
            }
            .navigationTitle("Add Habit")
            .toolbar {
                Button {
                    habits.habits.append(Habit(name: habitName, description: habitDescription, quantity: trackingQuantity))
                    dismiss()
                } label: {
                    Text("Done")
                }

            }
        }
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(habits: Habits())
    }
}
