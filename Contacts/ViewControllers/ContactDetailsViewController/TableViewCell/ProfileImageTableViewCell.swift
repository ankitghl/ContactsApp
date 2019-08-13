//
//  ProfileImageTableViewCell.swift
//  Contacts
//
//  Created by Ankit.Gohel on 08/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class ProfileImageTableViewCell: UITableViewCell {

    //MARK: - Outlets -

    @IBOutlet weak var infoContainerStackView: UIStackView!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    var didButtonTap: ((UIButton) -> Void)?
    
    //MARK: - Overridden Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addGradient()
    }
    
    //MARK: - Button Tappables -
    @IBAction func didButtonTapped(_ sender: UIButton) {
        didButtonTap?(sender)
    }
    
    //MARK: - Internal Accesibles -

    func configure(details: ContactDisplayModel?) {
        guard let contact = details else { return }
        cameraButton.isHidden = true
        nameLabel.text = contact.fullName
        favouriteButton.setImage( contact.favorite ? #imageLiteral(resourceName: "favourite_button_selected") : #imageLiteral(resourceName: "favourite_button") , for: .normal)
        if contact.profileImage == "" { DispatchQueue.main.async() { self.profileImageView.image = #imageLiteral(resourceName: "icon_placeholder") } ; return }
        profileImageView.loadImage(from:  NetworkManagerRequest.baseURL + contact.profileImage)
    }
}
