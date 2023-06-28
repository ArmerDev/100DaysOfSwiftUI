//
//  ContentView.swift
//  TimeForMapKit
//
//  Created by James Armer on 28/06/2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var inputImage: UIImage?
    @State private var name: String = ""
    @State private var showingImagePicker = false
    @State private var showingNameInputField = false
    @State private var people: [Person] = []
    
    let locationFetcher = LocationFetcher()
    
    var sortedPeople: [Person] {
        people.sorted { $0.name < $1.name }
    }
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPeople")
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedPeople) { person in
                    
                    NavigationLink {
                        DetailView(name: person.name, picture: person.picture, latitude: person.latitude, longitude: person.longitude)
                    } label: {
                        HStack {
                            Image(uiImage: UIImage(data: person.picture)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                            
                            Text(person.name)
                        }
                    }
                }
                .onDelete(perform: removeRows)
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
                        addPerson()
                    }
                }
            }
            .onAppear {
                load()
                self.locationFetcher.start()
            }
        }
    }
    
    func addPerson() {
        if let location = self.locationFetcher.lastKnownLocation {
            print("\(location)")
            people.append(Person(name: name, picture: inputImage!, latitude: location.latitude, longitude: location.longitude))
            name = ""
            save()
        }
    }
    
    func load() {
        do {
            let data = try Data(contentsOf: savePath)
            people = try JSONDecoder().decode([Person].self, from: data)
        } catch {
            people = []
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        people = people.sorted { $0.name < $1.name }
        people.remove(atOffsets: offsets)
        save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
