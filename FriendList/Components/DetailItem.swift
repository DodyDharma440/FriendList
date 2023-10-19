//
//  DetailItem.swift
//  FriendList
//
//  Created by Dodi Aditya on 17/10/23.
//

import SwiftUI

struct DetailItem<Content: View>: View {
    var label: String
    var value: String = ""
    
    let content: () -> Content
    
    init(label: String, @ViewBuilder content: @escaping () -> Content) {
        self.label = label
        self.content = content
    }
    
    init(label: String, value: String) where Content == EmptyView {
        self.init(label: label) {
            EmptyView()
        }
        self.value = value
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            if !value.isEmpty {
                Text(value)
            } else {
                content()
            }
        } // VStack
    }
}

#Preview {
    DetailItem(label: "Age") {
        Text("Hello")
    }
}
