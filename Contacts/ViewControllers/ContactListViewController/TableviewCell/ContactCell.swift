//
//  ContactCell.swift
//  Contacts
//
//  Created by Ankit.Gohel on 08/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var contactPhotoView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactFavouriteImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contactPhotoView.layer.cornerRadius = contactPhotoView.frame.size.height/2
        contactPhotoView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contactPhotoView.image = nil
        contactNameLabel.text = ""
        contactFavouriteImageView.isHidden = true
    }

}
