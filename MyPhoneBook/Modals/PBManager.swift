//
//  PBManager.swift
//  MyPhoneBook
//
//  Created by Navneet Singh (navneet.aug1990@gmail.com) on 3/11/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit
import Contacts
import SVProgressHUD

class PBManager: NSObject {
    
    //Variables
    let contactStore : CNContactStore = CNContactStore()
    var delegate : AddContactDelegate?
    var delegateGroups: AllGroupsDelegate?
    
    
    override init(){
        super.init()
    }
    
    //MARK:- Groups
    func getAllGroups(pred: String,id: String){
        SVProgressHUD.show(withStatus: "Please wait..")
        CoreDataManager.fetchEntityAsynFromDB(ENUMCOREDATA.GROUP.rawValue, "",id: "") { (result) in
            
            var allList: [GroupObj] = []
            for myObj in result{
                let obj = GroupObj.init(myObj as! GROUPENTITY)
                allList.append(obj)
            }
            self.delegateGroups?.didFetchGroups(groups: allList )
            
            
            
        }
    }
    
    //MARK:- Contacts
    func getAllContacts(pred: String,id: String){
        SVProgressHUD.show(withStatus: "Please wait..")
        CoreDataManager.fetchEntityAsynFromDB(ENUMCOREDATA.CONTACT.rawValue, pred,id: id) { (result) in
            
            let items = result as? [CONTACTSENTITY]
            
            if (items?.count)! > 0 {
                var allList: [ContactObj] = []
                for myObj in items!{
                    
                    if let contact = myObj as CONTACTSENTITY?,  pred == ENUMPREDGROUPRELATION.MEMBER.rawValue {
                        if let grp = contact.group{
                            print("Name:\(grp.name!)")
                            continue
                        }
                    }
                    let obj = ContactObj.init(myObj)
                    
                    allList.append(obj)
                }
                self.delegate?.didFetchContacts(contacts: allList)
                
            }
            else{
                self.requestForAccess { (access) in
                    guard access
                        else{
                            self.delegate?.didFetchContacts(contacts: [])
                            return
                    }
                    var results: [CNContact] = []
                    
                    let keys = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactEmailAddressesKey, CNContactPhoneNumbersKey , CNContactBirthdayKey, CNContactImageDataKey] as [Any]
                    // Get all the containers
                    var allContainers: [CNContainer] = []
                    do {
                        allContainers = try self.contactStore.containers(matching: CNContainer.predicateForContainers(withIdentifiers: [self.contactStore.defaultContainerIdentifier()]))
                    } catch {
                        print("Error fetching containers")
                    }
                    
                    // Iterate all containers and append their contacts to our results array
                    var allList :[ContactObj] = []
                    
                    for container in allContainers {
                        let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                        
                        do {
                            let containerResults = try self.contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keys as! [CNKeyDescriptor])
                            results.append(contentsOf: containerResults)
                        } catch {
                            print("Error fetching results for container")
                        }
                    }
                    
                    for myObj in results{
                        let obj = ContactObj.init(myObj)
                        guard obj.name != ""
                            else{
                                continue
                        }
                        allList.append(obj)
                        
                        guard CoreDataManager.coreDataInsertOperationForEntityName(ENUMCOREDATA.CONTACT.rawValue,  obj) == true
                            else{
                                continue
                        }
                    }
                    
                    self.delegate?.didFetchContacts(contacts: allList)
                    
                    
                }
                
            }
        }
        
        
    }
    
    
    func showMessage(message: String) {
        SVProgressHUD.dismiss()
        
        let alertController = UIAlertController(title: "Birthdays", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)
        
        let pushedViewControllers = (PBUtility.getAppDelegate().window?.rootViewController as! UINavigationController).viewControllers
        let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
        
        presentedViewController.present(alertController, animated: true, completion: nil)
    }
}


//MARK:- Fetch COntacts Delegates

extension PBManager{
    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            self.showMessage(message: message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }}
