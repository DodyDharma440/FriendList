//
//  DataController.swift
//  FriendList
//
//  Created by Dodi Aditya on 18/10/23.
//

import CoreData
import SwiftUI

struct MocPreview: ViewModifier {
    func body(content: Content) -> some View {
        content
            .environment(\.managedObjectContext, DataController().container.viewContext)
    }
}

extension View {
    func mocPreview() -> some View {
        modifier(MocPreview())
    }
}

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "FriendList")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load core data: \(error)")
            }
        }
        
//        self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}
