//
//  UserDetailView.swift
//  FriendList
//
//  Created by Dodi Aditya on 17/10/23.
//

import SwiftUI

struct UserDetailView: View {
    private let coordinateSpaceName = "scroll"
    
    @Environment(\.dismiss) var dismiss
    @FetchRequest var users: FetchedResults<CachedUser>
    
    @State private var isShowMiniHeader = false
    
    init(id: String) {
        _users = FetchRequest<CachedUser>(sortDescriptors: [], predicate: NSPredicate(format: "id == %@", id))
    }
    
    var user: CachedUser? {
        users.first
    }
    
    var body: some View {
        Group {
            if let user = user {
                ZStack(alignment: .top) {
                    VStack(spacing: 0) {
                        ScrollView {
                            VStack {
                                Avatar(
                                    name: user.wrappedName,
                                    size: 120,
                                    color: user.isActive ? .blue : .red
                                )
                                .padding(.top)
                                .font(.system(size: 50, design: .rounded))
                                
                                Text(user.wrappedName)
                                    .multilineTextAlignment(.center)
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                
                                Text(user.wrappedEmail)
                            } // VStack
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 50)
                            .stickyTop { proxy in
                                LinearGradient(
                                    colors: [user.color.opacity(0.6), user.color.opacity(0.3)],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            } // VStack
                            
                            
                            VStack(spacing: 30) {
                                ListGroup {
                                    DetailItem(label: "Age", value: "\(user.age) years old")
                                    Divider()
                                        .padding(.bottom, 6)
                                    DetailItem(label: "Company", value: user.wrappedCompany)
                                } // ListGroup
                                
                                ListGroup {
                                    DetailItem(label: "Address", value: user.wrappedAddress)
                                    Divider()
                                        .padding(.bottom, 6)
                                    DetailItem(label: "About", value: user.wrappedAbout)
                                } // ListGroup
                                
                                ListGroup {
                                    DetailItem(label: "Register at", value: user.formattedDate)
                                    Divider()
                                        .padding(.bottom, 6)
                                    DetailItem(label: "Tags", value: user.displayedTags)
                                } // ListGroup
                                
                                VStack(alignment: .leading) {
                                    Text("\(user.wrappedName)'s Friends")
                                        .padding(.leading)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    
                                    ListGroup {
                                        if !user.wrappedFriends.isEmpty {
                                            ForEach(user.wrappedFriends.indices, id: \.self) { index in
                                                let friend = user.wrappedFriends[index]
                                                let isLast = user.wrappedFriends.count - 1 == index
                                                
                                                NavigationLink {
                                                    UserDetailView(id: friend.wrappedId)
                                                } label: {
                                                    FriendItem(name: friend.wrappedName)
                                                } // NavigationLink
                                                .tint(.primary)
                                                
                                                if !isLast {
                                                    Divider()
                                                        .padding(.bottom, 6)
                                                }
                                            } // Loop
                                        } else {
                                            VStack {
                                                Text("This user doesn't have any friends yet.")
                                                    .font(.caption)
                                                    .padding()
                                                    .foregroundStyle(.secondary)
                                            }
                                            .frame(maxWidth: .infinity)
                                        } // Condition
                                    } // ListGroup
                                } // VStack
                            } // VStack
                            .trackScroll(name: coordinateSpaceName) { value in
                                if value.y < 200 {
                                    withAnimation {
                                        isShowMiniHeader = true
                                    }
                                } else {
                                    withAnimation {
                                        isShowMiniHeader = false
                                    }
                                }
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal)
                        } // Scroll
                        .background(
                            Color(UIColor.secondarySystemBackground)
                        )
                        .coordinateSpace(name: coordinateSpaceName)
                        .ignoresSafeArea(.container, edges: .top)
                    } // VStack
                    .frame(maxHeight: .infinity)
                    
                    VStack(spacing: 0) {
                        HStack(alignment: .top) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.left")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .padding(10)
                                    .foregroundStyle(.white)
                                    .background(.gray.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            .padding(.leading, 20)
                            
                            Spacer()
                            if isShowMiniHeader {
                                Group {
                                    VStack(spacing: 4) {
                                        Avatar(
                                            name: user.wrappedName,
                                            size: 40,
                                            color: user.isActive ? .blue : .red
                                        )
                                        Text(user.wrappedName)
                                            .padding(.bottom)
                                    }
                                    
                                    Spacer()
                                    
                                    Color.clear
                                        .frame(width: 18, height: 18)
                                        .padding(10)
                                        .padding(.trailing, 20)
                                }
                                .transition(.opacity)
                            }
                        } // HStack
                        .frame(height: 80, alignment: .top)
                        .background(isShowMiniHeader ? AnyShapeStyle(.ultraThinMaterial) : AnyShapeStyle(Color.clear))
                        
                        if isShowMiniHeader {
                            Divider()
                        }
                    } // VStack
                } // ZStack
            } else {
                Text("User not found")
                    .foregroundStyle(.secondary)
            } // Condition
        } // Group
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    struct WithDummyData: View {
        @Environment(\.managedObjectContext) var moc
        
        var body: some View {
            UserDetailView(id: "1")
                .onAppear {
                    let newUser = CachedUser(context: moc)
                    
                    newUser.id = "1"
                    newUser.name = "Johhn"
                    newUser.about = "Lorem ipsum"
                    newUser.address = "Lorem address"
                    newUser.age = Int16(10)
                    newUser.company = "Company"
                    newUser.email = "john@gmail.com"
                    newUser.isActive = true
                    newUser.registered = .now
                    newUser.tags = "lorem,ipsum,dolor"
                    
                    for i in 0...3 {
                        let newFriend = CachedFriend(context: moc)
                        newFriend.name = "Friend \(i)"
                        newFriend.id = "Friend_\(i)"
                        newFriend.user = newUser
                    }
                    
                    try? moc.save()
                }
        }
    }
    
    return NavigationStack {
        WithDummyData()
            .mocPreview()
    }
}
