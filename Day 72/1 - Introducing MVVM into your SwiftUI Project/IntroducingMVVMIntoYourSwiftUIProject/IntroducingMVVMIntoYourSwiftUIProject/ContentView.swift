//
//  ContentView.swift
//  IntroducingMVVMIntoYourSwiftUIProject
//
//  Created by James Armer on 23/06/2023.
//

import MapKit
import SwiftUI

/*
 So far I’ve introduced you to a range of concepts across Swift and SwiftUI, and I’ve also dropped a few tips on ways to organize your code better. Well, here I want to explore that latter part a bit further: we’re going to look at what is commonly called a software architecture, or the more grandiose name an architectural design pattern – really it’s just a particular way of structuring your code.

 The pattern we’re going to look at is called MVVM, which is an acronym standing for Model View View-Model. This is a terrifically bad name, and thoroughly confuses people, but I’m afraid we’re rather stuck with it at this point. There is no single definition of what is MVVM, and you’ll find all sorts of people arguing about it online, but that’s okay – here we’re going to keep it simple, and use MVVM as a way of getting some of our program state and logic out of our view structs. We are, in effect, separating logic from layout.

 We’ll explore that definition as we go, but for now let’s start with the big stuff: make a new Swift file called ContentView-ViewModel.swift, then give it an extra import for MapKit. We’re going to use this to create a new class that manages our data, and manipulates it on behalf of the ContentView struct so that our view doesn’t really care how the underlying data system works.


 */

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())
                        
                        Text(location.name)
                            .fixedSize()
                    }
                    .onTapGesture {
                        viewModel.selectedPlace = location
                    }
                }
            }
                .ignoresSafeArea()
            
            Circle()
                .fill(.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        viewModel.addLocation()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
        }
        .sheet(item: $viewModel.selectedPlace) { place in
            EditView(location: place) { newLocation in
                viewModel.update(location: newLocation)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
