//
//  COREDATAENTITYEXT.swift
//  MyPhoneBook
//
//  Created by Navneet Singh (navneet.aug1990@gmail.com) on 3/13/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SVProgressHUD

class CoreDataManager: NSObject {
    
    static let moc: NSManagedObjectContext = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
    
    //MARK:- Insert
    class func coreDataInsertOperationForEntityName(_ entity:String,_ dataObject: AnyObject)-> Bool{
        
        var saved = false
        
        if entity == ENUMCOREDATA.CONTACT.rawValue{
            let obj = dataObject as! ContactObj
            
            saved = CONTACTSENTITY.createInManagedObjectContext(moc: moc, dataObject: obj)
        }
        if entity == ENUMCOREDATA.GROUP.rawValue{
            let obj = dataObject as! GroupObj
            
            saved = GROUPENTITY.createInManagedObjectContext(moc: moc, dataObject: obj)
        }
        
        return saved
    }
    
    
    //MARK:- Fetch
    class func fetchEntityAsynFromDB( _ entityName: String,_ forPred: String, id: String,completion:@escaping (_ result:[AnyObject])->Void){
        //2
        SVProgressHUD.show(withStatus: "Please wait...")
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        //3
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (asynchronousFetchResult) -> Void in
            var items: [AnyObject]? = []
            if asynchronousFetchResult.finalResult!.count > 0 {
                // do here what you want with the data
                
                for mo in asynchronousFetchResult.finalResult! {
                    
                    let objd = mo
                    
                 items?.append(objd)
                }
                SVProgressHUD.dismiss()
            }
            completion(items!)
            
        }
        
        do {
            // Execute Asynchronous Fetch Request
            let asynchronousFetchResult = try moc.execute(asynchronousFetchRequest)
            
            print(asynchronousFetchResult)
            
        } catch {
            let fetchError = error as NSError
            SVProgressHUD.dismiss()
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        
    }
    class func getById(_ id: String) -> AnyObject? {
        let moID : URL = URL.init(string: id)!
        return moc.object(with: (moc.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: moID))!)
    }
    
    //MARK:- Update
    class func updateEntityUsingBatchRequest (_ entityName: String, _ item: AnyObject)->Bool{
        SVProgressHUD.show(withStatus: "Please wait...")
        
        if entityName == ENUMCOREDATA.CONTACT.rawValue {
            
            let obj = item as? ContactObj
            let fetchObj = getById((obj?.id)!) as? CONTACTSENTITY
            
            CONTACTSENTITY.convertTheValues(fetchObj!, obj!)
        }
        else{
            let obj = item as? GroupObj
            let fetchObj = getById((obj?.id)!) as? GROUPENTITY
            GROUPENTITY.convertTheValues(fetchObj!, obj!)
        }
        
        return saveDatabase()
        
        
    }
    class func saveDatabase()-> Bool{
        var save: Bool
        do {
            try moc.save()
            save = true
        } catch let error1 as NSError {
            print("Error:\(error1.description)")
            save = false
        }
        SVProgressHUD.dismiss()
        return save
    }
    //MARK:- Delete enityt methods
    //When you want to delete whole entity or group
    class func deleteEntityFromDB(_ entityName : String, _ moID: String)-> Bool{
        var fetchObj: NSManagedObject?
        if entityName == ENUMCOREDATA.CONTACT.rawValue {
            
            fetchObj = getById(moID) as? CONTACTSENTITY
        }
        else{
            fetchObj = getById(moID) as? GROUPENTITY
            
        }
        moc.delete(fetchObj!)
        return saveDatabase()
        
    }
    
    //When you want to delete member from group
    
    class func deleteMemberFromGroup(_ groupID: String,memberId:String)->Bool{
        
        let group = getById(groupID) as? GROUPENTITY
        let member = getById(memberId) as? CONTACTSENTITY
        guard group?.member?.contains(member!) == true
            else {
                return true
        }
        group?.removeFromMember(member!)
        return saveDatabase()
        
    }
}
