//
//  CharacterListCell.swift
//  Rick and Morty
//
//  Created by Vladimir Kholevin on 22.09.2020.
//  Copyright © 2020 Vladimir Kholevin. All rights reserved.
//

import UIKit

class CharacterListCell: UITableViewCell {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!

    override func prepareForReuse() {
        characterImageView.image = nil
    }
    
    func setupCell(withName name: String?, image: UIImage?) {
        characterNameLabel.text = name
        characterImageView.image = image
        characterImageView.layer.cornerRadius = characterImageView.frame.size.width/2
    }
    
}
