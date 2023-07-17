//
//  WelcomeView.swift
//  MakingNavigationViewWorkInLandscape
//
//  Created by James Armer on 17/07/2023.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker!")
                .font(.largeTitle)

            Text("Please select a resort from the left-hand menu; swipe from the left edge to show it.")
                .foregroundColor(.secondary)
        }
    }
}

/*
 That’s all just static text; it will only be shown when the app first launches, because as soon as the user taps any of our navigation links it will get replaced with whatever they were navigating to.

 To put that into ContentView so the two parts of our UI can be used side by side, all we need to do is add a second view to our NavigationView. So navigate to ContentView and add it now...
 */

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
