//
//  ContentView.swift
//  Drawing
//
//  Created by James Armer on 28/05/2023.
//

import SwiftUI

struct Arrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: (rect.midY * 0.75)))
        path.addLine(to: CGPoint(x: (rect.midX * 0.5), y: (rect.midY * 0.75)))
        path.addLine(to: CGPoint(x: (rect.midX * 0.5), y: rect.maxY))
        path.addLine(to: CGPoint(x: (rect.midX * 1.5), y: rect.maxY))
        path.addLine(to: CGPoint(x: (rect.midX * 1.5), y: (rect.midY * 0.75)))
        path.addLine(to: CGPoint(x: rect.maxX, y: (rect.midY * 0.75)))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.closeSubpath()
        
        return path
    }
}

struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100
    var gradientTop = UnitPoint(x: 0.0, y: 0.0)
    var gradientBottom = UnitPoint(x: 0.0, y: 0.0)

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: Double(value))
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color(for: value, brightness: 1),
                                color(for: value, brightness: 0.5)
                            ]),
                            startPoint: gradientTop,
                            endPoint: gradientBottom
                        ),
                        lineWidth: 2
                    )
            }
        }
        .drawingGroup()
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ContentView: View {
    @State private var lineThickness = 5.0
    var body: some View {
        Arrow()
            .stroke(.red, lineWidth: lineThickness)
            .frame(width: 300, height: 500)
            .onTapGesture {
                withAnimation {
                    lineThickness = Double.random(in: 1...30)
                }
            }
    }
}

struct ContentView2: View {
    @State private var colorCycle = 0.0
    @State private var gradientTopX = 0.0
    @State private var gradientTopY = 0.0
    @State private var gradientBottomX = 0.0
    @State private var gradientBottomY = 0.0
    
    var body: some View {
        VStack {
            ColorCyclingRectangle(amount: colorCycle, gradientTop: UnitPoint(x: gradientTopX, y: gradientTopY), gradientBottom: UnitPoint(x: gradientBottomX, y: gradientBottomY))
                .frame(width: 300, height: 300)

            Slider(value: $colorCycle)
                .padding()
            
            Text("Gradient Top")
            Slider(value: $gradientTopX)
                .padding()
            Slider(value: $gradientTopY)
                .padding()
            
            Text("Gradient Bottom")
            Slider(value: $gradientBottomX)
                .padding()
            Slider(value: $gradientBottomY)
                .padding()
            
            
            
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
