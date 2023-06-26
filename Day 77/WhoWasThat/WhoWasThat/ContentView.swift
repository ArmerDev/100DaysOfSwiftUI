//
//  ContentView.swift
//  WhoWasThat
//
//  Created by James Armer on 26/06/2023.
//

import SwiftUI

// TODO: Add Saving 

struct ContentView: View {
    
    @State private var inputImage: UIImage?
    @State private var name: String = ""
    @State private var showingImagePicker = false
    @State private var showingNameInputField = false
    @State private var people: [Person] = []
    
    var sortedPeople: [Person] {
        people.sorted { $0.name < $1.name }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedPeople) { person in
                    
                    NavigationLink {
                        Image(uiImage: person.picture!)
                            .resizable()
                            .scaledToFit()
                            .navigationTitle(person.name)
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        HStack {
                            Image(uiImage: person.picture!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                            
                            Text(person.name)
                        }
                    }

                    
                }
            }
            .navigationTitle("Who was that?")
            .toolbar {
                Button("Add Person") {
                    showingImagePicker = true
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) { _ in
                showingNameInputField = true
            }
            .alert("Enter the person's name", isPresented: $showingNameInputField) {
                TextField("Person's name", text: $name)
                Button("Save") {
                    withAnimation {
                        people.append(Person(name: name, picture: inputImage))
                        name = ""
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
