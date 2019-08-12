//
//  Constants.swift
//  Contacts
//
//  Created by Ankit.Gohel on 09/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import Foundation

enum ContactDetailsActionTags: Int {
    case message
    case phone
    case email
    case favourite
    
    func tag() -> Int {
        switch self {
        case .message: return 1
        case .phone: return 2
        case .email: return 3
        case .favourite: return 4
        }
    }
}

enum ContactDetailsFields: String {
    case firstName = "firstName"
    case lastName = "lastName"
    case mobile = "mobile"
    case email = "email"
    
    func tag() -> Int {
        switch self {
        case .firstName: return 11
        case .lastName: return 12
        case .mobile: return 13
        case .email: return 14
        }
    }
    
    func placeholder() -> String {
        return self.rawValue
    }
}


enum ContactDetailsTableView {
    case normal
    case textCell
    case zero
    func height() -> Float {
        switch self {
        case .normal: return 64.0
        case .textCell: return 56.0
        case .zero: return 0.0
        }
    }
}

enum MiscellaneousConstants: Int {
    case doneAccessoryButtonHeight = 50
}

public enum ContactActionType {
    case create
    case edit
}

public enum ContactUpdateKeys: String {
    case firstName = "first_name"
    case lastName = "last_name"
    case mobile = "phone_number"
    case email = "email"
}
