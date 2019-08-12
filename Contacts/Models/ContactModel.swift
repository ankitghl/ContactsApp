//
//  ContactModel.swift
//  Contacts
//
//  Created by Ankit.Gohel on 08/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import Foundation

struct Contact: Codable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let profilePic: String?
    let favorite: Bool?
    let url: String?
    let phoneNumber: String?
    let email: String?
    
    var fullName: String {
        
        if firstName == nil && lastName == nil {
            return ""
        } else if firstName == nil {
            return lastName ?? ""
        } else if lastName == nil {
            return firstName ?? ""
        } else {
            return (firstName ?? "")  + " " + (lastName ?? "")
        }
    }
    
}

struct ContactDisplayModel {
    var firstName: String
    var lastName: String
    var profileImage: String
    var favorite: Bool = false
    var url: String
    var phoneNumber: String?
    var email: String
    var fullName: String {
        return getFullName()
    }
    
    init(contact: Contact) {
        firstName = contact.firstName ?? ""
        lastName = contact.lastName ?? ""
        profileImage = contact.profilePic ?? ""
        favorite = contact.favorite ?? false
        url = contact.url ?? ""
        phoneNumber = contact.phoneNumber ?? ""
        email = contact.email ?? ""
    }

    private func getFullName() -> String {
        if firstName.isEmpty && lastName.isEmpty {
            return ""
        } else if firstName.isEmpty {
            return lastName
        } else if lastName.isEmpty {
            return firstName
        } else {
            return firstName + " " + lastName
        }
    }
}
