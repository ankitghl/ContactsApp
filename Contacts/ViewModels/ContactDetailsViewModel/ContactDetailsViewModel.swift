//
//  ContactDetailsViewModel.swift
//  Contacts
//
//  Created by Ankit.Gohel on 09/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class ContactDetailsViewModel: NSObject {

    // MARK: - Constants and Variables -
    private var networkClient: NetworkManager?
    weak var contactDetailsViewModelDelegate: ContactViewModelProtocol?
    private(set) var path: String?
    private(set) var contactData: ContactDisplayModel?

    // MARK: - Initiliasers -
    init(delegate: ContactViewModelProtocol, urlPath: String) {
        super.init()
        path = getPath(path: urlPath)
        contactDetailsViewModelDelegate = delegate
        networkClient = NetworkManager(contactDelegate: self)
    }
    
    // MARK: - Private Helpers -
    private func getPath(path: String) -> String? {
        let urlComp = URLComponents(string: path)
        return urlComp?.path
    }

    //MARK: - API Calls
    func getContactDetails() {
        networkClient?.fetchContactList(forType: NetworkManagerRequest.contactDetails(path: path ?? ""))
    }
    
    func updatefavourites() {
        guard let contact = contactData else { return }
        networkClient?.fetchContactList(forType: NetworkManagerRequest.update(parameters: ["favorite": !contact.favorite],
                                                                              path: path ?? "",
                                                                              type: .edit))
    }

    // MARK: - Internal Accesibles -
    func isPresent(field fieldValue: String?) -> Int {
        if fieldValue == nil || fieldValue == "" {
            return 0
        } else {
            return 1
        }
    }
    
}

//MARK: - MovieListAPIResponseProtocol Delegate Methods -

extension ContactDetailsViewModel: ContactListResponseProtocol {
    func didFetchContactListData(data: Data) {
        let decoder = JSONDecoder.init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let contact =  try! decoder.decode(Contact.self, from: data)
        contactData = ContactDisplayModel(contact: contact)
        DispatchQueue.main.async { [weak self] in
            self?.contactDetailsViewModelDelegate?.didFetchContactData()
        }
    }
    
    func didReceiveContactListDataError(error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.contactDetailsViewModelDelegate?.didReceiveFetchContactDataError(error: error)
        }
    }
}
