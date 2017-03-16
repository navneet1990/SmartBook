//
//  CONTACTSENTITY+CoreDataProperties.swift
//  MyPhoneBook
//
//  Created by iTexico on 3/14/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import Foundation
import CoreData


extension CONTACTSENTITY {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CONTACTSENTITY> {
        return NSFetchRequest<CONTACTSENTITY>(entityName: "CONTACTSENTITY");
    }

    @NSManaged public var birthday: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var email: String?
    @NSManaged public var id: Int16
    @NSManaged public var imageData: NSData?
    @NSManaged public var name: String?
    @NSManaged public var number: String?
    @NSManaged public var group: GROUPENTITY?

}
