//
//  FriendListApp.swift
//  FriendList
//
//  Created by Dodi Aditya on 17/10/23.
//

import SwiftUI

@main
struct FriendListApp: App {
    @StateObject var controller = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, controller.container.viewContext)
        }
    }
}
