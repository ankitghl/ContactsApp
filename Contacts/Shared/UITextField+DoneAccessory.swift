//
//  UITextField+DoneAccessory.swift
//  Contacts
//
//  Created by Ankit.Gohel on 09/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    @IBInspectable var doneAccessory: Bool{
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone {
                addDoneAccessoryButtonOnKeyboard()
            }
        }
    }
    
    func addDoneAccessoryButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: MiscellaneousConstants.doneAccessoryButtonHeight.rawValue))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
