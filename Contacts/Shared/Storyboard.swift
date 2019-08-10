//
//  Storyboard.swift
//  Contacts
//
//  Created by Ankit.Gohel on 08/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import Foundation
import UIKit

enum Storyboard: String {
    
    case main = "Main"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: .main)
    }
    
    func instantiateViewController<T: UIViewController>(_ type:T.Type) -> T {
        guard let vc = instance.instantiateViewController(withIdentifier: T.storyboardID) as? T else {
            fatalError("Unable to initialize the viewController : \(T.storyboardID)")
        }
        return vc
    }
}

extension UIViewController {
    class var storyboardID: String { return String(describing: self) }
    static func instantiateFromStoryboard(from storyboard: Storyboard) -> Self {
        return storyboard.instantiateViewController(self)
    }
}
