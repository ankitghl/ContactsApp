//
//  ContactAddDeleteViewModelTests.swift
//  ContactsTests
//
//  Created by Ankit.Gohel on 12/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactAddDeleteViewModelTests: XCTestCase {

    var viewModel: ContactAddEditViewModel?
    
    override func setUp() {
        super.setUp()
        viewModel = ContactAddEditViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testValidationForFirstName() {
        let contactInfo: [String:Any] =  [
            "id": 1234,
            "first_name": "",
            "last_name": "Gohel",
            "profile_pic": "/images/missing.png",
            "favorite": true,
            "url": "http://gojek-contacts-app.herokuapp.com/contacts/1234.json"
        ]
        let contact = Contact(contact: contactInfo)
        let contactDisplayModel = ContactDisplayModel(contact: contact)

        let errorMessage = viewModel?.validateContactAndThrowErrorMessage(contact: contactDisplayModel)
        XCTAssertEqual(errorMessage, "Enter valid first name")
    }
    
    func testValidationForLastName() {
        let contactInfo: [String:Any] =  [
            "id": 1234,
            "first_name": "Ankit",
            "last_name": "",
            "profile_pic": "/images/missing.png",
            "favorite": true,
            "url": "http://gojek-contacts-app.herokuapp.com/contacts/1234.json"
        ]
        let contact = Contact(contact: contactInfo)
        let contactDisplayModel = ContactDisplayModel(contact: contact)
        
        let errorMessage = viewModel?.validateContactAndThrowErrorMessage(contact: contactDisplayModel)
        XCTAssertEqual(errorMessage, "Enter valid last name")
    }

    func testValidationForPhoneNumber() {
        let contactInfo: [String:Any] =  [
            "id": 1234,
            "first_name": "Ankit",
            "last_name": "Gohel",
            "profile_pic": "/images/missing.png",
            "favorite": true,
            "url": "http://gojek-contacts-app.herokuapp.com/contacts/1234.json"
        ]
        let contact = Contact(contact: contactInfo)
        let contactDisplayModel = ContactDisplayModel(contact: contact)
        
        let errorMessage = viewModel?.validateContactAndThrowErrorMessage(contact: contactDisplayModel)
        XCTAssertEqual(errorMessage, "Enter valid phonenumber")
    }
    
    func testValidationForEmail() {
        let contactInfo: [String:Any] =  [
            "id": 1234,
            "first_name": "Ankit",
            "last_name": "Gohel",
            "profile_pic": "/images/missing.png",
            "favorite": true,
            "url": "http://gojek-contacts-app.herokuapp.com/contacts/1234.json"
        ]
        let contact = Contact(contact: contactInfo)
        var contactDisplayModel = ContactDisplayModel(contact: contact)
        contactDisplayModel.phoneNumber = "1234567890"
        contactDisplayModel.email = "email"
        let errorMessage = viewModel?.validateContactAndThrowErrorMessage(contact: contactDisplayModel)
        XCTAssertEqual(errorMessage, "Enter valid email")
    }


}
