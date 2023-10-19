//
//  Avatar.swift
//  FriendList
//
//  Created by Dodi Aditya on 17/10/23.
//

import SwiftUI

struct Avatar: View {
    var name: String
    var size: Double = 50
    var color: Color = .blue
    
    var avatarText: String {
        let splittedName = name.components(separatedBy: " ")
        var label = ""
        
        for i in 0..<splittedName.count {
            if  i <= 1 {
                let char = splittedName[i].first?.description ?? ""
                label += char
            } else {
                break
            }
        }
        
        return label.uppercased()
    }
    
    var body: some View {
        Text(avatarText)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(4)
            .frame(width: size, height: size)
            .background(color)
            .clipShape(Circle())
    }
}

#Preview {
    Avatar(name: "John")
        .previewLayout(.sizeThatFits)
}
