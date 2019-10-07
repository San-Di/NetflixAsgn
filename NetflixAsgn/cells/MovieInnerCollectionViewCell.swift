//
//  MovieInnerCollectionViewCell.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/3/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit
import SDWebImage

class MovieInnerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewMoviePoster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//
    
    
    var data : MovieVO? {
        didSet {
            if let data = data {

                imageViewMoviePoster.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(data.poster_path ?? "")"), placeholderImage: #imageLiteral(resourceName: "placeholder"), options:  SDWebImageOptions.progressiveLoad, completed: nil)
            }
        }
    }

}
