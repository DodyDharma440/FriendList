//
//  CachedFriend+CoreDataProperties.swift
//  FriendList
//
//  Created by Dodi Aditya on 18/10/23.
//
//

import Foundation
import CoreData


extension CachedFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedFriend> {
        return NSFetchRequest<CachedFriend>(entityName: "CachedFriend")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var user: CachedUser?

    var wrappedId: String {
        id ?? ""
    }
    
    var wrappedName: String {
        name ?? "Anonymous"
    }
}

extension CachedFriend : Identifiable {

}
