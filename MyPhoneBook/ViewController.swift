//
//  ViewController.swift
//  MyPhoneBook
//
//  Created by iTexico on 3/11/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit
import Contacts
import SVProgressHUD

class ViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableViewContacts: UITableView!
    
    @IBOutlet weak var barBtnAdd: UIBarButtonItem!
    @IBOutlet weak var barBtnGrps: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK:- Variables
    var arrayContacts: [ContactObj] = []
    var allowRowSelection = false
    var isForGroups = false
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        customizeUI()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Customize UI
    func customizeUI(){
        navigationItem.leftBarButtonItem = barBtnGrps
        
        fetchData()
        
    }
    
    func fetchData(){
        let manager = PBManager.init()
        manager.delegate = self
        manager.getAllContacts(pred: "", id: "")
        

    }
    //MARK:- NAvigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ContactDetailSegue" &&  sender is NSIndexPath{
            
            let vc = segue.destination as? PBContactDetailController
            let obj = arrayContacts[(sender as! IndexPath).row]
            vc?.contactObj = obj
            vc?.intergerRow = (sender as! IndexPath).row
            vc?.boolAddNew = false
        }
        
    }
    

    func unwindContactDetail(_ segue: UIStoryboardSegue){
        let vc = segue.source as? PBContactDetailController
        
        if vc?.boolAddNew == true{
            arrayContacts.append((vc?.contactObj!)!)
        }
        else{
            arrayContacts[(vc?.intergerRow!)!] = (vc?.contactObj)!
        }
        if arrayContacts.count > 0 {
            navigationItem.leftBarButtonItem = barBtnGrps
        }
        
        self.tableViewContacts.reloadData()
        
    }
    
}
//MARK:- UITableView DatasourceMethods
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayContacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ENUMTABLECELL.CONTACTLIST.rawValue)! as UITableViewCell
        let obj = arrayContacts[indexPath.row]
        cell.textLabel?.text = obj.name!
        cell.detailTextLabel?.text = obj.number!
        cell.imageView?.image = UIImage.init(named: ENUMPLACEHOLDERIMAGES.USER.rawValue)
        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.height)!/2
        cell.imageView?.imageFromData(data: (obj.photoData))
        cell.imageView?.layer.masksToBounds = true
        
        cell.setNeedsLayout() //invalidate current layout
        cell.layoutIfNeeded()
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "ContactDetailSegue", sender: indexPath)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete  {
            guard  CoreDataManager.deleteEntityFromDB(ENUMCOREDATA.CONTACT.rawValue, arrayContacts[indexPath.row].id!) == true
                else {
                    PBUtility.showAlertMsg(title: "FAILED", description: "Failed to delete contact from DB", vc: self, false)
                    return
            }
            arrayContacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

//MARK:- Bar Button Actions
extension ViewController {
    
    @IBAction func refreshBarBtnAction(_ sender: Any) {
        fetchData()
        
    }
    @IBAction func checkGroupsAction(sender: AnyObject) {
        
    }
    
    @IBAction func addNewContactAction(sender: AnyObject) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ENUMSEGUE.ADDNEW.rawValue) as! PBContactDetailController
        let navBar = UINavigationController.init(rootViewController: vc)
        present(navBar, animated: true, completion: nil)
        
    }
}
//MARK:- Fetch COntacts Delegates
extension ViewController : AddContactDelegate{
    
    func didFetchContacts(contacts: [ContactObj]) {
        
        arrayContacts = contacts
        if contacts.count < 1 {
            navigationItem.leftBarButtonItem = nil
        }
        else{
            navigationItem.leftBarButtonItem = barBtnGrps
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            SVProgressHUD.dismiss()
            self.tableViewContacts.reloadData()
        })
    }
}

