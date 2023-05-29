//
//  HabitDetailView.swift
//  HabitTracker
//
//  Created by James Armer on 29/05/2023.
//

import SwiftUI

struct HabitDetailView: View {
    @ObservedObject var habits: Habits
    var habit: Habit
    var body: some View {
        VStack(alignment: .leading) {
            Text(habit.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .opacity(0.1)
            
            VStack {
                Text("Tracking")
                    .font(.title.bold())
                    .padding()
                
                HStack {
                    Button {
                        var newActivity = habit
                        newActivity.quantity -= 1
                        print(newActivity.quantity)
                        if let index = habits.habits.firstIndex(of: habit) {
                            habits.habits[index] = newActivity
                        }
                    } label: {
                        Image(systemName: "minus.circle")
                    }
                    
                    Text("\(habit.quantity)")
                    
                    Button {
                        var newActivity = habit
                        newActivity.quantity += 1
                        print(newActivity.quantity)
                        if let index = habits.habits.firstIndex(of: habit) {
                            habits.habits[index] = newActivity
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                    }

                }
            }
            
            Spacer()
        }
        .navigationTitle(habit.name)
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HabitDetailView(habits: Habits(), habit: Habit(name: "Preview Example", description: """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras efficitur purus sed lectus cursus dapibus. Nunc non nulla cursus, posuere elit et, luctus libero. Donec interdum, ante non auctor pellentesque, magna ex rutrum diam, sit amet suscipit mi ipsum in metus. Phasellus rhoncus diam at laoreet viverra. Nullam eget aliquet dui. Nunc dapibus turpis enim, ac iaculis lacus ultrices vel. Etiam in lacus sit amet odio tincidunt sollicitudin.
""", quantity: 10))
        }
    }
}
