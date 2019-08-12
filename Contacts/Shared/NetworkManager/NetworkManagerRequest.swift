//
//  NetworkManagerRequest.swift
//  Contacts
//
//  Created by Ankit.Gohel on 09/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import Foundation

enum NetworkManagerRequest: NetworkManagerProtocol {
    
    case contactList
    case contactDetails(path: String)
    case update(parameters: [String:Any], path: String, type: ContactActionType)
    
    static var baseURL: String { return "http://gojek-contacts-app.herokuapp.com" }
    
    var path: String {
        switch self {
        case .contactList: return "/contacts.json"
        case let .contactDetails(path): return path
        case let .update(_, path, type): return type == .edit ? path : "/contacts.json"
        }
    }
    
    var task: Task {
        switch self {
        case .contactList, .contactDetails: return .request
        case let .update(parameters, _, _): return .requestParameters(parameters)
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .contactList, .contactDetails: return .get
        case let .update(_,_, type ): return  type == .edit ? .put : .post
        }
    }
    
    var parametersEncoding: ParametersEncoding {
        switch self {
        case .contactList, .contactDetails: return .url
        case .update: return .json
        }
    }
}
