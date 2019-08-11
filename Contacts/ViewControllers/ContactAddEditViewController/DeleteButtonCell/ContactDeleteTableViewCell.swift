//
//  ContactDeleteTableViewCell.swift
//  Contacts
//
//  Created by Ankit.Gohel on 10/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class ContactDeleteTableViewCell: UITableViewCell {

    //MARK: - Variables -
    var didTapDelete: (() -> Void)?
    
    //MARK: - Button Tappables -
    
    @IBAction func didTapDeleteButton(_ sender: UIButton) {
        didTapDelete?()
    }

}
