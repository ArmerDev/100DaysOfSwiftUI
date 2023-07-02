//
//  ContentView.swift
//  PostingNotificationsToTheLockScreen
//
//  Created by James Armer on 02/07/2023.
//

import SwiftUI

/*
 For the final part of our app, we’re going to add another button to our list swipe actions, letting users opt to be reminded to contact a particular person. This will use iOS’s UserNotifications framework to create a local notification, and we’ll conditionally include it in the swipe actions as part of our existing if check – the button will only be shown if the user hasn’t been contacted already.

 Much more interesting is how we schedule the local notifications. Remember, the first time we try this we need to use requestAuthorization() to explicitly ask for permission to show a notification on the lock screen, but we also need to be careful subsequent times because the user can retroactively change their mind and disable notifications.

 One option is to call requestAuthorization() every time we want to post a notification, and honestly that works great: the first time it will show an alert, and all other times it will immediately return success or failure based on the previous response.

 However, in the interests of completion I want to show you a more powerful alternative: we can request the current authorization settings, and use that to determine whether we should schedule a notification or request permission. The reason it’s helpful to use this approach rather than just requesting permission repeatedly, is that the settings object handed back to us includes properties such as alertSetting to check whether we can show an alert or not – the user might have restricted this so all we can do is display a numbered badge on our icon.

 So, we’re going to call getNotificationSettings() to read whether notifications are currently allowed. If they are, we’ll show a notification. If they aren’t, we’ll request permissions, and if that comes back successfully then we’ll also show a notification. Rather than repeat the code to schedule a notification, we’ll put it inside a closure that can be called in either scenario.

 Start by adding import UserNotifications near the top of ProspectsView.swift
 */

struct ContentView: View {
    @StateObject var prospects = Prospects()
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }
            
            ProspectsView(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }
            
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
        .environmentObject(prospects)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

