//
//  CachedUser+CoreDataProperties.swift
//  FriendList
//
//  Created by Dodi Aditya on 18/10/23.
//
//

import Foundation
import CoreData


extension CachedUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedUser> {
        return NSFetchRequest<CachedUser>(entityName: "CachedUser")
    }

    @NSManaged public var id: String? 
    @NSManaged public var name: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var about: String?
    @NSManaged public var address: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var registered: Date?
    @NSManaged public var tags: String?
    @NSManaged public var friends: NSSet?
    
    var wrappedId: String {
        id ?? ""
    }
    
    var wrappedName: String {
        name ?? "Anonymous"
    }
    
    var wrappedAbout: String {
        about ?? "-"
    }

    var wrappedAddress: String {
        address ?? "-"
    }
    
    var wrappedCompany: String {
        company ?? "-"
    }
    
    var wrappedEmail: String {
        email ?? "Unknown email"
    }
    
    var wrappedRegistered: Date {
        registered ?? .now
    }
    
    var wrappedTags: [String] {
        tags?.components(separatedBy: ",") ?? []
    }
    
    var wrappedFriends: [CachedFriend] {
        let set = friends as? Set<CachedFriend> ?? []
        return Array(set)
    }
}

// MARK: Generated accessors for friends
extension CachedUser {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: CachedFriend)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: CachedFriend)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension CachedUser : Identifiable {

}
