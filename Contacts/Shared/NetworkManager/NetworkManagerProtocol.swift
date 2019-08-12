//
//  NetworkManagerProtocol.swift
//  Contacts
//
//  Created by Ankit.Gohel on 09/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    var type: String { return self.rawValue.uppercased() }
}

enum ParametersEncoding {
    case json
    case url
}

public typealias Parameters = [String: Any]

enum Task {
    case request
    case requestParameters(Parameters)
}
 
protocol NetworkManagerProtocol {
    var path: String { get }
    var task: Task { get }
    var method: HTTPMethod { get }
    var parametersEncoding: ParametersEncoding { get }
}
