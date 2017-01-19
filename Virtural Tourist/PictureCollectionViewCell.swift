//
//  PictureCollectionViewCell.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 1/14/17.
//  Copyright © 2017 Carl Lee. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if picture.image == nil{
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
}
