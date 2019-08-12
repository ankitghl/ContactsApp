//
//  ContactAddEditViewModel.swift
//  Contacts
//
//  Created by Ankit.Gohel on 10/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import Foundation

class ContactAddEditViewModel {

    // MARK: - Constants and Variables -

    private var networkClient: NetworkManager?
    private var path: String?
    private (set) var  contactActionType: ContactActionType

    var contactAddDeleteViewModelDelegate: ContactViewModelProtocol?
    var isFieldValuesChanged: Bool = false
    var contactData: ContactDisplayModel?

    // MARK: - Initiliasers -
    init() {
        contactActionType = .edit
    }
    
     convenience init(urlPath: String, screenType: ContactActionType, contact: ContactDisplayModel?) {
        self.init()
        
        contactActionType = screenType
        path = getPath(path: urlPath)
        contactData = contact
        networkClient = NetworkManager(contactDelegate: self)
    }

    // MARK: - Private Helpers -

    private func getPath(path: String) -> String? {
        let urlComp = URLComponents(string: path)
        return urlComp?.path
    }
    
    private func prepareContactParamaterDictionaryForUpdate() -> [String:Any] {
        var paramerters = [String:Any]()
        paramerters[ContactUpdateKeys.firstName.rawValue]   = contactData?.firstName
        paramerters[ContactUpdateKeys.lastName.rawValue]    = contactData?.lastName
        paramerters[ContactUpdateKeys.email.rawValue]       = contactData?.email
        paramerters[ContactUpdateKeys.mobile.rawValue]      = contactData?.phoneNumber
        return paramerters
    }
    
    private func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }

    private func createContact() {
        guard contactData != nil else { return }
        
        var networkService: NetworkManagerProtocol = NetworkManagerRequest.update(parameters: prepareContactParamaterDictionaryForUpdate(), path: path ?? "", type: contactActionType)
        
        if contactActionType == .delete {
            networkService = NetworkManagerRequest.delete(path: path ?? "")
        }
        networkClient?.fetchContactList(forType: networkService)
    }

    // MARK: - API Calls -

    func createNewContact() {
        contactActionType = .create
        createContact()
    }
    
    func deleteContact() {
        contactActionType = .delete
        createContact()
    }
    
    // MARK: - Internal Accessibles -

    func validateContactAndThrowErrorMessage(contact: ContactDisplayModel) -> String {
        if contact.firstName.count < 2 {
            return "Enter valid first name"
        }
        if contact.lastName.count < 2 {
            return "Enter valid last name"
        }
        if let _phoneNumber = contact.phoneNumber {
            if _phoneNumber.isEmpty || !_phoneNumber.isEmpty && _phoneNumber.count < 10 {
                return "Enter valid phonenumber"
            }
        }
        if contact.email.isEmpty || !contact.email.isEmpty && !validateEmail(email: contact.email) {
            return "Enter valid email"
        }
        return ""
    }
}


extension ContactAddEditViewModel: ContactListResponseProtocol {
    func didFetchContactListData(data: Data) {
        let decoder = JSONDecoder.init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let contact =  try! decoder.decode(Contact.self, from: data)
        contactData = ContactDisplayModel(contact: contact)
        DispatchQueue.main.async { [weak self] in
            self?.contactAddDeleteViewModelDelegate?.didFetchContactData()
        }
    }
    
    func didReceiveContactListDataError(error: String) {
            DispatchQueue.main.async { [weak self] in
            self?.isFieldValuesChanged = false
                self?.contactAddDeleteViewModelDelegate?.didReceiveFetchContactDataError(error: error)
        }
    }
}
