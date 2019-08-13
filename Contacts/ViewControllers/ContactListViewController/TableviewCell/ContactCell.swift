//
//  ContactCell.swift
//  Contacts
//
//  Created by Ankit.Gohel on 08/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    //MARK: - Outlets -

    @IBOutlet weak var contactPhotoView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactFavouriteImageView: UIImageView!
    
    //MARK: - Overridden Methods -

    override func layoutSubviews() {
        super.layoutSubviews()
        contactPhotoView.layer.cornerRadius = contactPhotoView.frame.size.height/2
        contactPhotoView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contactPhotoView.image = UIImage(named: "placeholder_photo")
        contactNameLabel.text = ""
        contactFavouriteImageView.isHidden = true
    }

    //MARK: - Internal Accessibles -
    func displayData(contact: Contact) {
        contactNameLabel.text = contact.fullName
        if let _favourite = contact.favorite {
            contactFavouriteImageView.isHidden = !_favourite
        } else {
            contactFavouriteImageView.isHidden = false
        }
        guard let profilePic = contact.profilePic else {
            return
        }
        contactPhotoView.loadImage(from: NetworkManagerRequest.baseURL + profilePic, placeholder: UIImage(named: "placeholder_photo") ?? UIImage())
    }

}
