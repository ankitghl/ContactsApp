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
    var networkClient: NetworkManager?
    weak var contactDetailsViewModelDelegate: ContactDetailsViewModelProtocol?
    private var path: String?
    private(set) var contactData: ContactDisplayModel?

    // MARK: - Initiliasers -
    init(delegate: ContactDetailsViewModelProtocol, urlPath: String) {
        super.init()
        path = getPath(path: urlPath)
        contactDetailsViewModelDelegate = delegate
        networkClient = NetworkManager(contactDelegate: self)
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

    func isPresent(field fieldValue: String?) -> Int {
        if fieldValue == nil || fieldValue == "" {
            return 0
        } else {
            return 1
        }
    }
    
    private func getPath(path: String) -> String? {
        let urlComp = URLComponents(string: path)
        return urlComp?.path
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
            self?.contactDetailsViewModelDelegate?.didFetchContactDetails()
        }
    }
    
    func didReceiveContactListDataError(error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.contactDetailsViewModelDelegate?.didReceiveFetchContactDetailsError(error: error)
        }
    }
}
