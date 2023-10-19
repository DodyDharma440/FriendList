//
//  FriendsView.swift
//  FriendList
//
//  Created by Dodi Aditya on 17/10/23.
//

import SwiftUI
import CoreData

struct FriendsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var cachedUsers: FetchedResults<CachedUser>
    
    @StateObject var friendsVm = FriendsViewModel()
    @State private var searchValue = ""
    
    var groupedUsers: [String: [CachedUser]] {
        friendsVm.groupByFirstLetter(cachedUsers)
    }
    
    var body: some View {
        NavigationView {
            List {
                if friendsVm.isLoading {
                    ProgressView()
                        .padding()
                        .frame(maxWidth: .infinity)
                } else if let errMessage = friendsVm.errMessage {
                    Text(errMessage)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(Array(groupedUsers.keys).sorted(by: <), id: \.self) { k in
                        if let users = groupedUsers[k] {
                            Section(k) {
                                ForEach(users) { user in
                                    NavigationLink {
                                        UserDetailView(id: user.wrappedId)
                                    } label: {
                                        FriendItem(name: user.wrappedName, email: user.wrappedEmail, isActive: user.isActive)
                                    } // NavigationLink
                                } // Loop
                            } // Section
                        } else {
                            EmptyView()
                        }
                    } // Loop
                } // Condition
            } // List
            .navigationTitle("Friend List")
            .searchable(text: $searchValue)
            .refreshable {
                Task {
                    await loadAndPersist()
                }
            }
            .onChange(of: searchValue) { _, newValue in
                if !newValue.isEmpty {
                    cachedUsers.nsPredicate = NSPredicate(format: "name CONTAINS[c] %@", newValue)
                } else {
                    cachedUsers.nsPredicate = nil
                }
            }
//            .toolbar {
//                Button("Reload") {
//                    Task {
//                        await loadAndPersist()
//                        print(friendsVm.users)
//                    }
//                }
//                
//                Button("Clear") {
//                    for user in cachedUsers {
//                        moc.delete(user)
//                    }
//                    
//                    try? moc.save()
//                }
//            }
        } // Navigation
        .environmentObject(friendsVm)
        .task {
            if cachedUsers.isEmpty {
                await loadAndPersist()
            } else {
                friendsVm.isLoaded()
            }
        }
    }
    
    func itemExist(_ id: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedUser")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let count = (try? moc.count(for: fetchRequest)) ?? 0
        return count > 0
    }
    
    func loadAndPersist() async {
        let users = await friendsVm.loadUsers()
        
        await MainActor.run {
            for user in users {
                if !itemExist(user.id) {
                    let newUser = CachedUser(context: moc)
                    
                    newUser.id = user.id
                    newUser.name = user.name
                    newUser.about = user.about
                    newUser.address = user.address
                    newUser.age = Int16(user.age)
                    newUser.company = user.company
                    newUser.email = user.email
                    newUser.isActive = user.isActive
                    newUser.registered = user.registered
                    newUser.tags = user.tags.joined(separator: ",")
                    
                    for friend in user.friends {
                        let newFriend = CachedFriend(context: moc)
                        newFriend.name = friend.name
                        newFriend.id = friend.id
                        newFriend.user = newUser
                    }
                }
                
                if moc.hasChanges {
                    try? moc.save()
                }
            }
        }
    }
}

#Preview {
    FriendsView()
        .mocPreview()
}
