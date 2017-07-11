//
//  CustomObjects.swift
//  MyPhoneBook
//
//  Created by iTexico on 3/12/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import Foundation
import Contacts


class ContactObj: NSObject, NSCopying {
    var email: String?
    var birthday: String?
    var photoData : NSData?
    var number: String?
    var name : String?
    var id: String?
    var creationDate : NSDate?
    
    init(_ email : String, _ birthday: String,_ photoData: NSData,_ number:String,_ name:String, id:String,_ creationDate: NSDate) {
        self.email = email
        self.birthday = birthday
        self.photoData = photoData
        self.number = number
        self.name = name
        self.id = id
        self.creationDate = creationDate
    }
    
        @objc(:)
    convenience  init(_ contacts: CONTACTSENTITY){
        
        self.init("","",NSData(),"","",id: contacts.objectID.uriRepresentation().absoluteString,NSDate())
        
            

        if contacts.birthday != nil {
            self.birthday = contacts.birthday!
        }
        if contacts.email != nil {
            self.email = contacts.email!
        }
        if contacts.imageData != nil {
            self.photoData = contacts.imageData!
        }
        if contacts.number != nil {
            self.number = contacts.number!
        }
        if contacts.name != nil {
            self.name = contacts.name!
        }
        
        if contacts.creationDate != nil {
            self.creationDate = contacts.creationDate!
            
        }
        
    }

    
    convenience  init(_ contact: CNContact) {
        
        self.init("","",NSData(),"","",id:"",NSDate())
        email = self.convertCNContact(contact, CNContactEmailAddressesKey) as? String
        birthday = self.convertCNContact(contact, CNContactBirthdayKey) as? String
        number = self.convertCNContact(contact, CNContactPhoneNumbersKey) as? String
        photoData = self.convertCNContact(contact, CNContactImageDataKey) as? Data as NSData?
        name = self.convertCNContact(contact, CNContactGivenNameKey) as? String
        
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(email, forKey: "email")
        aCoder.encode(birthday, forKey: "birthday")
        aCoder.encode(number, forKey: "number")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(creationDate, forKey: "creationDate")
        aCoder.encode(photoData, forKey: "photoData")
    }
    
    required   convenience init(coder aDecoder: NSCoder) {
        
        let email = aDecoder.decodeObject(forKey:"email")    as? String
        let birthday = aDecoder.decodeObject(forKey:"birthday")    as? String
        let number = aDecoder.decodeObject(forKey:"number")    as? String
        let name = aDecoder.decodeObject(forKey:"name")    as? String
        let id = aDecoder.decodeObject(forKey:"id")    as? String
        let creationDate = aDecoder.decodeObject(forKey:"creationDate") as? NSDate
        let photoData = aDecoder.decodeObject(forKey:"photoData") as? NSData
        
        self.init(email!,birthday!,photoData!, number!, name!,id:id!, creationDate!)
        
    }
    
    func copy(with zone:NSZone?) -> Any {
        if photoData == nil {
            photoData = NSData()
        }
        let copy = ContactObj.init(email!, birthday!, photoData!, number!, name!, id:id!, creationDate!)
        
        return copy
        
    }
    
    //MARK:- Private methods
    private func convertCNContact(_ contact: CNContact, _ key: String)-> Any{
        
        if key == CNContactBirthdayKey{
            guard let dateComp =  contact.birthday
                else {
                    return ""
            }
            
            let dated = Calendar.current.date(from: dateComp)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "dd/MM/yyyy"     //DateFormatter.Style.medium
            let dateString = dateFormatter.string(from: dated!)
            
            
            return dateString
        }
        else  if key != CNContactPhoneNumbersKey && key != CNContactEmailAddressesKey{
            guard let id =  contact.value(forKey: key)
                else {
                    return  ""
            }
            return id
        }
        else{
            guard let value = key != CNContactPhoneNumbersKey ? contact.emailAddresses.last?.value as String?  : contact.phoneNumbers.last?.value.stringValue
                else {
                    return ""
            }
            return value
        }
        
    }
}
