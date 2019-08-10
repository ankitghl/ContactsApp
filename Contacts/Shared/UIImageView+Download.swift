//
//  UIImageView+Download.swift
//  Contacts
//
//  Created by Ankit.Gohel on 10/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloaded(from url: URL, placeholder: UIImage) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200, error == nil else {
                DispatchQueue.main.async() { self.image = placeholder }
                return
            }
            var image: UIImage?
            if let data = data {
                image = UIImage(data: data)
            } else {
                image = placeholder
            }
            DispatchQueue.main.async() { self.image = image }
            }.resume()
    }
    
    func loadImage(from link: String, placeholder: UIImage = #imageLiteral(resourceName: "placeholder_photo")) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, placeholder: placeholder)
    }
}

