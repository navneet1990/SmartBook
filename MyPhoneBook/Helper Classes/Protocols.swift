//
//  Protocols.swift
//  MyPhoneBook
//
//  Created by Navneet Singh (navneet.aug1990@gmail.com) on 3/11/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import Foundation
import Contacts

protocol AddContactDelegate {
    func didFetchContacts(contacts: [ContactObj])
}

protocol AllGroupsDelegate {
    func didFetchGroups(groups: [GroupObj])
}
