//
//  PBGroupDetailListController.swift
//  MyPhoneBook
//
//  Created by iTexico on 3/13/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit

class PBGroupDetailListController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var labelAddMore: UILabel!
    @IBOutlet weak var tableViewContacts: UITableView!
    @IBOutlet weak var barBtnAddContact: UIBarButtonItem!
    @IBOutlet weak var barBtnCancel: UIBarButtonItem!
    @IBOutlet weak var barBtnCreateGrp: UIBarButtonItem!
    
    //MARK:- Properties
    var arrayAllContacts: [ContactObj] = []
    var arrayContacts : [ContactObj] = []
    var grp: GroupObj?
    var isForAddingNew = false
    var isFreshList = false
    var delegate : AddContactDelegate?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        customizeUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Customize UI
    func customizeUI(){
    
        guard isForAddingNew else {
            
            return
        }
        labelAddMore.frame.size = CGSize.init(width: 0, height: 0)
        tableViewContacts.frame.origin.y = labelAddMore.frame.origin.y
        labelAddMore.text = ""
        let manager = PBManager.init()
        manager.delegate = self
        manager.getAllContacts(pred: ENUMPREDGROUPRELATION.MEMBER.rawValue, id: grp!.id)
        navigationItem.rightBarButtonItem = barBtnCreateGrp
        navigationItem.leftBarButtonItem = barBtnCancel
        barBtnCreateGrp.isEnabled = arrayContacts.count > 0 ? true : false
        tableViewContacts.allowsMultipleSelection = true
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == ENUMSEGUE.CONTACTDETAIL.rawValue {
            let vc = segue.destination as? PBContactDetailController
            let obj = arrayAllContacts[(sender as! IndexPath).row]
            vc?.intergerRow = (sender as! IndexPath).row
            vc?.contactObj = obj
            vc?.boolAddNew = false
            
        }
     }
    
 
    @IBAction   func unwindGroupListDetail(_ segue: UIStoryboardSegue){
        let vc = segue.source as? PBGroupDetailListController
        arrayAllContacts.removeAll()
        arrayAllContacts = (vc?.arrayContacts)!//.append(contentsOf: vc?.arrayContacts)
        tableViewContacts.reloadData()
        
    }
    @IBAction   func unwindGroupListContactDetail(_ segue: UIStoryboardSegue){
        let vc = segue.source as? PBContactDetailController
        let obj = vc?.contactObj
//        arrayAllContacts.remove(at: (vc?.intergerRow)!)
        arrayAllContacts[(vc?.intergerRow!)!] = obj!
        tableViewContacts.reloadData()
        
    }
    
    
    
}

//MARK:- IBActions

extension PBGroupDetailListController{
    
    @IBAction func createGrpAction(_ sender: Any) {
        grp?.contacts = arrayContacts
        
        if isFreshList {
            guard  CoreDataManager.updateEntityUsingBatchRequest(ENUMCOREDATA.GROUP.rawValue, grp!)
                else{
                    print("failed by updating")
                    return
            }
            performSegue(withIdentifier: ENUMSEGUEUNWIND.GROUPLIST.rawValue, sender: self)
            
        }
        else{
            guard  CoreDataManager.updateEntityUsingBatchRequest(ENUMCOREDATA.GROUP.rawValue, grp!)
                else{
                    print("failed by updating")
                    return
            }
            performSegue(withIdentifier: ENUMSEGUEUNWIND.GROUPLISTDETAIL.rawValue, sender: self)
            
        }
        
        
    }
    @IBAction func cancelBarBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addNewContactAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ENUMSEGUE.GROUPDETAIL.rawValue) as! PBGroupDetailListController
        vc.isForAddingNew = true
        vc.arrayContacts = arrayAllContacts
        vc.grp = grp
        vc.title = navigationItem.title
        let navBar = UINavigationController.init(rootViewController: vc)
        present(navBar, animated: true, completion: nil)
        
    }
    
}



//MARK:- UITableView DatasourceMethods
extension PBGroupDetailListController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAllContacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ENUMTABLECELL.CONTACTLIST.rawValue)! as UITableViewCell
        
        cell.textLabel?.text = arrayAllContacts[indexPath.row].name!
        
        guard isForAddingNew == true &&   arrayContacts.contains(where: { $0.id == arrayAllContacts[indexPath.row].id })
            else{
                cell.accessoryType = .none
                return cell
        }
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        cell.accessoryType = .checkmark
        
        return cell
    }
}

//MARK:- UITableView Delegate Methods
extension PBGroupDetailListController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isForAddingNew == false{
            
                        performSegue(withIdentifier: ENUMSEGUE.CONTACTDETAIL.rawValue, sender: indexPath)
        }
        else{
            
            
            guard tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.none else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                let obj = arrayAllContacts[indexPath.row]
                guard  let index : NSInteger = arrayContacts.index(where: { $0.id == obj.id })
                    else{
                        return
                }
                arrayContacts.remove(at: index)
                barBtnCreateGrp.isEnabled = arrayContacts.count > 0
                
                return
            }
            arrayContacts.append(arrayAllContacts[indexPath.row])
            barBtnCreateGrp.isEnabled = arrayContacts.count > 0
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete && isForAddingNew == false {
            guard   CoreDataManager.deleteMemberFromGroup((grp?.id)!, memberId: arrayAllContacts[indexPath.row].id!) == true
                else{
                    PBUtility.showAlertMsg(title: "FAILED", description: "Failed to delete contact from this group", vc: self, false)
                    return
            }
            arrayAllContacts.remove(at: indexPath.row)
            grp!.contacts = arrayAllContacts
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


//MARK:- Fetch COntacts Delegates
extension PBGroupDetailListController : AddContactDelegate{
    
    func didFetchContacts(contacts: [ContactObj]) {
        
        if contacts.count < 1{
            DispatchQueue.main.async(execute: { () -> Void in
                PBUtility.showAlertMsg(title: "No Contacts", description: "You dont have contacts to add in group.. Please create new contacts", vc: self, false)
                
            self.dismiss(animated: true, completion: nil)
            })
        }
        else{        arrayAllContacts = contacts
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableViewContacts.reloadData()
        })
        }
    }
}
