//
//  Protocols.swift
//  Contacts
//
//  Created by Ankit.Gohel on 08/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import Foundation

protocol ContactListResponseProtocol: class {
    func didFetchContactListData(data: Data)
    func didReceiveContactListDataError(error: String)
}

protocol ContactViewModelProtocol: class {
    func didFetchContactData()
    func didReceiveFetchContactDataError(error: String)
}

protocol ContactUpdateProtocol: class {
    func didUpdateContact()
}

protocol ContactDeleteProtocol: class {
    func didDeleteContact()
}


