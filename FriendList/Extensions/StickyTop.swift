//
//  StickyTop.swift
//  FriendList
//
//  Created by Dodi Aditya on 20/10/23.
//

import SwiftUI

struct StickyTopModifier<Children: View>: ViewModifier {
    @ViewBuilder var children: (GeometryProxy) -> Children
    
    @State private var containerHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .background(
                    GeometryReader { bgProxy in
                        children(bgProxy)
                            .onAppear {
                                containerHeight = bgProxy.size.height
                            }
                    }
                )
                .offset(y: proxy.frame(in: .global).minY > 0 ? -proxy.frame(in: .global).minY : 0)
        } // GeometryReader
        .frame(height: containerHeight)
    }
}

extension View {
    func stickyTop<Children: View>(
        @ViewBuilder children: @escaping (GeometryProxy) -> Children = { proxy in Color.clear }
    ) -> some View {
        modifier(StickyTopModifier(children: children))
    }
}
