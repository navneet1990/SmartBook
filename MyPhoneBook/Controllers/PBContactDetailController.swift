//
//  PBContactDetailController.swift
//  MyPhoneBook
//
//  Created by Navneet Singh (navneet.aug1990@gmail.com) on 3/12/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit
import Contacts
class PBContactDetailController: UIViewController, UINavigationControllerDelegate   {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var barBtnBack: UIBarButtonItem!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var batBtnEdit: UIBarButtonItem!
    @IBOutlet weak var barBtnCancel: UIBarButtonItem!
    @IBOutlet weak var barBtnSave: UIBarButtonItem!
    
    //MARK:- Variables
    var intergerRow : NSInteger?
    var imagePicker = UIImagePickerController()
    var boolAddNew = true
    var boolEditEnable = false
    var contactObj: ContactObj?
    var tempObj: ContactObj?
    var arrayContent: [String] = ["Name", "Number","Birthday","Email","Group"]
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
    
    
    //MARL:- Customize UI
    func customizeUI(){
        if contactObj == nil {
            contactObj = ContactObj.init("", "", NSData(), "", "",id: "", NSDate())
            navigationItem.rightBarButtonItem = barBtnSave
            navigationItem.leftBarButtonItem = barBtnCancel
            navigationItem.title = "Add Contact"
            boolEditEnable = true
            barBtnSave.isEnabled = false
            imgViewUser.isUserInteractionEnabled = true
            
        }
        else{
            
        navigationItem.setRightBarButton(batBtnEdit, animated: true)
        }
        
        tempObj = contactObj?.copy() as! ContactObj?
        imgViewUser.imageFromData(data: (tempObj?.photoData))
        imagePicker.delegate = self
        
        
    }    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func  openCam(isCam:Bool) {
        
        if isCam == true {
            if(UIImagePickerController .isSourceTypeAvailable(.camera))
            {
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                present(imagePicker, animated: true, completion: nil)
            }
            else{
                PBUtility.showAlertMsg(title: "Sorry", description: "Camera not avilable", vc: self,false)
            }
        }
        else{
            if(UIImagePickerController .isSourceTypeAvailable(.photoLibrary))
            {
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                present(imagePicker
                    , animated: true, completion: nil)
            }
        }
    }

}

//MARK:- IBAction's
extension PBContactDetailController{
    
    @IBAction func editUserImage(_ sender: UITapGestureRecognizer) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { void in
            self.dismiss(animated: true, completion: nil)
        }
        actionSheetController.addAction(cancelActionButton)
        
        let camActionButton: UIAlertAction = UIAlertAction(title: "Cam", style: .destructive)
        { void in
            self.openCam(isCam: false)
        }
        actionSheetController.addAction(camActionButton)
        
        let libActionButton: UIAlertAction = UIAlertAction(title: "Library", style: .default)
        { void in
            self.openCam(isCam: false)
        }
        actionSheetController.addAction(libActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }

    
    @IBAction func saveBarBtnAction(_ sender: Any) {
                    contactObj = tempObj
        if boolAddNew == false{
            let state =      CoreDataManager.updateEntityUsingBatchRequest(ENUMCOREDATA.CONTACT.rawValue, tempObj!)
            print("States:\(state)")
            navigationItem.setRightBarButton(batBtnEdit, animated: true)
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = false
            
            boolEditEnable = true
            guard state else {
                PBUtility.showAlertMsg(title: "Failed", description: "Failed to update", vc: self,false)
                return
            }
            
            let controllers = navigationController?.viewControllers
            if let last = controllers?[(controllers?.count)! - 2] , last is PBGroupDetailListController {
                self.performSegue(withIdentifier: ENUMSEGUEUNWIND.GROUPLISTCONTACTDETAIL.rawValue, sender: self)

            }
            else{
            self.performSegue(withIdentifier: ENUMSEGUEUNWIND.CONTACTLIST.rawValue, sender: self)
            }
            
            PBUtility.showAlertMsg(title: "Success", description: "Information Updated", vc: self,false)
        }
        else{
            let state =     CoreDataManager.coreDataInsertOperationForEntityName(ENUMCOREDATA.CONTACT.rawValue, tempObj!)
            
            if state == true{
                PBUtility.showAlertMsg(title: "Success", description: "Contact Saved", vc: self,false)
                
                self.performSegue(withIdentifier: ENUMSEGUEUNWIND.CONTACTLIST.rawValue, sender: self)
            }
            else{
                PBUtility.showAlertMsg(title: "Failed", description: "Failed to Save", vc: self,false)
                
            }
        }
        
    }
    @IBAction func cancelBarBtnAction(_ sender: Any) {
        tempObj = contactObj?.copy() as! ContactObj?
        
        if boolAddNew == true{
            dismiss(animated: true, completion: nil)
        }
        else{
            imgViewUser.imageFromData(data: (tempObj?.photoData))
            
            navigationItem.setRightBarButton(batBtnEdit, animated: true)
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = false
            boolEditEnable = false
            tableViewData.reloadData()
        }
    }
    @IBAction func editBarBtnAction(_ sender: Any) {
        navigationItem.rightBarButtonItem = barBtnSave
        navigationItem.leftBarButtonItem = barBtnCancel
        imgViewUser.isUserInteractionEnabled = true
        //tempObj = contactObj?.copy() as! ContactObj?
        boolEditEnable = true
        tableViewData.reloadData()
    }
}
//MARK:- UITableView DatasourceMethods
extension PBContactDetailController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayContent.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ENUMTABLECELL.CONTACTCELL.rawValue)! as! ContactCell
        cell.vc = self
        cell.txtFieldDetail.isEnabled = indexPath.row > 4 ? false : boolEditEnable
        cell.txtFieldDetail.tag = indexPath.row + 100
        cell.loadCellWithData(mainTitle: arrayContent[indexPath.row])
        return cell
    }
}
//MARK:- UITableView DelegateMethods
extension PBContactDetailController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}


//MARK:- Image Picker Delegaes

extension PBContactDetailController: UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true
            , completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        tempObj?.photoData = UIImageJPEGRepresentation(pickedImage!, 0.7) as NSData?
        imgViewUser.imageFromData(data: (tempObj?.photoData))
        
        dismiss(animated: true, completion: nil)
    }
}
