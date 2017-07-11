//
//  CONTACTSENTITY+CoreDataClass.swift
//  MyPhoneBook
//
//  Created by Navneet Singh (navneet.aug1990@gmail.com) on 3/14/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import Foundation
import CoreData

@objc(CONTACTSENTITY)
public class CONTACTSENTITY: NSManagedObject {

    class func createInManagedObjectContext(moc: NSManagedObjectContext, dataObject: ContactObj) -> Bool {
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: ENUMCOREDATA.CONTACT.rawValue, into: moc) as! CONTACTSENTITY
        
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
    class func convertTheValues(_ newItem: CONTACTSENTITY, _ dataObject: ContactObj){
        if let date = dataObject.birthday {
            newItem.birthday = date
        }
        newItem.creationDate = NSDate()
        if let email = dataObject.email {
            newItem.email = email
        }
        if let img = dataObject.photoData {
            
            newItem.imageData = img
        }
        if let name = dataObject.name {
            newItem.name = name
        }
        newItem.number = dataObject.number!
        
        
    }
}
