//
//  GROUPENTITY+CoreDataProperties.swift
//  MyPhoneBook
//
//  Created by Navneet Singh (navneet.aug1990@gmail.com) on 3/14/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import Foundation
import CoreData


extension GROUPENTITY {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GROUPENTITY> {
        return NSFetchRequest<GROUPENTITY>(entityName: "GROUPENTITY");
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var member: NSSet?

}

// MARK: Generated accessors for member
extension GROUPENTITY {

    @objc(addMemberObject:)
    @NSManaged public func addToMember(_ value: CONTACTSENTITY)

    @objc(removeMemberObject:)
    @NSManaged public func removeFromMember(_ value: CONTACTSENTITY)

    @objc(addMember:)
    @NSManaged public func addToMember(_ values: NSSet)

    @objc(removeMember:)
    @NSManaged public func removeFromMember(_ values: NSSet)

}
