//
//  ContentView.swift
//  DatePicker
//
//  Created by James Armer on 09/05/2023.
//

import SwiftUI

/*
 SwiftUI gives us a dedicated picker type called DatePicker that can be bound to a date property. Yes, Swift has a dedicated type for working with dates, and it’s called – unsurprisingly – Date.

 So, to use it you’d start with an @State property such as this:

 */

struct ContentView: View {
    @State private var wakeUp = Date.now
    
    var body: some View {
        // You could then bind that to a date picker like this:
        DatePicker("Please enter a date", selection: $wakeUp)
            .padding()
    }
}

/*
 Try running that in the simulator so you can see how it looks. You should see a tappable options to control days and times, plus the “Please enter a date” label on the left.

 Now, you might think that label looks ugly, and try replacing it with this:
 */

struct ContentView2: View {
    @State private var wakeUp = Date.now
    
    var body: some View {
        DatePicker("", selection: $wakeUp)
            .padding()
    }
}

/*
 But if you do that you now have two problems: the date picker still makes space for a label even though it’s empty, and now users with the screen reader active (more familiar to us as VoiceOver) won’t have any idea what the date picker is for.

 A better alternative is to use the labelsHidden() modifier, like this:
 */

struct ContentView3: View {
    @State private var wakeUp = Date.now
    
    var body: some View {
        DatePicker("Please enter a date", selection: $wakeUp)
            .labelsHidden()
    }
}

/*
 That still includes the original label so screen readers can use it for VoiceOver, but now they aren’t visible onscreen any more – the date picker won’t be pushed to one side by some empty text.

 Date pickers provide us with a couple of configuration options that control how they work. First, we can use displayedComponents to decide what kind of options users should see:

    -  If you don’t provide this parameter, users see a day, hour, and minute.
    - If you use .date users see month, day, and year.
    - If you use .hourAndMinute users see just the hour and minute components.
 
 So, we can select a precise time like this:
 */

struct ContentView4: View {
    @State private var wakeUp = Date.now
    
    var body: some View {
        DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
            .padding()
            
    }
}

/*
 Finally, there’s an in parameter that works just the same as with Stepper: we can provide it with a date range, and the date picker will ensure the user can’t select beyond it.

 Now, we’ve been using ranges for a while now, and you’re used to seeing things like 1...5 or 0..<10, but we can also use Swift dates with ranges. For example:
 */

struct ContentView5: View {
    @State private var wakeUp = Date.now
    
    var body: some View {
        DatePicker("Please enter a date", selection: $wakeUp, in: exampleDates())
            .padding()
    }
    
    func exampleDates() -> ClosedRange<Date> {
        // create a second Date instance set to one day in seconds from now
        let tomorrow = Date.now.addingTimeInterval(86400)

        // create a range from those two
        let range = Date.now...tomorrow
        
        return range
    }
}

/*
 That’s really useful with DatePicker, but there’s something even better: Swift lets us form one-sided ranges – ranges where we specify either the start or end but not both, leaving Swift to infer the other side.

 For example, we could create a date picker like this:
 */

struct ContentView6: View {
    @State private var wakeUp = Date.now
    
    var body: some View {
        DatePicker("Please enter a date", selection: $wakeUp, in: Date.now...)
            .padding()
            
    }
}

/*
 That will allow all dates in the future, but none in the past – read it as “from the current date up to anything.”
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
        ContentView3()
            .previewDisplayName("ContentView 3")
        ContentView4()
            .previewDisplayName("ContentView 4")
        ContentView5()
            .previewDisplayName("ContentView 5")
        ContentView6()
            .previewDisplayName("ContentView 6")
    }
}
