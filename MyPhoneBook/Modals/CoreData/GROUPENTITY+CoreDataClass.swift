//
//  GROUPENTITY+CoreDataClass.swift
//  MyPhoneBook
//
//  Created by iTexico on 3/14/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import Foundation
import CoreData

@objc(GROUPENTITY)
public class GROUPENTITY: NSManagedObject {

    class func createInManagedObjectContext(moc: NSManagedObjectContext, dataObject: GroupObj) -> Bool {
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: ENUMCOREDATA.GROUP.rawValue, into: moc) as! GROUPENTITY
        
        convertTheValues(newItem, dataObject)
        var save: Bool
        do {
            try moc.save()
            save = true
        } catch let error1 as NSError {
            print("Error:\(error1.description)")
            save = false
        }
        dataObject.id =       newItem.objectID.uriRepresentation().absoluteString
        
        return save
    }
    class func convertTheValues(_ newItem: GROUPENTITY, _ dataObject: GroupObj){
        newItem.name = dataObject.name
        for obj in dataObject.contacts {
            let mo =   CoreDataManager.getById(obj.id!) as? CONTACTSENTITY
            guard newItem.member?.contains(mo!) == false
                else{
                    continue
            }
            newItem.addToMember(mo!)

        }
        
        
        }
}

