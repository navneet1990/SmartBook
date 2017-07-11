//
//  ContactCell.swift
//  MyPhoneBook
//
//  Created by Navneet Singh (navneet.aug1990@gmail.com) on 3/12/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtFieldDetail: UITextField!
    
    var vc: PBContactDetailController?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        txtFieldDetail.givePaddingInTextField()
    }
    
    func loadCellWithData(mainTitle: String){
        lblTitle.text = mainTitle
        txtFieldDetail.placeholder = "Enter " + mainTitle
        if mainTitle == "Name"{
            txtFieldDetail.text = vc?.tempObj!.name
        }
        else if mainTitle == "Number"{
            txtFieldDetail.text = vc?.tempObj!.number
            txtFieldDetail.keyboardType = .numberPad
        }
        else if mainTitle == "Birthday"{
            txtFieldDetail.text = vc?.tempObj!.birthday
        }
        else if mainTitle == "Email"{
            txtFieldDetail.text = vc?.tempObj!.email
            
        }
        else{
            txtFieldDetail.isEnabled =  false
                        txtFieldDetail.isUserInteractionEnabled =  false
            txtFieldDetail.placeholder = ""
            txtFieldDetail.text = ""
            if vc?.tempObj?.id != ""{
            if let obj =  CoreDataManager.getById((vc?.tempObj?.id)!) as? CONTACTSENTITY {
                if (obj.group != nil) && vc!.boolAddNew == false{
                     txtFieldDetail.text = obj.group?.name!
                }
            }
            }
        }
        
    }
    
    func checkValidation(){

        guard (vc?.tempObj?.name?.characters.count)! > 0 && (vc?.tempObj?.number?.characters.count)! > 0 && ((vc?.tempObj?.email?.characters.count)! == 0 || ((vc?.tempObj?.email?.characters.count)! > 0 && (vc?.tempObj?.email?.isValidEmail())!))
        else{
            self.vc?.barBtnSave.isEnabled = false
            return
        }
        self.vc?.barBtnSave.isEnabled = true
    }
    @IBAction func textDidChange(_ sender: UITextField) {
        sender.removeWhiteSpaceFromTextField()
        let row = sender.tag - 100
        
        if  row == 0 {
            vc?.tempObj!.name = sender.text
        }
        else if  row == 1 {
            vc?.tempObj!.number = sender.text
        }
        else if  row == 2 {
            vc?.tempObj!.birthday = sender.text
            
        }
        else if  row == 3 {
            vc?.tempObj!.email = sender.text

        }
     checkValidation()
    }
}

