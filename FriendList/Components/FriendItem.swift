//
//  FriendItem.swift
//  FriendList
//
//  Created by Dodi Aditya on 17/10/23.
//

import SwiftUI

struct FriendItem: View {
    var name: String
    var email: String? = nil
    var isActive: Bool? = nil
    
    var avatarColor: Color {
        if let isActive = isActive {
            return isActive ? .blue : .red
        }
        
        return .gray
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Avatar(
                name: name,
                size: 40,
                color: avatarColor
            )
            
            VStack(alignment: .leading) {
                Text(name)
                if let email = email {
                    Text(email)
                        .font(.footnote)
                }
            } // VStack
        } // HStack
    }
}

#Preview {
    FriendItem(name: "John", email: "John@gmail.com", isActive: false)
}
