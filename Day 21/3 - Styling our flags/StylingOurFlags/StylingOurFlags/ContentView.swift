//
//  ContentView.swift
//  StylingOurFlags
//
//  Created by James Armer on 02/05/2023.
//

import SwiftUI

/*
 Our game now works, although it doesn’t look great. Fortunately, we can make a few small tweaks to our design to make the whole thing look better.

 First, let’s replace the solid blue background color with a linear gradient from blue to black, which ensures that even if a flag has a similar blue stripe it will still stand out against the background.
 */

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
   
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            /*
             We can control the size and style of text using the font() modifier, which lets us select from one of the built-in font sizes on iOS. As for adjusting the weight of fonts – whether we want super-thin text, slightly bold text, etc – we can get fine-grained control over that by adding a weight() modifier to whatever font we ask for.

             Let’s use both of these here, so you can see them in action.
             */
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .font(.subheadline.weight(.heavy))
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .font(.largeTitle.weight(.semibold))
                        .foregroundColor(.white)
                }
                
                /*
                 “Large title” is the largest built-in font size iOS offers us, and automatically scales up or down depending on what setting the user has for their fonts – a feature known as Dynamic Type. We’re overriding the weight of the font so it’s a little bolder, but it will still scale up or down as needed.

                 Finally, let’s jazz up those flag images a little. SwiftUI gives us a number of modifiers to affect the way views are presented, and we’re going to use two here: one to change the shape of flags, and one to add a shadow.

                 There are four built-in shapes in Swift: rectangle, rounded rectangle, circle, and capsule. We’ll be using capsule here: it ensures the corners of the shortest edges are fully rounded, while the longest edges remain straight – it looks great for buttons. Making our image capsule shaped is as easy as adding the .clipShape(Capsule()) modifier.
                 
                 And finally we want to apply a shadow effect around each flag, making them really stand out from the background. This is done using shadow(), which takes the color, radius, X, and Y offset of the shadow, but if you skip the color we get a translucent black, and if we skip X and Y it assumes 0 for them – all sensible defaults.
                 */
                
                ForEach(0..<3) { number in
                    Button {
                        flagTapped(number)
                    } label: {
                        Image(countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                    }
                }
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is ???")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong"
        }

        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
