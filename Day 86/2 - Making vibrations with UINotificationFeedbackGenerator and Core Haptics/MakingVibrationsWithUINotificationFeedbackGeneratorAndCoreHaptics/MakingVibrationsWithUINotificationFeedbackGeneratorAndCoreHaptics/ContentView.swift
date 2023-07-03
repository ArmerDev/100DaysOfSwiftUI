//
//  ContentView.swift
//  MakingVibrationsWithUINotificationFeedbackGeneratorAndCoreHaptics
//
//  Created by James Armer on 03/07/2023.
//

import SwiftUI
import CoreHaptics

/*
 Although SwiftUI doesn’t come with any haptic functionality built in, it’s easy enough for us to add using UIKit and Core Haptics - two frameworks built right into the system, and available on all modern iPhones. If you haven’t heard the term before, “haptics” involves small motors in the device to create sensations such as taps and vibrations.

 UIKit has a very simple implementation of haptics, but that doesn’t mean you should rule it out: it can be simple because it focuses on built-in haptics such as “success” or “failure”, which means users can come to learn how certain things feel. That is, if you use the success haptic then some users – particularly those who rely on haptics more heavily, such as blind users – will be able to know the result of an operation without any further output from your app.

 To try out UIKit’s haptics, add this simpleSuccess method to ContentView, which can be triggered with a simple onTapGesture():
 */

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .onTapGesture(perform: simpleSuccess)
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

/*
 Try replacing .success with .error or .warning and see if you can tell the difference – .success and .warning are similar but different, I think.
 */

struct ContentView2: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Success Haptic")
                .onTapGesture(perform: simpleSuccess)
            
            Text("Error Haptic")
                .onTapGesture(perform: simpleError)
            
            Text("Warning Haptic")
                .onTapGesture(perform: simpleWarning)
        }
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func simpleError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    func simpleWarning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
}

/*
 For more advanced haptics, Apple provides us with a whole framework called Core Haptics. This thing feels like a real labor of love by the Apple team behind it, and I think it was one of the real hidden gems introduced in iOS 13 – certainly I pounced on it as soon as I saw the release notes!

 Core Haptics lets us create hugely customizable haptics by combining taps, continuous vibrations, parameter curves, and more. I don’t want to go into too much depth here because it’s a bit off topic, but I do at least want to give you an example so you can try it for yourself.

 First add import CoreHaptics near the top of ContentView.swift.
 
 Next, we need to create an instance of CHHapticEngine as a property – this is the actual object that’s responsible for creating vibrations, so we need to create it up front before we want haptic effects.

 So, add this property to ContentView:

    @State private var engine: CHHapticEngine?
 
 We’re going to create that as soon as our main view appears. When creating the engine you can attach handlers to help resume activity if it gets stopped, such as when the app moves to the background, but here we’re going to keep it simple: if the current device supports haptics we’ll start the engine, and print an error if it fails.

 Add this prepareHaptics method to ContentView.
 
 Then its time for the fun part: we can configure parameters that control how strong the haptic should be (.hapticIntensity) and how “sharp” it is (.hapticSharpness), then put those into a haptic event with a relative time offset. “Sharpness” is an odd term, but it will make more sense once you’ve tried it out – a sharpness value of 0 really does feel dull compared to a value of 1. As for the relative time, this lets us create lots of haptic events in a single sequence.
 
 Add this complexSuccess method to ContentView now:
*/

struct ContentView3: View {
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        Text("Hello, World!")
            .onAppear(perform: prepareHaptics)
            .onTapGesture(perform: complexSuccess)
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("there was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
}

/*
 To try out our custom haptics, modify the body property of ContentView to this:

 Text("Hello, World!")
     .onAppear(perform: prepareHaptics)
     .onTapGesture(perform: complexSuccess)
 
 That makes sure the haptics system is started so the tap gesture works correctly.

 If you want to experiment with haptics further, replace the let intensity, let sharpness, and let event lines with whatever haptics you want. For example, if you replace those three lines with this next code you’ll get several taps of increasing then decreasing intensity and sharpness:
 */

struct ContentView4: View {
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        Text("Hello, World!")
            .onAppear(perform: prepareHaptics)
            .onTapGesture(perform: complexSuccess)
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("there was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
