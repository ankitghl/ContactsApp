//
//  ContactListViewModel.swift
//  Contacts
//
//  Created by Ankit.Gohel on 08/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//
import Foundation
import UIKit

class ContactListViewModel: NSObject {

    // MARK: - Constants and Variables -
    var networkClient: NetworkManager?
    weak var contactListViewModelDelegate: ContactListViewModelProtocol?
    var contactListSections: [ContactListSection] = []

    let title = "Contacts"
    
    // MARK: - Initiliasers -
    init(delegate: ContactListViewModelProtocol) {
        super.init()
        
        contactListViewModelDelegate = delegate
        networkClient = NetworkManager(contactDelegate: self)
    }
    
    //MARK: - API Calls
    
    func getContactList() {
        networkClient?.fetchContactList(forType: NetworkManagerRequest.contactList)
    }
}

//MARK: - MovieListAPIResponseProtocol Delegate Methods -

extension ContactListViewModel: ContactListResponseProtocol {
    func didFetchContactListData(data: Data) {
        do {
            let decoder = JSONDecoder.init()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let contacts =  try decoder.decode([Contact].self, from: data)
            
            let sortedContacts = contacts.sorted(by: { $0.fullName < $1.fullName })
            
            contactListSections = []
            
            let sectionTitles = UILocalizedIndexedCollation.current().sectionTitles
            
            var calculatingSections: [ContactListSection] = []
            
            for title in sectionTitles {
                let contacts = sortedContacts.filter({ $0.fullName.capitalized.hasPrefix(title)})
                let section = ContactListSection.init(sectionTitle: title, contacts: contacts)
                calculatingSections.append(section)
            }
            contactListSections = calculatingSections

            DispatchQueue.main.async { [weak self] in
                self?.contactListViewModelDelegate?.didFetchContactList()
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.contactListViewModelDelegate?.didReceiveFetchContactListError(error: "Cannot parse response")
            }
        }

    }
    
    func didReceiveContactListDataError(error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.contactListViewModelDelegate?.didReceiveFetchContactListError(error: error)
        }
    }
}
