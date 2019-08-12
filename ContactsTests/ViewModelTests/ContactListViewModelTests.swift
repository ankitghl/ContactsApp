//
//  ContactListViewModelTests.swift
//  ContactsTests
//
//  Created by Ankit.Gohel on 12/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactListViewModelTests: XCTestCase {

    var viewModel: ContactListViewModel?
    var contactList:  [Contact]?
    var contactListSections: [ContactListSection] = []

    override func setUp() {
        
        viewModel = ContactListViewModel()
        if let path = Bundle.main.path(forResource: "ContactJSON", ofType: "json") {
            if let jsonData: Data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                let decoder = JSONDecoder.init()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let contacts = try? decoder.decode([Contact].self, from: jsonData)
                    contactList = contacts
            }
        }
    }

    override func tearDown() {
        viewModel = nil
        contactList = nil
        super.tearDown()
    }
    
    func testContactListCount() {
        XCTAssertEqual(contactList?.count, 5)
    }
    
    func testContactsSectionsCount() {
        if let _contacts = contactList, let _contactSection = viewModel?.sortAndArrangeContacts(contacts: _contacts) {
            contactListSections = _contactSection
            
            XCTAssertEqual(contactListSections.count, 27)
        }
    }
    
    func testContactsSectionForAlphabetACount() {
        if let _contacts = contactList,
            let _contactSection = viewModel?.sortAndArrangeContacts(contacts: _contacts) {
            contactListSections = _contactSection
            let sectionA = contactListSections.first
            XCTAssertEqual(sectionA?.contacts.count, 3)
        }
    }

}
