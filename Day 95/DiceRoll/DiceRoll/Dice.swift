//
//  Dice.swift
//  DiceRoll
//
//  Created by James Armer on 13/07/2023.
//

import SwiftUI

struct Dice: View {
    @State private var diceNumber = 5
    var body: some View {
        ZStack {
            Text("\(diceNumber)")
                .bold()
                .frame(width: 50, height: 50)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 5)
                }
        }
    }
}

struct Dice_Previews: PreviewProvider {
    static var previews: some View {
        Dice()
    }
}
