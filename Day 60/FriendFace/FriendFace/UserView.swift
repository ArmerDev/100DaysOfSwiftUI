//
//  UserView.swift
//  FriendFace
//
//  Created by James Armer on 13/06/2023.
//

import SwiftUI

import SwiftUI

struct UserView: View {
    let user: User

    var body: some View {
        List {
            Section {
                Text(user.about)
                    .padding(.vertical)
            } header: {
                Text("About")
            }

            Section {
                Text("Address: \(user.address)")
                Text("Company: \(user.company)")
            } header: {
                Text("Contact details")
            }

            Section {
                ForEach(user.friends) { friend in
                    Text(friend.name)
                }
            } header: {
                Text("Friends")
            }
        }
        .listStyle(.grouped)
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: User.example)
    }
}
