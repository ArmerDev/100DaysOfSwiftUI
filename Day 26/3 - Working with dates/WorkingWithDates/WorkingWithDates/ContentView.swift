//
//  ContentView.swift
//  WorkingWithDates
//
//  Created by James Armer on 09/05/2023.
//

import SwiftUI

/*
 Having users enter dates is as easy as binding an @State property of type Date to a DatePicker SwiftUI control, but things get a little woolier afterwards.

 You see, working with dates is hard. Like, really hard – way harder than you think.

 Take a look at this trivial example:
 */

func trivialExample() {
    let now = Date.now
    let tomorrow = Date.now.addingTimeInterval(86400)
    let range = now...tomorrow
}

/*
 That creates a range from now to the same time tomorrow (86400 is the number of seconds in a day).

 That might seem easy enough, but do all days have 86,400 seconds? If they did, a lot of people would be out of jobs! Think about daylight savings time: sometimes clocks go forward (losing an hour) and sometimes go backwards (gaining an hour), meaning that we might have 23 or 25 hours in those days. Then there are leap seconds: times that get added to the clocks in order to adjust for the Earth’s slowing rotation.

 If you think that’s hard, try running this from your Mac’s terminal: cal. This prints a simple calendar for the current month, showing you the days of the week. Now try running cal 9 1752, which shows you the calendar for September 1752 – you’ll notice 12 whole days are missing, thanks to the calendar moving from Julian to Gregorian.

 Now, the reason I’m saying all this isn’t to scare you off – dates are inevitable in our programs, after all. Instead, I want you to understand that for anything significant – any usage of dates that actually matters in our code – we should rely on Apple’s frameworks for calculations and formatting.

 In the project we’re making we’ll be using dates in three ways:

 Choosing a sensible default “wake up” time.
 Reading the hour and minute they want to wake up.
 Showing their suggested bedtime neatly formatted.
 We could, if we wanted, do all that by hand, but then you’re into the realm of daylight savings, leap seconds, and Gregorian calendars.

 Much better is to have iOS do all that hard work for us: it’s much less work, and it’s guaranteed to be correct regardless of the user’s region settings.

 Let’s tackle each of those individually, starting with choosing a sensible wake up time.

 As you’ve seen, Swift gives us Date for working with dates, and that encapsulates the year, month, date, hour, minute, second, timezone, and more. However, we don’t want to think about most of that – we want to say “give me an 8am wake up time, regardless of what day it is today.”

 Swift has a slightly different type for that purpose, called DateComponents, which lets us read or write specific parts of a date rather than the whole thing.

 So, if we wanted a date that represented 8am today, we could write code like this:
 */

func trivialExample2() {
    var components = DateComponents()
    components.hour = 8
    components.minute = 0
    let date = Calendar.current.date(from: components) ?? Date.now
    /*
     Now, because of difficulties around date validation, that date(from:) method actually returns an optional date, so it’s a good idea to use nil coalescing to say “if that fails, just give me back the current date”
     */
}

/*
 The second challenge is how we could read the hour they want to wake up. Remember, DatePicker is bound to a Date giving us lots of information, so we need to find a way to pull out just the hour and minute components.

 Again, DateComponents comes to the rescue: we can ask iOS to provide specific components from a date, then read those back out. One hiccup is that there’s a disconnect between the values we request and the values we get thanks to the way DateComponents works: we can ask for the hour and minute, but we’ll be handed back a DateComponents instance with optional values for all its properties. Yes, we know hour and minute will be there because those are the ones we asked for, but we still need to unwrap the optionals or provide default values.

 So, we might write code like this:
 */

func trivialExample3() {
    let components = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
}

/*
 The last challenge is how we can format dates and times, and here we have two options.

 First is to rely on the format parameter that has worked so well for us in the past, and here we can ask for whichever parts of the date we want to show.

 For example, if we just wanted the time from a date we would write this:
 */

struct ContentView: View {
    var body: some View {
        Text(Date.now, format: .dateTime.hour().minute())
    }
}

/*
 Or if we wanted the day, month, and year, we would write this:
 */

struct ContentView2: View {
    var body: some View {
        Text(Date.now, format: .dateTime.day().month().year())
    }
}

/*
 You might wonder how that adapts to handling different date formats – for example, here in the UK we use day/month/year, but in some other countries they use month/day/year. Well, the magic is that we don’t need to worry about this: when we write day().month().year() we’re asking for that data, not arranging it, and iOS will automatically format that data using the user’s preferences.

 As an alternative, we can use the formatted() method directly on dates, passing in configuration options for how we want both the date and the time to be formatted, like this:
 */

struct ContentView3: View {
    var body: some View {
        Text(Date.now.formatted(date: .long, time: .shortened))
    }
}

/*
 The point is that dates are hard, but Apple has provided us with stacks of helpers to make them less hard. If you learn to use them well you’ll write less code, and write better code too!
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
        ContentView3()
            .previewDisplayName("ContentView 3")
    }
}
