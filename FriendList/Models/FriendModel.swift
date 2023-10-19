//
//  FriendModel.swift
//  FriendList
//
//  Created by Dodi Aditya on 17/10/23.
//

import Foundation

struct Friend: Decodable, Identifiable {
    let id: String
    let name: String
}

struct User: Decodable, Identifiable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    
    let tags: [String]
    let friends: [Friend]
}
