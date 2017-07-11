//
//  PBUtility.swift
//  MyPhoneBook
//
//  Created by Navneet Singh (navneet.aug1990@gmail.com) on 3/11/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD

class PBUtility {

    
    class func getAppDelegate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    class func showAlertMsg(title:String,description:String,vc:UIViewController,_ goDetail : Bool){
        DispatchQueue.main.async(execute: { () -> Void in
            
            let alert : UIAlertController
                = UIAlertController(title:title , message: description, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title:"ok", style: UIAlertActionStyle.default, handler: { alertAction in
                if vc is PBGroupListController && goDetail == true {
                    let gVC = vc as? PBGroupListController
                    
                    let vc = gVC?.storyboard?.instantiateViewController(withIdentifier: ENUMSEGUE.GROUPDETAIL.rawValue) as! PBGroupDetailListController
                    vc.isForAddingNew = true
                    vc.isFreshList = true
                    vc.grp = gVC?.arrayGroups.last!
                    vc.arrayContacts = (gVC?.arrayGroups.last?.contacts)!
                    vc.title = "Select Contacts"
                    let navBar = UINavigationController.init(rootViewController: vc)
                    gVC?.present(navBar, animated: true, completion: nil)
                    
                }
                else{
                alert.dismiss(animated: true, completion:nil)
                }
            }))
            vc.present(alert, animated: true, completion: nil)
            
        })
        
        
    }
    class func initialiseKeyboardManager(){
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField  = 20.0
        
        SVProgressHUD.setDefaultMaskType(.black)
    }
}

