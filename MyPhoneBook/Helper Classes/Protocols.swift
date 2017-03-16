//
//  Protocols.swift
//  MyPhoneBook
//
//  Created by iTexico on 3/11/17.
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
