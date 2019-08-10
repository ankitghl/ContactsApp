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

protocol ContactListViewModelProtocol: class {
    func didFetchContactList()
    func didReceiveFetchContactListError(error: String)
}

protocol ContactDetailsViewModelProtocol: class {
    func didFetchContactDetails()
    func didReceiveFetchContactDetailsError(error: String)
}

//protocol ContactImageDownloadResponseProtocol: class {
//    func didFetchImage(with data: Data)
//    func didReceiveImageDownloadError(error: String)
//}
