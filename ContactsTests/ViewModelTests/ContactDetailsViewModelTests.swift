//
//  ContactDetailsViewModel.swift
//  ContactsTests
//
//  Created by Ankit.Gohel on 12/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactDetailsViewModelTests: XCTestCase {

    var viewModel: ContactDetailsViewModel?

    override func setUp() {
        viewModel = ContactDetailsViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testURLPathSuccess() {
        let url = viewModel?.getPath(path: "https://gojek-contacts-app.herokuapp.com/contacts/8993.json")
        XCTAssertEqual(url, "/contacts/8993.json")
    }
    
    func testURLPathFailure() {
        let url = viewModel?.getPath(path: "")
        XCTAssertEqual(url, "")
    }

    func testValidFieldPresent() {
        guard let validField = viewModel?.isPresent(field: "Valid Entry") else { return }
        XCTAssertTrue(validField)
    }
    
    func testInValidFieldPresent() {
        guard let inValidField = viewModel?.isPresent(field: "") else { return }
        XCTAssertFalse(inValidField)
    }

}
