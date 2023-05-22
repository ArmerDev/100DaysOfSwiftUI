//
//  ContentView.swift
//  FormattingOurMissionView
//
//  Created by James Armer on 22/05/2023.
//

import SwiftUI

/*
 Now that we have all our data in place, we can look at the design for our first screen: a grid of all the missions, next to their mission badges.

 The assets we added earlier contain pictures named “apollo1@2x.png” and similar, which means they are accessible in the asset catalog as “apollo1”, “apollo12”, and so on. Our Mission struct has an id integer providing the number part, so we could use string interpolation such as "apollo\(mission.id)" to get our image name and "Apollo \(mission.id)" to get the formatted display name of the mission.

 Here, though, we’re going to take a different approach: we’re going to add some computed properties to the Mission struct to send that same data back. The result will be the same – “apollo1” and “Apollo 1” – but now the code is in one place: our Mission struct. This means any other views can use the same data without having to repeat our string interpolation code, which in turn means if we change the way these things are formatted – i.e., we change the image names to “apollo-1” or something – then we can just change the property in Mission and have all our code update.
 
 ---
 
 With those two in place we can now take a first pass at filling in ContentView: it will have a NavigationView with a title, a LazyVGrid using our missions array as input, and each row inside there will be a NavigationLink containing the image, name, and launch date of the mission. The only small complexity in there is that our launch date is an optional string, so we need to use nil coalescing to make sure there’s a value for the text view to display.

 First, add this property to ContentView to define an adaptive column layout, and then we will fill out the body of ContentView:
 */

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(missions) { mission in
                        NavigationLink {
                            Text("Detail View")
                        } label: {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                
                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                    
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }

                    }
                }
            }
            .navigationTitle("Moonshot")
        }
    }
}

/*
 I know it looks pretty ugly, but we’ll fix it right up in just a moment. First, let’s focus on what we have so far: a scrolling, vertical grid that uses resizable(), scaledToFit(), and frame() to make the image occupy a 100x100 space while also maintaining its original aspect ratio.

 Run the program now, and apart from the scrappy layout changes you’ll notice the dates aren’t great – although we can look at “1968-12-21” and understand it’s the 21st of December 1968, it’s still an unnatural date format for almost everyone. We can do better than this!

 Swift’s JSONDecoder type has a property called dateDecodingStrategy, which determines how it should decode dates. We can provide that with a DateFormatter instance that describes how our dates are formatted. In this instance, our dates are written as year-month-day, which in the world of DateFormat is written as “y-MM-dd” – that means “a year, then a dash, then a zero-padded month, then a dash, then a zero-padded day”, with “zero-padded” meaning that January is written as “01” rather than “1”.

 Warning: Date formats are case sensitive! mm means “zero-padded minute” and MM means “zero-padded month.”

 So, open Bundle-Decodable.swift and add this code directly after let decoder = JSONDecoder():

     let formatter = DateFormatter()
     formatter.dateFormat = "y-MM-dd"
     decoder.dateDecodingStrategy = .formatted(formatter)

 That tells the decoder to parse dates in the exact format we expect.

 Tip: When working with dates it is often a good idea to be specific about your time zone, otherwise the user’s own time zone is used when parsing the date and time. However, we’re also going to be displaying the date in the user’s time zone, so there’s no problem here.

 If you run the code now… things will look exactly the same. Yes, nothing has changed, but that’s OK: nothing has changed because Swift doesn’t realize that launchDate is a date. After all, we declared it like this:

 let launchDate: String?
 Now that our decoding code understands how our dates are formatted, we can change that property to be an optional Date:

     let launchDate: Date?
 
 …and now our code won’t even compile!

 The problem now is this line of code in ContentView.swift:

     Text(mission.launchDate ?? "N/A")
 
 That attempts to use an optional Date inside a text view, or replace it with “N/A” if the date is empty. This is another place where a computed property works better: we can ask the mission itself to provide a formatted launch date that converts the optional date into a neatly formatted string or sends back “N/A” for missing dates.

 This uses the same formatted() method we’ve used previously, so this should be somewhat familiar for you. Add this computed property to Mission now:

     var formattedLaunchDate: String {
         launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
     }
 
 And now replace the broken text view in ContentView with this:

     Text(mission.formattedLaunchDate)
 
 With that change our dates will be rendered in a much more natural way, and, even better, will be rendered in whatever way is region-appropriate for the user – what you see isn’t necessarily what I see.
 */

// --------

/*
 With that change our dates will be rendered in a much more natural way, and, even better, will be rendered in whatever way is region-appropriate for the user – what you see isn’t necessarily what I see.

 Now let’s focus on the bigger problem: our layout is pretty dull!

 To spruce it up a little, I want to introduce you to two useful features: how to share custom app colors easily, and how to force a dark theme for our app.

 First, colors. There are two ways to do this, and both are useful: you can add colors to your asset catalog with specific names, or you can add them as Swift extensions. They both have their advantages – using the asset catalog lets you work visually, but using code makes it easier to monitor changes using something like GitHub.

 I’m not a big fan of the way asset catalogs force us to use strings for color names, just like we do with image names, so we’re going to take the alternative approach and place our color names into Swift as extensions.

 If we make these extensions on Color we can use them in a handful of places in SwiftUI, but Swift gives us a better option with only a little more code. You see, Color conforms to a bigger protocol called ShapeStyle that is what lets us use colors, gradients, materials, and more as if they were the same thing.

 This ShapeStyle protocol is what the background() modifier uses, so what we really want to do is extend Color but do so in a way that all the SwiftUI modifiers using ShapeStyle work too. This can be done with a very precise extension that literally says “we want to add functionality to ShapeStyle, but only for times when it’s being used as a color.”

 To try this out, make a new Swift file called Color-Theme.swift, and give it this code:
 
     extension ShapeStyle where Self == Color {
         static var darkBackground: Color {
             Color(red: 0.1, green: 0.1, blue: 0.2)
         }

         static var lightBackground: Color {
             Color(red: 0.2, green: 0.2, blue: 0.3)
         }
     }
 
 That adds two new colors called darkBackground and lightBackground, each with precise values for red, green, and blue. But more importantly they place those inside a very specific extension that allows us to use those colors everywhere SwiftUI expects a ShapeStyle.

 I want to put those new colors into action immediately. First, find the VStack containing the mission name and launch date – it should already have .frame(maxWidth: .infinity) on there, but I’d like you to change its modifier order to this:

 .padding(.vertical)
 .frame(maxWidth: .infinity)
 .background(.lightBackground)
 Next, I want to make the outer VStack – the one that is the whole label for our NavigationLink – look more like a box in our grid, which means drawing a line around it and clipping the shape just a little. To get that effect, add these modifiers to the end of it:

 .clipShape(RoundedRectangle(cornerRadius: 10))
 .overlay(
     RoundedRectangle(cornerRadius: 10)
         .stroke(.lightBackground)
 )
 Third, we need to add a little padding to get things away from their edges just a touch. That means adding some simple padding to the mission images, directly after their 100x100 frame:

 .padding()
 Then also adding some horizontal and bottom padding to the grid:

 .padding([.horizontal, .bottom])
 Important: This should be added to the LazyVGrid, not to the ScrollView. If you pad the scroll view you’re also padding its scrollbars, which will look odd.

 Now we can replace the white background with the custom background color we created earlier – add this modifier to the ScrollView, after its navigationTitle() modifier:

 .background(.darkBackground)
 At this point our custom layout is almost done, but to finish up we’re going to look at the remaining colors we have – the light blue color used for our mission text isn’t great, and the “Moonshot” title is black at the top, which is impossible to read against our dark blue background.

 We can fix the first of these by assigning specific colors to those two text fields:

 VStack {
     Text(mission.displayName)
         .font(.headline)
         .foregroundColor(.white)
     Text(mission.formattedLaunchDate)
         .font(.caption)
         .foregroundColor(.white.opacity(0.5))
 }
 Using a translucent white for the foreground color allows just a hint of the color behind to come through.

 As for the Moonshot title, that belongs to our NavigationView, and will appear either black or white depending on whether the user is in light mode or dark mode. To fix this, we can tell SwiftUI our view prefers to be in dark mode always – this will cause the title to be in white no matter what, and will also darken other colors such as navigation bar backgrounds.

 So, to finish up the design for this view please add this final modifier to the ScrollView, below its background color:

 .preferredColorScheme(.dark)
 If you run the app now you’ll see we have a beautifully scrolling grid of mission data that will smoothly adapt to a wide range of device sizes, we have bright white navigation text and a dark navigation background no matter what appearance the user has enabled, and tapping any of our missions will bring in a temporary detail view. A great start!
 */


struct ContentView2: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(missions) { mission in
                        NavigationLink {
                            Text("Detail View")
                        } label: {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                
                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackground)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.lightBackground)
                            )
                        }

                    }
                }
                .padding([.horizontal, .bottom])
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView2()
            .previewDisplayName("ContentView 2")
    }
}
