//
//  ContentView.swift
//  SwitchingViewStatesWithEnums
//
//  Created by James Armer on 21/06/2023.
//

import SwiftUI

/*
 You’ve seen how we can use regular Swift conditions to present one type of view or the other, and we looked at code along the lines of this:

 if Bool.random() {
     Rectangle()
 } else {
     Circle()
 }
 
 Tip: When returning different kinds of view, make sure you’re either inside the body property or using something like @ViewBuilder or Group.

 Where conditional views are particularly useful is when we want to show one of several different states, and if we plan it correctly we can keep our view code small and also easy to maintain – it’s a great way to start training your brain to think about SwiftUI architecture.

 There are two parts to this solution. The first is to define an enum for the various view states you want to represent. For example, you might define this as a nested enum:

 enum LoadingState {
     case loading, success, failed
 }
 
 Next, create individual views for those states. I’m just going to use simple text views here, but they could hold anything:

 struct LoadingView: View {
     var body: some View {
         Text("Loading...")
     }
 }

 struct SuccessView: View {
     var body: some View {
         Text("Success!")
     }
 }

 struct FailedView: View {
     var body: some View {
         Text("Failed.")
     }
 }
 
 Those views could be nested if you want, but they don’t have to be – it really depends on whether you plan to use them elsewhere and the size of your app.

 With those two parts in place, we now effectively use ContentView as a simple wrapper that tracks the current app state and shows the relevant child view. That means giving it a property to store the current LoadingState value:

 var loadingState = LoadingState.loading
 Then filling in its body property with code that shows the correct view based on the enum value, like this:

 if loadingState == .loading {
     LoadingView()
 } else if loadingState == .success {
     SuccessView()
 } else if loadingState == .failed {
     FailedView()
 }
 
 Using this approach our ContentView doesn’t spiral out of control as more and more code gets added to the views, and in fact has no idea what loading, success, or failure even look like. You could also use a switch instead, like how is shown below:
 */

enum LoadingState {
    case loading, success, failed
}

struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Failed.")
    }
}

struct ContentView: View {
    var loadingState = LoadingState.loading
    var body: some View {
        switch loadingState {
        case .loading:
            LoadingView()
        case .success:
            SuccessView()
        case .failed:
            FailedView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
