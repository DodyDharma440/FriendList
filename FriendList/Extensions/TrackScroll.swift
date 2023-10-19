//
//  TrackScroll.swift
//  FriendList
//
//  Created by Dodi Aditya on 20/10/23.
//

import SwiftUI

struct ScrollViewPreference: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

struct TrackScrollModifier: ViewModifier {
    var name: String
    var onChange: (CGPoint) -> Void
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: ScrollViewPreference.self, value: proxy.frame(in: .named(name)).origin)
                }
            )
            .onPreferenceChange(ScrollViewPreference.self) { value in
                onChange(value)
            }
    }
}

extension View {
    func trackScroll(name: String, onChange: @escaping (CGPoint) -> Void) -> some View {
        modifier(TrackScrollModifier(name: name, onChange: onChange))
    }
}
