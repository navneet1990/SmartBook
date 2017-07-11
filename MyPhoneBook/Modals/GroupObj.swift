//
//  GroupObj.swift
//  MyPhoneBook
//
//  Created by Navneet Singh (navneet.aug1990@gmail.com) on 3/13/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import Foundation

class GroupObj : NSObject, NSCopying{
    var name: String
    var contacts: [ContactObj]
    var id: String
    
    init(_ name: String,_ contacts:[ContactObj],_ id : String) {
        
        self.name  = name
        self.contacts = contacts
        self.id = id
    }
    
    convenience  init(_ group: GROUPENTITY){
        
        self.init("",[],"")
        
        
        self.id = group.objectID.uriRepresentation().absoluteString
        if let members = group.member as? Set<CONTACTSENTITY> {
            
            var seq : Set<ContactObj> = Set<ContactObj>()
            for obj in members{
                seq.insert(ContactObj.init(obj))
            }
            self.contacts.append(contentsOf: seq)
        }
        if group.name != nil {
            self.name = group.name!
        }
           }

    func encode(with aCoder: NSCoder){

        aCoder.encode(name, forKey: "name")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(contacts, forKey: "contacts")
    }
    
    required   convenience init(coder aDecoder: NSCoder) {
        
        let name = aDecoder.decodeObject(forKey:"name")    as? String
        let id = aDecoder.decodeObject(forKey:"id")    as? String
        let contacts = aDecoder.decodeObject(forKey:"contacts") as? [ContactObj]
      
        self.init(name!,contacts!,id!)
    }
    
    func copy(with zone:NSZone?) -> Any {
        let copy = GroupObj.init(name,contacts,id)
        
        return copy
        
    }

}
