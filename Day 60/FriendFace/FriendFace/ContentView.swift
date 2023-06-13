//
//  ContentView.swift
//  FriendFace
//
//  Created by James Armer on 13/06/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var users = [User]()
    var body: some View {
        NavigationView {
            List(users) { user in
                NavigationLink {
                    UserView(user: user)
                } label: {
                    HStack {
                        Circle()
                            .foregroundColor(user.isActive ? .green : .orange)
                            .frame(width: 30)
                        
                        Text(user.name)
                    }
                }
            }
            .navigationTitle("FriendFace")
            .task {
                await fetchData()
            }
        }
    }
    
    func fetchData() async {
        guard users.isEmpty else { return }
        
        do {
            let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            users = try decoder.decode([User].self, from: data)
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
