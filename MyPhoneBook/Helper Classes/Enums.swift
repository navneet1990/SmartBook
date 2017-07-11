//
//  Enums.swift
//  MyPhoneBook
//
//  Created by Navneet Singh (navneet.aug1990@gmail.com) on 3/12/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import Foundation


enum ENUMTABLECELL : String {
    case CONTACTLIST = "nameCell"
    case CONTACTCELL = "contactCell"
    
}

enum ENUMSEGUE : String{
    case ADDNEW = "AddNewContact"
    case GROUPS = "GroupListSegue"
    case ALLCONTACTS = "ConactListSegue"
    case GROUPDETAIL = "GroupContactListSegue"
    case CONTACTDETAIL = "GroupContactDetailSegue"
}


enum ENUMCOREDATA : String{
    
    case CONTACT = "CONTACTSENTITY"
    case GROUP = "GROUPENTITY"
}

enum ENUMSEGUEUNWIND : String{
    case CONTACTLIST = "unwindContactDetail"
    case GROUPLIST = "unwindToGroupList"
    case GROUPLISTDETAIL = "unwindGroupListDetail"
    case GROUPLISTCONTACTDETAIL = "unwindGroupListContactDetail"
}


enum ENUMPLACEHOLDERIMAGES : String{
    case USER = "noImage"
    case ADDPHOTO = "addImage"
}

enum ENUMPREDGROUPRELATION: String{
    case GROUP = "group"
    case MEMBER = "member"
}
