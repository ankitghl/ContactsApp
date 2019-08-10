//
//  FieldTableViewCell.swift
//  Contacts
//
//  Created by Ankit.Gohel on 08/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class FieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fieldTextField: UITextField!
    
    var didEditText: ((String, Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    func configure(fieldType: String, fieldValue: String?) {
        switch fieldTextField.tag {
        case ContactDetailsFields.mobile.tag():
            fieldTextField.keyboardType = .phonePad
            fieldTextField.doneAccessory = true
        case ContactDetailsFields.email.tag():
            fieldTextField.keyboardType = .emailAddress
        default:
            fieldTextField.keyboardType = .default
        }
        titleLabel.text = fieldType
        fieldTextField.text = fieldValue
    }
    
    @IBAction func didChangeTextField(_ sender: UITextField) {
        guard let typedText = sender.text, !typedText.isEmpty  else { return }
        didEditText?(typedText, sender.tag)
    }
    
    
}
