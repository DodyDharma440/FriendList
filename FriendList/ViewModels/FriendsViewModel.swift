//
//  FriendsViewModel.swift
//  FriendList
//
//  Created by Dodi Aditya on 17/10/23.
//

import Foundation
import SwiftUI

@MainActor class FriendsViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var errMessage: String? = nil
    
    func groupByFirstLetter(_ users: FetchedResults<CachedUser>) -> [String: [CachedUser]] {
        Dictionary(grouping: users) { user in
            String(user.wrappedName.prefix(1))
        }
    }
    
    func isLoaded() {
        isLoading = false
        errMessage = nil
    }
    
    func loadUsers() async -> [User] {
        errMessage = nil
        isLoading = true
        
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            fatalError("Invalid URL")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decoded = try decoder.decode([User].self, from: data)
            isLoading = false
            return decoded
        } catch {
            errMessage = error.localizedDescription
            isLoading = false
            return []
        }
    }
}
