//
//  ListGroup.swift
//  FriendList
//
//  Created by Dodi Aditya on 18/10/23.
//

import SwiftUI

struct ListGroup<Content: View>: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            content()
        }
        .padding(.horizontal, 20)
        .padding(.vertical)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ListGroup {
        DetailItem(label: "Name", value: "John")
    }
}
