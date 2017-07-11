//
//  PBGroupListController.swift
//  MyPhoneBook
//
//  Created by iTexico on 3/13/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit
import SVProgressHUD

class PBGroupListController: UIViewController {

    //MARK:- IBOutlets
    
    @IBOutlet weak var barBtnAdd: UIBarButtonItem!
    @IBOutlet weak var tableViewGroupList: UITableView!
    
    //MARK:- properties
    var delegate : AllGroupsDelegate?
    
    var arrayGroups : [GroupObj] = []
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableViewGroupList.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier ==  ENUMSEGUE.GROUPDETAIL.rawValue &&  sender is NSIndexPath{
            
            let vc = segue.destination as? PBGroupDetailListController
            vc?.arrayAllContacts = arrayGroups[(sender as! IndexPath).row].contacts
            vc?.title = arrayGroups[(sender as! IndexPath).row].name
            vc?.isForAddingNew = false
            vc?.grp = arrayGroups[(sender as! IndexPath).row]
        }
    }
    
    @IBAction   func unwindToGroupList(_ segue: UIStoryboardSegue){
        let vc = segue.source as? PBGroupDetailListController
        let obj = arrayGroups.last
        obj?.contacts.removeAll()
        obj?.contacts.append(contentsOf: vc!.arrayContacts)
        tableViewGroupList.reloadData()
        
    }
   
    
    //MARK:- Other Methods
    
    func customizeUI(){
        let manager = PBManager.init()
        manager.delegateGroups = self
        manager.getAllGroups(pred: "", id: "")
        
    }
}


//MARK:- IBACtions
extension PBGroupListController{
    @IBAction func addNewGroupAction(_ sender: Any) {
        let alertController = UIAlertController(title: "New Group", message: "Please enter group name:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields![0] as UITextField?, (field.text!.characters.count) > 0  {
                
                guard   self.arrayGroups.contains(where: ({$0.name == field.text})) == false
                    else{
                        PBUtility.showAlertMsg(title: "Duplicate", description: "Please select another name", vc: self,false)
                        
                 return
                }
                
                let groupObj = GroupObj.init(field.text!,[],"")
                self.arrayGroups.append(groupObj)
           guard     CoreDataManager.coreDataInsertOperationForEntityName(ENUMCOREDATA.GROUP.rawValue, groupObj)
            else{
                print("Failed")
                return
                }
                // store your data
                PBUtility.showAlertMsg(title: "", description: "Please select contacts to add in your group", vc: self,true)
                
                
            } else {
                // user did not fill field
                PBUtility.showAlertMsg(title: "Invalid", description: "Please enter valid name", vc: self,false)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "enter group name"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}


//MARK:- UITableView DatasourceMethods
extension PBGroupListController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayGroups.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ENUMTABLECELL.CONTACTLIST.rawValue)! as UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        let obj = arrayGroups[indexPath.row]
        cell.textLabel?.text = obj.name
        cell.detailTextLabel?.text = "\(obj.contacts.count) members"
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete  {
            guard  CoreDataManager.deleteEntityFromDB(ENUMCOREDATA.GROUP.rawValue, arrayGroups[indexPath.row].id) == true
                else {
                PBUtility.showAlertMsg(title: "FAILED", description: "Failed to delete group from DB", vc: self, false)
                    return
            }
            arrayGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
//MARK:- UITableView Delegate methods
extension PBGroupListController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: ENUMSEGUE.GROUPDETAIL.rawValue, sender: indexPath)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

//MARK:- Fetch COntacts Delegates
extension PBGroupListController : AllGroupsDelegate{
    
    func didFetchGroups(groups: [GroupObj]) {
        arrayGroups.removeAll()
        arrayGroups.append(contentsOf: groups)
        DispatchQueue.main.async(execute: { () -> Void in
            SVProgressHUD.dismiss()
            self.tableViewGroupList.reloadData()
        })
    }
}
