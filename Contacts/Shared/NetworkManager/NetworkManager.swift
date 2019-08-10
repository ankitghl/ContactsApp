//
//  NetworkManager.swift
//  Contacts
//
//  Created by Ankit.Gohel on 08/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    //MARK: - Properties and Constants -
    let BASE_URL = "https://gojek-contacts-app.herokuapp.com/contacts.json"

    weak var contactListDelegate: ContactListResponseProtocol?

    // MARK: - Initialisers -
    
    init(contactDelegate: ContactListResponseProtocol?) {
        contactListDelegate = contactDelegate
    }
    
    private func initialiseURLComponents(forType type: NetworkManagerProtocol) -> URLComponents {
        guard let url = URL(string: NetworkManagerRequest.baseURL)?.appendingPathComponent(type.path) else {
            preconditionFailure("Couldn't construct the BaseURL")
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        guard case let .requestParameters(parameters) = type.task, type.parametersEncoding == .url else { return urlComponents }
        urlComponents.queryItems = parameters.map({ URLQueryItem(name: $0, value: String(describing: $1)) })
        return urlComponents
    }
    
    private func initialiseURLRequest(forType type: NetworkManagerProtocol) -> URLRequest {
        let components = initialiseURLComponents(forType: type)
        guard let url = components.url else { preconditionFailure("Failed to construct URL") }
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = type.method.type
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard case let .requestParameters(parameters) = type.task, type.parametersEncoding == .json else { return urlRequest }
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        return urlRequest
    }
    

    // MARK: - API Calls -
    func fetchContactList(forType type: NetworkManagerProtocol) {
        let request = initialiseURLRequest(forType: type)
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] (responseData, response, error) in
            guard error == nil else {
                self?.contactListDelegate?.didReceiveContactListDataError(error: "Error occured while parsing")
                return
            }
            guard let content = responseData else {
                self?.contactListDelegate?.didReceiveContactListDataError(error: "No data received")
                return
            }
            guard let jsonData = (try? JSONSerialization.jsonObject(with: content, options: [])) else {
                self?.contactListDelegate?.didReceiveContactListDataError(error: "Invalid Json response")
                return
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                self?.contactListDelegate?.didFetchContactListData(data: data)
            } catch {
                print(error.localizedDescription)
                self?.contactListDelegate?.didReceiveContactListDataError(error: "Cannot parse response")
            }
        }
        dataTask.resume()
    }

//    private func getJSONData(forRequestType type: NetworkManagerProtocol) -> Data {
//        switch type.requestType {
//        case .list:
//            
//        default:
//            <#code#>
//        }
//    }
}
