//
//  ContactModelTests.swift
//  ContactsTests
//
//  Created by Ankit.Gohel on 12/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactModelTests: XCTestCase {

    var contact: Contact!
    var contactDisplayModel: ContactDisplayModel!
    
    private let contactInfo: [String:Any] =  [
        "id": 1234,
        "first_name": "Ankit",
        "last_name": "Gohel",
        "profile_pic": "/images/missing.png",
        "favorite": true,
        "url": "http://gojek-contacts-app.herokuapp.com/contacts/1234.json"
    ]
    
    override func setUp() {
        super.setUp()
        contact = Contact(contact: contactInfo)
        contactDisplayModel = ContactDisplayModel(contact: contact)
    }
    
    override func tearDown() {
        contact = nil
        contactDisplayModel = nil
        super.tearDown()
    }
    
    func testContactAttributes() {
        XCTAssertEqual(contact.firstName!, "Ankit")
        XCTAssertTrue(contact.favorite!)
    }
    
    func testFullNameWithFirstNameAndLastName() {
        XCTAssertEqual(contact.fullName, "Ankit Gohel")
    }
    
    func testFullNameWithNoFirstNameAndNoLastName() {
        let contactInfo: [String:Any] =  [
            "id": 1234,
            "profile_pic": "/images/missing.png",
            "favorite": true,
            "url": "http://gojek-contacts-app.herokuapp.com/contacts/1234.json"
        ]
        contact = Contact(contact: contactInfo)
        contactDisplayModel = ContactDisplayModel(contact: contact)
        XCTAssertEqual(contact.fullName, "")
    }
    
    func testFullNameWithNoFirstNameAndLastName() {
        let contactInfo: [String:Any] =  [
            "id": 1234,
            "last_name": "Gohel",
            "profile_pic": "/images/missing.png",
            "favorite": true,
            "url": "http://gojek-contacts-app.herokuapp.com/contacts/1234.json"
        ]
        contact = Contact(contact: contactInfo)
        contactDisplayModel = ContactDisplayModel(contact: contact)
        XCTAssertEqual(contact.fullName, "Gohel")
    }
    
    func testFullNameWithFirstNameAndNoLastName() {
        let contactInfo: [String:Any] =  [
            "id": 1234,
            "first_name": "Ankit",
            "profile_pic": "/images/missing.png",
            "favorite": true,
            "url": "http://gojek-contacts-app.herokuapp.com/contacts/1234.json"
        ]
        contact = Contact(contact: contactInfo)
        contactDisplayModel = ContactDisplayModel(contact: contact)
        XCTAssertEqual(contact.fullName, "Ankit")
    }

    func testContactDisplayModelAttributes() {
        XCTAssertEqual(contactDisplayModel.firstName , "Ankit")
        XCTAssertEqual(contactDisplayModel.lastName , "Gohel")
        XCTAssertTrue(contactDisplayModel.favorite )
    }
    
    func testContactDisplayModelFullName() {
        XCTAssertEqual(contactDisplayModel.fullName, "Ankit Gohel")
    }
    
    func testContactDisplayModelFullNameWithNoFirstNameAndNoLastName() {
        let contactInfo: [String:Any] =  [
            "id": 1234,
            "profile_pic": "/images/missing.png",
            "favorite": true,
            "url": "http://gojek-contacts-app.herokuapp.com/contacts/1234.json"
        ]
        contact = Contact(contact: contactInfo)
        contactDisplayModel = ContactDisplayModel(contact: contact)
        XCTAssertEqual(contactDisplayModel.fullName, "")
    }
    
    func testContactDisplayModelFullNameWithNoFirstNameAndLastName() {
        let contactInfo: [String:Any] =  [
            "id": 1234,
            "last_name": "Gohel",
            "profile_pic": "/images/missing.png",
            "favorite": true,
            "url": "http://gojek-contacts-app.herokuapp.com/contacts/1234.json"
        ]
        contact = Contact(contact: contactInfo)
        contactDisplayModel = ContactDisplayModel(contact: contact)
        XCTAssertEqual(contactDisplayModel.fullName, "Gohel")
    }
    
    func testContactDisplayModelFullNameWithFirstNameAndNoLastName() {
        let contactInfo: [String:Any] =  [
            "id": 1234,
            "first_name": "Ankit",
            "profile_pic": "/images/missing.png",
            "favorite": true,
            "url": "http://gojek-contacts-app.herokuapp.com/contacts/1234.json"
        ]
        contact = Contact(contact: contactInfo)
        contactDisplayModel = ContactDisplayModel(contact: contact)
        XCTAssertEqual(contactDisplayModel.fullName, "Ankit")
    }

}

extension Contact {
    init(contact: [String: Any]) {
        self.init(id: contact["id"] as? Int,
                  firstName: contact["first_name"] as? String,
                  lastName: contact["last_name"] as? String,
                  profilePic: contact["profile_pic"] as? String,
                  favorite: contact["favorite"] as? Bool,
                  url: contact["url"] as? String,
                  phoneNumber: contact["phone_number"] as?  String,
                  email: contact["email"] as? String)
    }
}

